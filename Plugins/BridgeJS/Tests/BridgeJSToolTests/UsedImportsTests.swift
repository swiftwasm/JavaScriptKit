import Foundation
import SwiftParser
import Testing
@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct UsedImportsTests {
    private func makeLink(input: String) throws -> BridgeJSLink {
        let url = BridgeJSLinkTests.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty,
            javaScriptModuleExists: { BridgeJSLinkTests.existingModulePaths[input, default: []].contains($0) }
        )
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        return BridgeJSLink(skeletons: [try swiftAPI.finalize()])
    }

    private func matches(_ pattern: String, in js: String) throws -> Set<String> {
        let regex = try NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let matches = regex.matches(in: js, range: NSRange(js.startIndex..., in: js))
        return Set(matches.map { String(js[Range($0.range(at: 1), in: js)!]) })
    }

    /// The `module["name"] = ...` and `importObject["module"]["name"] = ...` assignments in the
    /// generated JS, keyed by module.
    private func assignedImports(_ js: String) throws -> [String: Set<String>] {
        let regex = try NSRegularExpression(
            pattern: #"^\s*(?:importObject\["(\w+)"\]|(\w+))\["(\w+)"\] = "#,
            options: .anchorsMatchLines
        )
        let matches = regex.matches(in: js, range: NSRange(js.startIndex..., in: js))
        return matches.reduce(into: [:]) { result, match in
            let moduleRange = match.range(at: 1).location != NSNotFound ? match.range(at: 1) : match.range(at: 2)
            let module = String(js[Range(moduleRange, in: js)!])
            guard module != "importObject" else { return }
            let name = String(js[Range(match.range(at: 3), in: js)!])
            result[module, default: []].insert(name)
        }
    }

    /// The names the JS declares in the module and instantiator scopes, and the import functions and
    /// helpers it assigns.
    private func declarations(_ js: String) throws -> Set<String> {
        try matches(#"^(?: {4}| {12})?(?:export )?(?:const|let|var|function|class)\s+([\w$]+)"#, in: js)
            .union(matches(#"\bas\s+([\w$]+)"#, in: js))
            .union(matches(#"^\s*((?:bjs|\w+)\["\w+"\]|(?:structHelpers|enumHelpers)\.\w+) = "#, in: js))
            .filter { !$0.hasPrefix("importObject[") }
    }

    /// The names the JS declares in any scope, including parameters. The glue never shadows the names of
    /// the module and instantiator scopes, so a use of one of those names refers to a local only if a
    /// local of that name exists.
    private func localDeclarations(_ js: String) throws -> Set<String> {
        let parameterLists = try matches(#"\(([\w$, =]*)\)\s*(?:=>|\{)"#, in: js)
        let parameters = parameterLists.flatMap { list in
            list.split(separator: ",").map { $0.split(separator: "=")[0].trimmingCharacters(in: .whitespaces) }
        }
        return try matches(#"\b(?:const|let|var|function|class)\s+([\w$]+)"#, in: js)
            .union(matches(#"\b([\w$]+)\s*=>"#, in: js))
            .union(parameters)
    }

    /// The identifiers the JS uses outside of string literals and comments, and the import functions
    /// and helpers it accesses.
    private func uses(_ js: String) throws -> Set<String> {
        let code = js.replacingOccurrences(
            of: #""(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|//.*"#,
            with: "\"\"",
            options: .regularExpression
        )
        return try matches(#"(?<![\w$.])([A-Za-z_$][\w$]*)"#, in: code)
            .union(matches(#"\b((?:bjs|\w+)\["\w+"\]|(?:structHelpers|enumHelpers)\.\w+)"#, in: js))
    }

    /// Checks that `js`, the glue left after dead code elimination, declares everything it uses that
    /// `full`, the glue with every declaration, declares, and that it is `full` with lines removed.
    private func expectConsistent(_ js: String, comparedTo full: String, _ comment: Comment) throws {
        let missing = try uses(js).intersection(declarations(full))
            .subtracting(declarations(js))
            .subtracting(localDeclarations(js))
        #expect(missing.isEmpty, "\(comment): uses undeclared \(missing.sorted())")

        // Named imports list only the kept members, so they are the only lines that change
        var fullLines = full.split(separator: "\n", omittingEmptySubsequences: false)[...]
        for line in js.split(separator: "\n", omittingEmptySubsequences: false) where !line.hasPrefix("import {") {
            guard let index = fullLines.firstIndex(of: line) else {
                Issue.record("\(comment): line missing from the full glue or out of order: \(line)")
                return
            }
            fullLines = fullLines[(index + 1)...]
        }
    }

    @Test(arguments: BridgeJSLinkTests.collectInputs(extension: ".swift"))
    func eliminationKeepsGlueConsistent(input: String) throws {
        var link = try makeLink(input: input)
        link.keepsUnusedDeclarations = true
        let full = try link.link().outputJs
        link.keepsUnusedDeclarations = false

        let all = try assignedImports(full)
        let unfiltered = try link.link().outputJs
        #expect(try link.link(usedImports: all).outputJs == unfiltered)
        try expectConsistent(unfiltered, comparedTo: full, "all imports used")

        var usedSets: [(Comment, [String: Set<String>])] = [
            ("no imports used", [:]),
            ("module imports used", all.filter { $0.key != "bjs" }),
        ]
        for (module, names) in all.sorted(by: { $0.key < $1.key }) {
            for name in names.sorted() {
                usedSets.append(("only \(module).\(name) used", [module: [name]]))
            }
        }
        for (comment, used) in usedSets {
            let js = try link.link(usedImports: used).outputJs
            try expectConsistent(js, comparedTo: full, comment)
            for (module, names) in used {
                #expect(try assignedImports(js)[module, default: []].isSuperset(of: names), "\(comment)")
            }
        }
    }

    @Test
    func dropsRuntimeHelpersOfDroppedGlue() throws {
        let link = try makeLink(input: "PrimitiveParameters.swift")
        let js = try link.link(usedImports: ["TestModule": ["bjs_check"]]).outputJs
        #expect(try assignedImports(js) == ["TestModule": ["bjs_check"]])
        #expect(js.contains("const imports = options.getImports(importsContext);"))
        #expect(js.contains("setException"))
        for helper in ["decodeString", "textEncoder", "i32Stack", "tmpRetString", "structHelpers", "bjs = {}"] {
            #expect(!js.contains(helper), "\(helper)")
        }
    }

    @Test
    func keepsHelpersOfKeptGlue() throws {
        // The dictionary codec of a generic import encodes its keys with the string codec
        let link = try makeLink(input: "GenericImports.swift")
        let js = try link.link(usedImports: ["TestModule": ["bjs_importGenericDictionary"]]).outputJs
        #expect(js.contains("__bjs_dictCodec"))
        #expect(js.contains("__bjs_stringCodec"))
    }

    @Test
    func keepsBJSImportsReferencedByGlue() throws {
        let link = try makeLink(input: "Optionals.swift")
        let js = try link.link(usedImports: ["TestModule": ["bjs_WithOptionalJSClass_intOrNull_get"]]).outputJs
        #expect(try assignedImports(js)["bjs"] == ["swift_js_return_optional_int"])
    }

    @Test
    func emitsOnlyUsedImports() throws {
        let link = try makeLink(input: "JSClass.swift")
        let unfiltered = try link.link()
        let all = try assignedImports(unfiltered.outputJs)
        let moduleImports = try #require(all["TestModule"]).sorted()
        let bjsImports = try #require(all["bjs"]).sorted()
        try #require(moduleImports.count >= 2 && bjsImports.count >= 2)

        let used: [String: Set<String>] = ["TestModule": [moduleImports[0]], "bjs": [bjsImports[0]]]
        let output = try link.link(usedImports: used)
        #expect(try assignedImports(output.outputJs) == used)
    }

    @Test
    func unusedImportsAreOptionalInDeclarations() throws {
        let link = try makeLink(input: "JSClass.swift")
        #expect(try link.link().outputDts.contains("    returnAnimatable(): Animatable;"))

        let dts = try link.link(usedImports: ["TestModule": ["bjs_Greeter_init"]]).outputDts
        #expect(dts.contains("    returnAnimatable?(): Animatable;"))
        #expect(dts.contains("    Greeter: {"))

        let noneUsed = try link.link(usedImports: [:]).outputDts
        #expect(noneUsed.contains("    Greeter?: {"))
    }

    @Test
    func emptyUsedImportsDropsAllGlue() throws {
        let link = try makeLink(input: "JSClass.swift")
        let js = try link.link(usedImports: [:]).outputJs
        #expect(try assignedImports(js).isEmpty)
        #expect(!js.contains("options.getImports"))
    }

    @Test
    func closureHelpersFollowUsedImports() throws {
        let link = try makeLink(input: "SwiftClosure.swift")
        let all = try assignedImports(link.link().outputJs)
        let make = try #require(all["bjs"]?.filter { $0.hasPrefix("make_swift_closure_") }.min())
        let invoke = try #require(all["bjs"]?.filter { $0.hasPrefix("invoke_js_callback_") }.min())

        let invokeOnly = try link.link(usedImports: ["bjs": [invoke]]).outputJs
        #expect(try assignedImports(invokeOnly) == ["bjs": [invoke]])
        #expect(!invokeOnly.contains("swiftClosureRegistry"))

        let makeOnly = try link.link(usedImports: ["bjs": [make]]).outputJs
        #expect(try assignedImports(makeOnly) == ["bjs": [make]])
        #expect(makeOnly.contains("swiftClosureRegistry"))
    }

    @Test
    func classWrappersFollowUsedImports() throws {
        let link = try makeLink(input: "SwiftClosure.swift")
        let wrapper = "bjs_Person_wrap"
        #expect(try link.link().outputJs.contains(wrapper))

        #expect(try !link.link(usedImports: [:]).outputJs.contains(wrapper))
        #expect(try link.link(usedImports: ["TestModule": [wrapper]]).outputJs.contains(wrapper))
    }
}
