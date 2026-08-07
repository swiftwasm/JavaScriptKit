import Foundation
import SwiftParser
import Testing
@testable import BridgeJSCore

/// The codegenerator emits user-supplied names (which may be Swift keywords escaped
/// with backticks in source, e.g. `` `default` ``) into three syntactically distinct
/// positions, each with different escaping rules. These tests pin the rules so the
/// generated Swift is always valid and as noise-free as possible.
///
/// See `String.backtickIfNeeded*` in `ImportTS.swift` for the implementation, and
/// `SwiftParser.IsValidIdentifier` for the underlying `isValidSwiftIdentifier(for:)`
/// semantics the contexts are built on.
@Suite struct IdentifierEscapingTests {
    // MARK: - backtickIfNeeded() — declaration position

    /// In `var`/`let`/property/`let`-binding declarations, keywords are not valid
    /// bare identifiers and must be escaped. `self` is no exception: `var self: Int`
    /// is invalid.
    @Test(arguments: [
        "class", "where", "in", "case", "continue", "break", "return", "switch",
        "as", "default", "do", "for", "if", "else", "self", "init",
        "subscript", "nil", "true", "false",
    ])
    func declarationEscapesKeywords(_ keyword: String) {
        let escaped = keyword.backtickIfNeeded()
        #expect(escaped == "`\(keyword)`")
        // The escaped form must itself be a valid declaration identifier.
        #expect(escaped.isValidSwiftIdentifier(for: .variableName))
    }

    @Test(arguments: ["foo", "myVar", "Parser", "_internal", "x", "URL"])
    func declarationLeavesRegularIdentifiersBare(_ name: String) {
        #expect(name.backtickIfNeeded() == name)
    }

    // MARK: - backtickIfNeededForMemberAccess() — `.name` position

    /// In member access position (`.name`), most keywords are valid bare: `obj.class`,
    /// `.break`, `obj.where` all compile. `self` is the exception — `obj.self` is the
    /// identity expression (returns `obj`), not an access of a property named `self`,
    /// so a property literally named `self` must be written as `` obj.`self` ``.
    @Test(arguments: [
        "class", "where", "in", "case", "continue", "break", "return", "switch",
        "as", "default", "delete", "do", "for", "if", "else",
    ])
    func memberAccessLeavesKeywordsBare(_ keyword: String) {
        // These compile bare in member position (`t.<keyword>` parses as member access).
        #expect(keyword.backtickIfNeededForMemberAccess() == keyword)
        #expect(keyword.isValidSwiftIdentifier(for: .memberAccess))
    }

    @Test func memberAccessEscapesSelf() {
        // `obj.self` is the identity expression, not a member named `self`.
        #expect("self".backtickIfNeededForMemberAccess() == "`self`")
        #expect(!"self".isValidSwiftIdentifier(for: .memberAccess))
    }

    @Test(arguments: ["foo", "myVar", "Parser", "_internal", "value"])
    func memberAccessLeavesRegularIdentifiersBare(_ name: String) {
        #expect(name.backtickIfNeededForMemberAccess() == name)
    }

    // MARK: - backtickIfNeededForLocalReference() — body reference position

    /// When referencing a parameter or local variable inside a generated function
    /// body, `self` is valid bare (it refers to the parameter), but other keywords
    /// still need escaping because they cannot appear as a bare identifier expression.
    @Test func localReferenceLeavesSelfBare() {
        #expect("self".backtickIfNeededForLocalReference() == "self")
    }

    @Test(arguments: [
        "class", "where", "in", "case", "continue", "break", "return", "switch",
        "as", "default", "do", "for", "if", "else",
    ])
    func localReferenceEscapesOtherKeywords(_ keyword: String) {
        #expect(keyword.backtickIfNeededForLocalReference() == "`\(keyword)`")
    }

    @Test(arguments: ["foo", "myVar", "value", "_internal"])
    func localReferenceLeavesRegularIdentifiersBare(_ name: String) {
        #expect(name.backtickIfNeededForLocalReference() == name)
    }

    // MARK: - Idempotency & dotted paths

    @Test(arguments: [
        "class", "self", "where", "foo", "`already`", "`self`",
    ])
    func escapingIsIdempotent(_ name: String) {
        let once = name.backtickIfNeeded()
        #expect(once.backtickIfNeeded() == once)
        let memberOnce = name.backtickIfNeededForMemberAccess()
        #expect(memberOnce.backtickIfNeededForMemberAccess() == memberOnce)
        let localOnce = name.backtickIfNeededForLocalReference()
        #expect(localOnce.backtickIfNeededForLocalReference() == localOnce)
    }

    /// A name already wrapped in backticks (e.g. straight from `TokenSyntax.text`)
    /// must not be double-wrapped.
    @Test func alreadyBacktickedNameIsNotDoubleWrapped() {
        #expect("`class`".backtickIfNeeded() == "`class`")
        #expect("`self`".backtickIfNeededForMemberAccess() == "`self`")
    }

    /// Qualified type paths (`Outer.Inner`) escape each component independently so a
    /// keyword component is escaped while regular components stay bare.
    @Test func dottedPathEscapesPerComponent() {
        #expect("Outer.Inner".backtickIfNeeded() == "Outer.Inner")
        #expect("Outer.`class`".backtickIfNeeded() == "Outer.`class`")
        // A keyword second component gets escaped; the base stays bare.
        #expect("Utils.where".backtickIfNeeded() == "Utils.`where`")
        // Member-access context leaves `where` bare, so the whole path stays bare.
        #expect("Utils.where".backtickIfNeededForMemberAccess() == "Utils.where")
        // `self` as a component is escaped in both contexts (declaration escapes it;
        // member access escapes it because `t.self` is the identity expression).
        #expect("self.foo".backtickIfNeeded() == "`self`.foo")
        #expect("self.foo".backtickIfNeededForMemberAccess() == "`self`.foo")
    }

    // MARK: - Consistency with SwiftParser's encoding

    /// The escaping must agree with `isValidSwiftIdentifier(for:)`: a name is emitted
    /// bare exactly when SwiftParser considers it a valid identifier in that context.
    /// This pins the helpers to swift-syntax's grammar rather than a hand-maintained
    /// keyword list.
    @Test(arguments: [
        "foo", "self", "class", "where", "in", "case", "continue", "break",
        "return", "switch", "as", "default", "delete", "do", "for", "if", "else",
        "init", "subscript", "nil", "true", "false", "_internal",
    ])
    func escapingAgreesWithIsValidSwiftIdentifier(_ name: String) {
        let declared = name.backtickIfNeeded()
        #expect(declared == name || !name.isValidSwiftIdentifier(for: .variableName))
        #expect(declared.hasPrefix("`") == !name.isValidSwiftIdentifier(for: .variableName))

        let member = name.backtickIfNeededForMemberAccess()
        #expect(member.hasPrefix("`") == !name.isValidSwiftIdentifier(for: .memberAccess))

        let local = name.backtickIfNeededForLocalReference()
        let localIsValidBare = name == "self" || name.isValidSwiftIdentifier(for: .variableName)
        #expect(local.hasPrefix("`") == !localIsValidBare)
    }
}
