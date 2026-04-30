import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct CrossModuleResolutionTests {
    @Test
    func resolvesTopLevelExternalStruct() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: """
                @JS public struct Vector3D {
                    public let x: Double
                    public let y: Double
                    public let z: Double
                    @JS public init(x: Double, y: Double, z: Double) {
                        self.x = x; self.y = y; self.z = z
                    }
                }
                """
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func currentVelocity() -> Vector3D {
                    Vector3D(x: 0, y: 0, z: 0)
                }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        #expect(app.usedExternalModules == ["Core"])
        let function = try #require(app.exported?.functions.first(where: { $0.name == "currentVelocity" }))
        #expect(function.returnType == .swiftStruct("Vector3D"))
    }

    @Test
    func resolvesTopLevelExternalClass() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: """
                @JS public class Emitter {
                    @JS public init() {}
                    @JS public func emit() -> String { "" }
                }
                """
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func makeEmitter() -> Emitter { Emitter() }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        #expect(app.usedExternalModules == ["Core"])
        let function = try #require(app.exported?.functions.first(where: { $0.name == "makeEmitter" }))
        #expect(function.returnType == .swiftHeapObject("Emitter"))
    }

    @Test
    func resolvesNestedExternalStruct() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: """
                @JS public enum Geometry {
                    @JS public struct BoundingBox {
                        public let side: Double
                        @JS public init(side: Double) { self.side = side }
                    }
                }
                """
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func unitBox() -> Geometry.BoundingBox {
                    Geometry.BoundingBox(side: 1)
                }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        #expect(app.usedExternalModules == ["Core"])
        let function = try #require(app.exported?.functions.first(where: { $0.name == "unitBox" }))
        #expect(function.returnType == .swiftStruct("Geometry.BoundingBox"))
    }

    @Test
    func resolvesExplicitModuleQualifier() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: """
                @JS public struct Vector3D {
                    @JS public init() {}
                }
                """
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func fromCore() -> Core.Vector3D { Core.Vector3D() }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "fromCore" }))
        #expect(function.returnType == .swiftStruct("Vector3D"))
    }

    @Test
    func resolvesExternalTypeInArrayAndOptional() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: """
                @JS public struct Point {
                    @JS public init() {}
                }
                """
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func scatter(points: [Point?]) -> Point? { nil }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "scatter" }))
        #expect(function.returnType == .nullable(.swiftStruct("Point"), .null))
        #expect(function.parameters.first?.type == .array(.nullable(.swiftStruct("Point"), .null)))
    }

    // MARK: - Diagnostics

    @Test
    func ambiguousExternalNameProducesDiagnostic() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let graphics = try buildDependencySkeleton(
            moduleName: "Graphics",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )

        do {
            _ = try resolveApp(
                source: """
                    import Core
                    import Graphics
                    @JS public func ambiguous() -> Vector3D { fatalError() }
                    """,
                dependencies: [
                    (moduleName: "Core", skeleton: core),
                    (moduleName: "Graphics", skeleton: graphics),
                ]
            )
            Issue.record("Expected ambiguity diagnostic, but resolution succeeded")
        } catch let error as BridgeJSCoreDiagnosticError {
            let combined = error.diagnostics.map(\.diagnostic.message).joined(separator: "\n")
            #expect(combined.contains("ambiguous use of 'Vector3D'"))
            let combinedHints = error.diagnostics.compactMap(\.diagnostic.hint).joined(separator: "\n")
            #expect(combinedHints.contains("Core"))
            #expect(combinedHints.contains("Graphics"))
        }
    }

    @Test
    func explicitQualifierResolvesAmbiguity() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let graphics = try buildDependencySkeleton(
            moduleName: "Graphics",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let app = try resolveApp(
            source: """
                import Core
                import Graphics
                @JS public func fromCore() -> Core.Vector3D { Core.Vector3D() }
                """,
            dependencies: [
                (moduleName: "Core", skeleton: core),
                (moduleName: "Graphics", skeleton: graphics),
            ]
        )
        #expect(app.usedExternalModules == ["Core"])
    }

    @Test
    func localDeclarationShadowsExternalSameName() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public struct Vector3D {
                    public let id: Int
                    @JS public init(id: Int) { self.id = id }
                }
                @JS public func makeLocal() -> Vector3D { Vector3D(id: 42) }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        // Local declaration wins.
        #expect(app.usedExternalModules == [])
        let exported = try #require(app.exported)
        #expect(exported.structs.contains(where: { $0.name == "Vector3D" }))
    }

    @Test
    func unknownTypeEmitsHintMentioningDependencyTargets() throws {
        do {
            _ = try resolveApp(
                source: """
                    @JS public func use() -> MissingType { fatalError() }
                    """,
                dependencies: []
            )
            Issue.record("Expected an unsupported-type diagnostic")
        } catch let error as BridgeJSCoreDiagnosticError {
            let combinedHints = error.diagnostics.compactMap(\.diagnostic.hint).joined(separator: "\n")
            #expect(combinedHints.contains("dependency targets"))
        }
    }

    // MARK: - Coverage across type categories

    @Test
    func resolvesExternalSimpleEnum() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public enum Direction { case north, south }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func opposite(_ d: Direction) -> Direction { d }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "opposite" }))
        #expect(function.returnType == .caseEnum("Direction"))
        #expect(function.parameters.first?.type == .caseEnum("Direction"))
    }

    @Test
    func resolvesExternalRawValueEnum() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public enum HTTPMethod: String { case get, post }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func describe(_ m: HTTPMethod) -> String { "" }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "describe" }))
        #expect(function.parameters.first?.type == .rawValueEnum("HTTPMethod", .string))
    }

    @Test
    func resolvesExternalAssociatedValueEnum() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public enum Shape { case point, circle(radius: Double) }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func area(_ s: Shape) -> Double { 0 }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "area" }))
        #expect(function.parameters.first?.type == .associatedValueEnum("Shape"))
    }

    @Test
    func resolvesExternalNamespaceEnum() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: """
                @JS public enum Utils {
                    @JS public static func hello() -> String { "hi" }
                }
                """
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func dummy(_ u: Utils?) -> Utils? { u }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "dummy" }))
        #expect(function.returnType == .nullable(.namespaceEnum("Utils"), .null))
    }

    // MARK: - Structural positions

    @Test
    func resolvesExternalInDictionaryValuePosition() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func names(_ map: [String: Vector3D]) -> [String] { [] }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "names" }))
        #expect(function.parameters.first?.type == .dictionary(.swiftStruct("Vector3D")))
    }

    @Test
    func resolvesExternalInStructPropertyType() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public struct Particle {
                    public let position: Vector3D
                    @JS public init(position: Vector3D) { self.position = position }
                }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let particle = try #require(app.exported?.structs.first(where: { $0.name == "Particle" }))
        let positionProperty = try #require(particle.properties.first(where: { $0.name == "position" }))
        #expect(positionProperty.type == .swiftStruct("Vector3D"))
        #expect(app.usedExternalModules == ["Core"])
    }

    // MARK: - Multi-module scenarios

    @Test
    func tracksMultipleExternalModulesInSortedOrder() throws {
        let alpha = try buildDependencySkeleton(
            moduleName: "Alpha",
            source: "@JS public struct A { @JS public init() {} }"
        )
        let beta = try buildDependencySkeleton(
            moduleName: "Beta",
            source: "@JS public struct B { @JS public init() {} }"
        )
        let app = try resolveApp(
            source: """
                import Alpha
                import Beta
                @JS public func both(_ a: A, _ b: B) -> String { "" }
                """,
            dependencies: [
                (moduleName: "Beta", skeleton: beta),
                (moduleName: "Alpha", skeleton: alpha),
            ]
        )
        #expect(app.usedExternalModules == ["Alpha", "Beta"])
    }

    @Test
    func transitiveDependencyTypesResolve() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let domain = try buildDependencySkeleton(
            moduleName: "Domain",
            source: """
                @JS public struct Particle {
                    public let position: Vector3D
                    @JS public init(position: Vector3D) { self.position = position }
                }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        #expect(domain.usedExternalModules == ["Core"])
        // App can still reference Vector3D through Domain’s transitive dependency on Core.
        let app = try resolveApp(
            source: """
                import Core
                import Domain
                @JS public func position(of p: Particle) -> Vector3D { p.position }
                """,
            dependencies: [
                (moduleName: "Core", skeleton: core),
                (moduleName: "Domain", skeleton: domain),
            ]
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "position" }))
        #expect(function.returnType == .swiftStruct("Vector3D"))
        #expect(function.parameters.first?.type == .swiftStruct("Particle"))
        #expect(app.usedExternalModules == ["Core", "Domain"])
    }

    // MARK: - Skeleton serialisation round-trip

    @Test
    func skeletonRoundTripsUsedExternalModules() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        let app = try resolveApp(
            source: """
                import Core
                @JS public func origin() -> Vector3D { Vector3D() }
                """,
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(app)
        let decoded = try JSONDecoder().decode(BridgeJSSkeleton.self, from: data)
        #expect(decoded.usedExternalModules == app.usedExternalModules)
        #expect(decoded.moduleName == app.moduleName)
    }

    @Test
    func externalModuleIndexSkipsDependenciesWithoutExportedTypes() throws {
        let empty = BridgeJSSkeleton(moduleName: "Empty")
        let index = ExternalModuleIndex(dependencies: [(moduleName: "Empty", skeleton: empty)])
        #expect(index.isEmpty)
        #expect(!index.isKnownModule("Empty"))
        #expect(index.lookup(dotPath: "Whatever") == nil)
    }

    @Test
    func moduleQualifierRejectsUnknownModule() throws {
        let core = try buildDependencySkeleton(
            moduleName: "Core",
            source: "@JS public struct Vector3D { @JS public init() {} }"
        )
        do {
            _ = try resolveApp(
                source: """
                    import Core
                    @JS public func useFoundation() -> Foundation.URL { fatalError() }
                    """,
                dependencies: [(moduleName: "Core", skeleton: core)]
            )
            Issue.record("Expected unsupported-type diagnostic for Foundation.URL")
        } catch let error as BridgeJSCoreDiagnosticError {
            let combinedMessages = error.diagnostics.map(\.diagnostic.message).joined(separator: "\n")
            #expect(combinedMessages.contains("Foundation.URL"))
        }
    }

    // MARK: - Utillites

    private func resolveApp(
        source appSource: String,
        dependencies: [(moduleName: String, skeleton: BridgeJSSkeleton)]
    ) throws -> BridgeJSSkeleton {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "App",
            exposeToGlobal: false,
            externalModuleIndex: ExternalModuleIndex(dependencies: dependencies)
        )
        let sourceFile = Parser.parse(source: appSource)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: "App.swift")
        return try swiftAPI.finalize()
    }

    private func buildDependencySkeleton(
        moduleName: String,
        source: String,
        dependencies: [(moduleName: String, skeleton: BridgeJSSkeleton)] = []
    ) throws -> BridgeJSSkeleton {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: moduleName,
            exposeToGlobal: false,
            externalModuleIndex: ExternalModuleIndex(dependencies: dependencies)
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "\(moduleName).swift")
        return try swiftAPI.finalize()
    }
}
