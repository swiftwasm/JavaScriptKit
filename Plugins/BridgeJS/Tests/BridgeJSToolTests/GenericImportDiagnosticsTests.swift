import Foundation
import Testing

@testable import BridgeJSCore
@testable import BridgeJSLink
@testable import BridgeJSSkeleton

@Suite struct GenericImportDiagnosticsTests {

    @Test(arguments: [
        ("protocol P {}", "BridgedSwiftGenericBridgeable & P", "unsupported constraint 'P'"),
        ("@JS protocol P {}", "P", "missing the 'BridgedSwiftGenericBridgeable' constraint"),
    ])
    func invalidProtocolConstraint(declaration: String, constraint: String, diagnostic: String) {
        expectDiagnostic(
            source: "\(declaration)\n@JSFunction func f<T: \(constraint)>(_ value: T) throws(JSException) -> T",
            contains: diagnostic
        )
    }

    @Test func qualifiedExternalProtocolConstraint() throws {
        let dependency = try makeSkeleton(
            "@JS public protocol Node: BridgedSwiftGenericBridgeable {}",
            moduleName: "GraphKit"
        )
        let decoded = try JSONDecoder().decode(BridgeJSSkeleton.self, from: JSONEncoder().encode(dependency))
        let skeleton = try makeSkeleton(
            """
            import GraphKit
            protocol Node {}
            @JSFunction func f<T: GraphKit.Node>(_ value: T) throws(JSException) -> T
            """,
            dependencies: [(moduleName: "GraphKit", skeleton: decoded)]
        )
        let roundTrip = try JSONDecoder().decode(BridgeJSSkeleton.self, from: JSONEncoder().encode(skeleton))
        let imported = try #require(roundTrip.imported)
        #expect(
            imported.children.flatMap(\.functions).first?.genericParameters == [
                GenericParameter(name: "T", constraints: ["Node"], swiftConstraints: ["GraphKit.Node"])
            ]
        )
        let glue = try #require(
            try ImportTS(progress: .silent, moduleName: skeleton.moduleName, skeleton: imported).finalize()
        )
        #expect(glue.contains("T: BridgedSwiftGenericBridgeable & GraphKit.Node"))
        #expect(roundTrip.usedExternalModules == ["GraphKit"])
    }

    @Test func refinedProtocolRequirementsAndAdapter() throws {
        let skeleton = try makeSkeleton(
            """
            @JS(namespace: "API") protocol Base: BridgedSwiftGenericBridgeable {
                func read() -> Int
                var value: Int { get set }
            }
            @JS protocol Middle: Base {}
            @JS("PublicNode", namespace: "API") protocol Node: Middle {
                var value: Int { get }
            }
            @JSFunction func f<T: Node>(_ value: T) throws(JSException) -> T
            """
        )
        let exported = try #require(skeleton.exported)
        let node = try #require(exported.protocols.first { $0.name == "Node" })
        #expect(node.methods.isEmpty)
        #expect(node.properties.map(\.name) == ["value"])
        #expect(node.inheritedJSProtocols == ["Middle"])
        #expect(node.jsName == "PublicNode")
        #expect(
            exported.genericBridgeableTypeEntries.contains {
                $0.swiftName == "AnyNode" && $0.bridgeType == .swiftProtocol("Node")
            }
        )
        let glue = try #require(
            try ExportSwift(progress: .silent, moduleName: skeleton.moduleName, skeleton: exported).finalize()
        )
        #expect(glue.contains("extension Base where Self: _BridgedSwiftProtocolWrapper {"))
        #expect(glue.contains("extension Node where Self: _BridgedSwiftProtocolWrapper {"))
        #expect(!glue.contains("extension Middle where Self"))
        #expect(glue.contains("struct AnyNode: Node, _BridgedSwiftProtocolWrapper {"))
        #expect(glue.contains("name: \"bjs_Base_read\""))
        #expect(!glue.contains("bjs_Node_read"))
        let linked = try BridgeJSLink(skeletons: [skeleton]).link()
        #expect(linked.outputDts.contains("f<T extends PublicNode>"))
        #expect(linked.outputDts.contains("export interface PublicNode extends Middle {"))
        #expect(linked.outputDts.contains("export interface Middle extends Base {"))
    }

    @Test func externalProtocolRefinementIsRejected() throws {
        let dependency = try makeSkeleton("@JS public protocol Base {}", moduleName: "GraphKit")
        do {
            _ = try makeSkeleton(
                "import GraphKit\n@JS protocol Child: GraphKit.Base {}",
                dependencies: [(moduleName: "GraphKit", skeleton: dependency)]
            )
            Issue.record("Expected external refinement diagnostic")
        } catch let error as BridgeJSCoreDiagnosticError {
            #expect(
                error.diagnostics.contains {
                    $0.diagnostic.message.contains("from another module is not supported")
                }
            )
        }
    }

    @Test func legacyGenericParameterDecoding() throws {
        let constructor = try JSONDecoder().decode(
            ImportedConstructorSkeleton.self,
            from: Data(#"{"parameters":[],"genericParameters":["T"]}"#.utf8)
        )
        #expect(constructor.genericParameters == [GenericParameter(name: "T")])
    }

    @Test
    func genericParameterRequiresBridgeableConstraint() {
        expectDiagnostic(
            source: """
                @JSFunction func identity<T>(_ value: T) throws(JSException) -> T
                """,
            contains: "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable'"
        )
    }

    @Test
    func genericWhereClauseUnsupported() {
        expectDiagnostic(
            source: """
                @JSFunction func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T where T: Sendable
                """,
            contains: "'where' clauses are not supported on @JSFunction"
        )
    }

    @Test
    func asyncGenericImportUnsupported() {
        expectDiagnostic(
            source: """
                @JSFunction func identityAsync<T: BridgedSwiftGenericBridgeable>(_ value: T) async throws(JSException) -> T
                """,
            contains: "Generic @JSFunction declarations cannot be 'async' yet."
        )
    }

    @Test
    func genericImportedMethodIsParsed() throws {
        let skeleton = try makeSkeleton(
            """
            @JSClass struct Box {
                @JSFunction func member<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
            }
            """,
            moduleName: "App"
        )
        let imported = try #require(skeleton.imported)
        let types = imported.children.flatMap { $0.types }
        let box = try #require(types.first { $0.name == "Box" })
        let method = try #require(box.methods.first { $0.name == "member" })
        #expect(method.genericParameters == [GenericParameter(name: "T")])
    }

    @Test
    func genericImportedConstructorIsParsed() throws {
        let skeleton = try makeSkeleton(
            """
            @JSClass struct Box {
                @JSFunction init<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException)
            }
            """,
            moduleName: "App"
        )
        let imported = try #require(skeleton.imported)
        let types = imported.children.flatMap { $0.types }
        let box = try #require(types.first { $0.name == "Box" })
        let constructor = try #require(box.constructor)
        #expect(constructor.genericParameters == [GenericParameter(name: "T")])
        #expect(constructor.parameters.map(\.type) == [.generic("T")])
    }

    @Test
    func genericImportedConstructorUnconstrainedParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction init<T>(_ value: T) throws(JSException)
                }
                """,
            contains:
                "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable' to be used with @JSFunction."
        )
    }

    @Test
    func genericImportedConstructorUnusedTypeParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction init<T: BridgedSwiftGenericBridgeable>(_ value: Int) throws(JSException)
                }
                """,
            contains:
                "The generic parameter 'T' must be used in a parameter of a generic @JSFunction initializer."
        )
    }

    @Test
    func genericImportedConstructorAsyncIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction init<T: BridgedSwiftGenericBridgeable>(_ value: T) async throws(JSException)
                }
                """,
            contains: "Generic @JSFunction declarations cannot be 'async' yet."
        )
    }

    @Test
    func genericImportedConstructorUnsupportedWrapperFormIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction init<T: BridgedSwiftGenericBridgeable>(_ value: [[T]]) throws(JSException)
                }
                """,
            contains: "may only be used as a bare type"
        )
    }

    @Test(arguments: [
        ("[[T]]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: [[T]]) throws(JSException)"),
        ("[T?]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: [T?]) throws(JSException)"),
        ("T??", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T??) throws(JSException)"),
        ("[Int: T]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: [Int: T]) throws(JSException)"),
    ])
    func unsupportedGenericWrapperFormsInParameter(label: String, source: String) {
        expectDiagnostic(
            source: source,
            contains: "may only be used as a bare type"
        )
    }

    @Test(arguments: [
        ("[[T]]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> [[T]]"),
        ("[T?]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> [T?]"),
        ("T??", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> T??"),
        ("[Int: T]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> [Int: T]"),
    ])
    func unsupportedGenericWrapperFormsInReturn(label: String, source: String) {
        expectDiagnostic(
            source: source,
            contains: "may only be used as a bare type"
        )
    }

    @Test
    func genericImportedMethodAsyncIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction func member<T: BridgedSwiftGenericBridgeable>(_ value: T) async throws(JSException) -> T
                }
                """,
            contains: "Generic @JSFunction declarations cannot be 'async' yet."
        )
    }

    @Test
    func genericImportedMethodUnconstrainedParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction func member<T>(_ value: T) throws(JSException) -> T
                }
                """,
            contains:
                "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable' to be used with @JSFunction."
        )
    }

    @Test
    func genericImportedFunctionUnusedTypeParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSFunction func unused<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> Int
                """,
            contains:
                "The generic parameter 'T' must be used in a parameter or return type of a generic @JSFunction declaration."
        )
    }

    @Test
    func genericImportedMethodUnusedTypeParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction func member<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> Int
                }
                """,
            contains:
                "The generic parameter 'T' must be used in a parameter or return type of a generic @JSFunction declaration."
        )
    }

    @Test
    func genericImportedReturnOnlyTypeParamIsAllowed() throws {
        let skeleton = try makeSkeleton(
            """
            @JSFunction func make<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> T
            """,
            moduleName: "App"
        )
        let imported = try #require(skeleton.imported)
        let functions = imported.children.flatMap { $0.functions }
        let function = try #require(functions.first { $0.name == "make" })
        #expect(function.genericParameters == [GenericParameter(name: "T")])
    }
}
