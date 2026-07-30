import Foundation
import Testing

@testable import PackageToJS

@Suite struct PackagingPlannerTests {
    struct BuildSnapshot: Codable, Equatable {
        let npmInstalls: [String]
    }
    class TestPackagingSystem: PackagingSystem {
        var npmInstallCalls: [String] = []
        var writtenFiles: [String] = []
        func npmInstall(packageDir: String) throws {
            npmInstallCalls.append(packageDir)
        }

        func writeFile(atPath: String, content: Data) throws {
            writtenFiles.append(atPath)
            try content.write(to: URL(fileURLWithPath: atPath))
        }

        func wasmOpt(_ arguments: [String], input: String, output: String) throws {
            try FileManager.default.copyItem(
                at: URL(fileURLWithPath: input),
                to: URL(fileURLWithPath: output)
            )
        }
    }

    func snapshotBuildPlan(
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: SourceLocation = #_sourceLocation,
        variant: String? = nil,
        body: (inout MiniMake) throws -> MiniMake.TaskKey
    ) throws {
        var make = MiniMake(explain: false, printProgress: { _, _ in })
        let rootKey = try body(&make)
        let fingerprint = try make.computeFingerprint(root: rootKey, prettyPrint: true)
        try assertSnapshot(
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            variant: variant,
            input: fingerprint
        )
    }

    typealias DebugInfoFormat = PackageToJS.DebugInfoFormat

    @Test(arguments: [
        (variant: "debug", configuration: "debug", noOptimize: false, debugInfoFormat: DebugInfoFormat.none),
        (variant: "release", configuration: "release", noOptimize: false, debugInfoFormat: DebugInfoFormat.none),
        (
            variant: "release_no_optimize", configuration: "release", noOptimize: true,
            debugInfoFormat: DebugInfoFormat.none
        ),
        (variant: "release_dwarf", configuration: "release", noOptimize: false, debugInfoFormat: DebugInfoFormat.dwarf),
        (variant: "release_name", configuration: "release", noOptimize: false, debugInfoFormat: DebugInfoFormat.name),
    ])
    func planBuild(
        variant: String,
        configuration: String,
        noOptimize: Bool,
        debugInfoFormat: PackageToJS.DebugInfoFormat
    ) throws {
        let options = PackageToJS.PackageOptions()
        let system = TestPackagingSystem()
        let planner = PackagingPlanner(
            options: options,
            packageId: "test",
            intermediatesDir: BuildPath(prefix: "INTERMEDIATES"),
            selfPackageDir: BuildPath(prefix: "SELF_PACKAGE"),
            skeletons: [],
            outputDir: BuildPath(prefix: "OUTPUT"),
            wasmProductArtifact: BuildPath(prefix: "WASM_PRODUCT_ARTIFACT"),
            wasmFilename: "main.wasm",
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
            skeletons: [],
            outputDir: BuildPath(prefix: "OUTPUT"),
            wasmProductArtifact: BuildPath(prefix: "WASM_PRODUCT_ARTIFACT"),
            wasmFilename: "main.wasm",
            configuration: "debug",
            triple: "wasm32-unknown-wasi",
            selfPath: BuildPath(prefix: "PLANNER_SOURCE_PATH"),
            system: system
        )
        try snapshotBuildPlan { make in
            let (root, binDir) = try planner.planTestBuild(make: &make)
            #expect(binDir.description == "$OUTPUT/bin")
            return root
        }
    }

    @Test func editingJavaScriptModuleOnlyResyncsModules() throws {
        try withTemporaryDirectory { temporaryDirectory, _ in
            let skeleton = temporaryDirectory.appending(path: "BridgeJS.json")
            let module = temporaryDirectory.appending(path: "module.mjs")
            let wasm = temporaryDirectory.appending(path: "main.wasm")
            let plannerSource = temporaryDirectory.appending(path: "PackageToJS.swift")
            let output = temporaryDirectory.appending(path: "output")
            let intermediates = temporaryDirectory.appending(path: "intermediates")

            let bridgeSkeleton = BridgeJSSkeleton(
                moduleName: "TestModule",
                imported: ImportedModuleSkeleton(
                    children: [
                        ImportedFileSkeleton(
                            functions: [
                                ImportedFunctionSkeleton(
                                    name: "value",
                                    from: .module("/module.mjs"),
                                    parameters: [],
                                    returnType: .void
                                )
                            ],
                            types: []
                        )
                    ]
                )
            )
            try JSONEncoder().encode(bridgeSkeleton).write(to: skeleton)
            try Data("export const value = 1;\n".utf8).write(to: module)
            try Data([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00]).write(to: wasm)
            try Data().write(to: plannerSource)

            let system = TestPackagingSystem()
            let planner = PackagingPlanner(
                options: PackageToJS.PackageOptions(),
                packageId: "test",
                intermediatesDir: BuildPath(absolute: intermediates.path),
                selfPackageDir: BuildPath(
                    absolute: URL(fileURLWithPath: #filePath)
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .path
                ),
                skeletons: [
                    .init(
                        source: skeleton,
                        targetDirectory: temporaryDirectory
                    )
                ],
                outputDir: BuildPath(absolute: output.path),
                wasmProductArtifact: BuildPath(absolute: wasm.path),
                wasmFilename: "main.wasm",
                configuration: "debug",
                triple: "wasm32-unknown-wasi",
                selfPath: BuildPath(absolute: plannerSource.path),
                system: system
            )
            var make = MiniMake(printProgress: { _, _ in })
            let root = try planner.planBuild(
                make: &make,
                buildOptions: PackageToJS.BuildOptions(
                    product: "test",
                    noOptimize: false,
                    debugInfoFormat: .none,
                    packageOptions: PackageToJS.PackageOptions()
                )
            )
            let scope = MiniMake.VariableScope(variables: [:])

            try make.build(output: root, scope: scope)

            let copiedModule = output.appending(
                path: "bridge-js-modules/TestModule/module.mjs"
            )
            #expect(try String(contentsOf: copiedModule, encoding: .utf8) == "export const value = 1;\n")
            let initialLinkCount = system.writtenFiles.filter { $0.hasSuffix("/bridge-js.js") }.count
            #expect(initialLinkCount == 1)

            try Data("export const value = 2;\n".utf8).write(to: module)
            try FileManager.default.setAttributes(
                [.modificationDate: Date().addingTimeInterval(10)],
                ofItemAtPath: module.path
            )
            try make.build(output: root, scope: scope)

            #expect(try String(contentsOf: copiedModule, encoding: .utf8) == "export const value = 2;\n")
            #expect(system.writtenFiles.filter { $0.hasSuffix("/bridge-js.js") }.count == initialLinkCount)
        }
    }

    /// A bare specifier must not suppress copying of local modules that appear alongside it.
    @Test func mixedLocalAndBareModulesBothWork() throws {
        try withTemporaryDirectory { temporaryDirectory, _ in
            let skeleton = temporaryDirectory.appending(path: "BridgeJS.json")
            let module = temporaryDirectory.appending(path: "module.mjs")
            let wasm = temporaryDirectory.appending(path: "main.wasm")
            let plannerSource = temporaryDirectory.appending(path: "PackageToJS.swift")
            let output = temporaryDirectory.appending(path: "output")
            let intermediates = temporaryDirectory.appending(path: "intermediates")

            let bridgeSkeleton = BridgeJSSkeleton(
                moduleName: "TestModule",
                imported: ImportedModuleSkeleton(
                    children: [
                        ImportedFileSkeleton(
                            functions: [
                                ImportedFunctionSkeleton(
                                    name: "value",
                                    from: .module("/module.mjs"),
                                    parameters: [],
                                    returnType: .void
                                ),
                                ImportedFunctionSkeleton(
                                    name: "basename",
                                    from: .module("node:path"),
                                    parameters: [],
                                    returnType: .void
                                ),
                            ],
                            types: []
                        )
                    ]
                )
            )
            try JSONEncoder().encode(bridgeSkeleton).write(to: skeleton)
            try Data("export const value = 1;\n".utf8).write(to: module)
            try Data([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00]).write(to: wasm)
            try Data().write(to: plannerSource)

            let system = TestPackagingSystem()
            let planner = PackagingPlanner(
                options: PackageToJS.PackageOptions(),
                packageId: "test",
                intermediatesDir: BuildPath(absolute: intermediates.path),
                selfPackageDir: BuildPath(
                    absolute: URL(fileURLWithPath: #filePath)
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .path
                ),
                skeletons: [.init(source: skeleton, targetDirectory: temporaryDirectory)],
                outputDir: BuildPath(absolute: output.path),
                wasmProductArtifact: BuildPath(absolute: wasm.path),
                wasmFilename: "main.wasm",
                configuration: "debug",
                triple: "wasm32-unknown-wasi",
                selfPath: BuildPath(absolute: plannerSource.path),
                system: system
            )
            var make = MiniMake(printProgress: { _, _ in })
            let root = try planner.planBuild(
                make: &make,
                buildOptions: PackageToJS.BuildOptions(
                    product: "test",
                    noOptimize: false,
                    debugInfoFormat: .none,
                    packageOptions: PackageToJS.PackageOptions()
                )
            )
            try make.build(output: root, scope: MiniMake.VariableScope(variables: [:]))

            let copiedModule = output.appending(path: "bridge-js-modules/TestModule/module.mjs")
            #expect(try String(contentsOf: copiedModule, encoding: .utf8) == "export const value = 1;\n")
            let generated = try String(contentsOf: output.appending(path: "bridge-js.js"), encoding: .utf8)
            #expect(generated.contains("from \"node:path\""))
            #expect(generated.contains("bridge-js-modules/TestModule/module.mjs"))
        }
    }

    /// A bare specifier such as "node:path" is resolved by the JavaScript host at load
    /// time, so packaging must not look for a file on disk or copy anything for it.
    @Test func bareJavaScriptModuleIsNotCopied() throws {
        try withTemporaryDirectory { temporaryDirectory, _ in
            let skeleton = temporaryDirectory.appending(path: "BridgeJS.json")
            let wasm = temporaryDirectory.appending(path: "main.wasm")
            let plannerSource = temporaryDirectory.appending(path: "PackageToJS.swift")
            let output = temporaryDirectory.appending(path: "output")
            let intermediates = temporaryDirectory.appending(path: "intermediates")

            let bridgeSkeleton = BridgeJSSkeleton(
                moduleName: "TestModule",
                imported: ImportedModuleSkeleton(
                    children: [
                        ImportedFileSkeleton(
                            functions: [
                                ImportedFunctionSkeleton(
                                    name: "basename",
                                    from: .module("node:path"),
                                    parameters: [],
                                    returnType: .void
                                )
                            ],
                            types: []
                        )
                    ]
                )
            )
            try JSONEncoder().encode(bridgeSkeleton).write(to: skeleton)
            try Data([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00]).write(to: wasm)
            try Data().write(to: plannerSource)

            let system = TestPackagingSystem()
            let planner = PackagingPlanner(
                options: PackageToJS.PackageOptions(),
                packageId: "test",
                intermediatesDir: BuildPath(absolute: intermediates.path),
                selfPackageDir: BuildPath(
                    absolute: URL(fileURLWithPath: #filePath)
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .path
                ),
                skeletons: [
                    .init(
                        source: skeleton,
                        targetDirectory: temporaryDirectory
                    )
                ],
                outputDir: BuildPath(absolute: output.path),
                wasmProductArtifact: BuildPath(absolute: wasm.path),
                wasmFilename: "main.wasm",
                configuration: "debug",
                triple: "wasm32-unknown-wasi",
                selfPath: BuildPath(absolute: plannerSource.path),
                system: system
            )
            var make = MiniMake(printProgress: { _, _ in })
            let root = try planner.planBuild(
                make: &make,
                buildOptions: PackageToJS.BuildOptions(
                    product: "test",
                    noOptimize: false,
                    debugInfoFormat: .none,
                    packageOptions: PackageToJS.PackageOptions()
                )
            )
            try make.build(output: root, scope: MiniMake.VariableScope(variables: [:]))

            #expect(!FileManager.default.fileExists(atPath: output.appending(path: "bridge-js-modules").path))
            let generated = try String(
                contentsOf: output.appending(path: "bridge-js.js"),
                encoding: .utf8
            )
            #expect(generated.contains("from \"node:path\""))
        }
    }
}
