import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct AvailabilityIndexTests {
    private static let core = """
        @available(macOS 14.0, *)
        @JS public struct Point {
            public var x: Int
        }
        """

    @Test func importThunkNamingADependencyTypeCarriesItsAttributes() throws {
        let core = try makeSkeleton(Self.core, moduleName: "Core")
        let app = try makeSkeleton(
            """
            import Core
            @JSFunction func draw(_ point: Point) throws(JSException)
            """,
            moduleName: "App",
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let importTS = ImportTS(
            progress: .silent,
            moduleName: "App",
            skeleton: try #require(app.imported),
            availability: AvailabilityIndex(skeletons: [app, core])
        )
        let output = try #require(try importTS.finalize())
        #expect(output.contains("@available(macOS 14.0, *)\nfunc _$draw(_ point: Point) throws(JSException)"))
    }

    @Test func moduleTypeKeepsItsAttributesOverADependencyTypeOfTheSameName() throws {
        let core = try makeSkeleton(Self.core, moduleName: "Core")
        let app = try makeSkeleton(
            """
            @available(macOS 15.0, *)
            @JS struct Point {
                var x: Int
            }
            """,
            moduleName: "App",
            dependencies: [(moduleName: "Core", skeleton: core)]
        )
        let index = AvailabilityIndex(skeletons: [app, core])
        #expect(index.attributes(for: [.swiftStruct("Point")]) == ["@available(macOS 15.0, *)"])
    }

    @Test(arguments: [
        (BridgeType.array(.swiftStruct("Point")), ["@available(macOS 14.0, *)"]),
        (.nullable(.swiftStruct("Point"), .null), ["@available(macOS 14.0, *)"]),
        (.dictionary(.swiftStruct("Point")), ["@available(macOS 14.0, *)"]),
        (
            .alias(name: "Tag", underlying: .swiftHeapObject("TagReference")),
            ["@available(macOS 15.0, *)", "@available(macOS 13.0, *)"]
        ),
        (.array(.jsUniqueObject("Element")), ["@available(anyAppleOS 27.0, *)", "@available(macOS 14.0, *)"]),
    ])
    func compositeTypeCarriesTheAttributesOfTheTypesItContains(type: BridgeType, attributes: [String]) throws {
        let skeleton = try makeSkeleton(
            """
            @available(macOS 14.0, *)
            @JS struct Point {
                var x: Int
            }

            @available(macOS 15.0, *)
            @JS(as: TagReference.self) struct Tag {
                var name: String
            }

            @available(macOS 13.0, *)
            @JS final class TagReference {
                @JS init(name: String) {}
            }

            @available(macOS 14.0, *)
            @JSClass struct Element: ~Copyable {
                @JSFunction func id() throws(JSException) -> Int
            }
            """,
            moduleName: "App"
        )
        #expect(AvailabilityIndex(skeletons: [skeleton]).attributes(for: [type]) == attributes)
    }
}
