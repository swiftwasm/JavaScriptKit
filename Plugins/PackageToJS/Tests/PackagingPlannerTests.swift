import Foundation
import Testing

@testable import PackageToJS

@Suite struct PackagingPlannerTests {
    struct BuildSnapshot: Codable, Equatable {
        let npmInstalls: [String]
    }
    class TestPackagingSystem: PackagingSystem {
        var npmInstallCalls: [String] = []
        func npmInstall(packageDir: String) throws {
            npmInstallCalls.append(packageDir)
        }

        func wasmOpt(_ arguments: [String], input: String, output: String) throws {
            try FileManager.default.copyItem(
                at: URL(fileURLWithPath: input), to: URL(fileURLWithPath: output))
        }
    }

    func snapshotBuildPlan(
        filePath: String = #filePath, function: String = #function,
        sourceLocation: SourceLocation = #_sourceLocation,
        variant: String? = nil,
        body: (inout MiniMake) throws -> MiniMake.TaskKey
    ) throws {
        var make = MiniMake(explain: false, printProgress: { _, _ in })
        let rootKey = try body(&make)
        let fingerprint = try make.computeFingerprint(root: rootKey, prettyPrint: true)
        try assertSnapshot(
            filePath: filePath, function: function, sourceLocation: sourceLocation,
            variant: variant, input: fingerprint
        )
    }

    typealias DebugInfoFormat = PackageToJS.DebugInfoFormat

    @Test(arguments: [
        (variant: "debug", configuration: "debug", noOptimize: false, debugInfoFormat: DebugInfoFormat.none),
        (variant: "release", configuration: "release", noOptimize: false, debugInfoFormat: DebugInfoFormat.none),
        (variant: "release_no_optimize", configuration: "release", noOptimize: true, debugInfoFormat: DebugInfoFormat.none),
        (variant: "release_dwarf", configuration: "release", noOptimize: false, debugInfoFormat: DebugInfoFormat.dwarf),
        (variant: "release_name", configuration: "release", noOptimize: false, debugInfoFormat: DebugInfoFormat.name),
    ])
    func planBuild(variant: String, configuration: String, noOptimize: Bool, debugInfoFormat: PackageToJS.DebugInfoFormat) throws {
        let options = PackageToJS.PackageOptions()
        let system = TestPackagingSystem()
        let planner = PackagingPlanner(
            options: options,
            packageId: "test",
            intermediatesDir: BuildPath(prefix: "INTERMEDIATES"),
            selfPackageDir: BuildPath(prefix: "SELF_PACKAGE"),
            outputDir: BuildPath(prefix: "OUTPUT"),
            wasmProductArtifact: BuildPath(prefix: "WASM_PRODUCT_ARTIFACT"),
            configuration: configuration,
            triple: "wasm32-unknown-wasi",
            selfPath: BuildPath(prefix: "PLANNER_SOURCE_PATH"),
            system: system
        )
        try snapshotBuildPlan(variant: variant) { make in
            try planner.planBuild(
                make: &make,
                buildOptions: PackageToJS.BuildOptions(
                    product: "test",
                    noOptimize: noOptimize,
                    debugInfoFormat: debugInfoFormat,
                    packageOptions: options
                )
            )
        }
    }

    @Test func planTestBuild() throws {
        let options = PackageToJS.PackageOptions()
        let system = TestPackagingSystem()
        let planner = PackagingPlanner(
            options: options,
            packageId: "test",
            intermediatesDir: BuildPath(prefix: "INTERMEDIATES"),
            selfPackageDir: BuildPath(prefix: "SELF_PACKAGE"),
            outputDir: BuildPath(prefix: "OUTPUT"),
            wasmProductArtifact: BuildPath(prefix: "WASM_PRODUCT_ARTIFACT"),
            configuration: "debug",
            triple: "wasm32-unknown-wasi",
            selfPath: BuildPath(prefix: "PLANNER_SOURCE_PATH"),
            system: system
        )
        try snapshotBuildPlan() { make in
            let (root, binDir) = try planner.planTestBuild(make: &make)
            #expect(binDir.description == "$OUTPUT/bin")
            return root
        }
    }
}
