import Foundation
import PackagePlugin

struct PackagingPlanner {
    let options: PackageToJS.Options
    let context: PluginContext
    let selfPackage: Package
    let selfPath: String
    let outputDir: URL
    let wasmFilename = "main.wasm"

    init(
        options: PackageToJS.Options, context: PluginContext, selfPackage: Package,
        outputDir: URL
    ) {
        self.options = options
        self.context = context
        self.selfPackage = selfPackage
        self.outputDir = outputDir
        self.selfPath = String(#filePath)
    }

    private static func syncFile(from: String, to: String) throws {
        if FileManager.default.fileExists(atPath: to) {
            try FileManager.default.removeItem(atPath: to)
        }
        try FileManager.default.copyItem(atPath: from, toPath: to)
    }

    private static func createDirectory(atPath: String) throws {
        guard !FileManager.default.fileExists(atPath: atPath) else { return }
        try FileManager.default.createDirectory(
            atPath: atPath, withIntermediateDirectories: true, attributes: nil
        )
    }

    private static func runCommand(_ command: URL, _ arguments: [String]) throws {
        let task = Process()
        task.executableURL = command
        task.arguments = arguments
        task.currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        try task.run()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw PackageToJSError("Command failed with status \(task.terminationStatus)")
        }
    }

    /// Construct the build plan and return the root task key
    func planBuild(
        make: inout MiniMake,
        wasmProductArtifact: URL
    ) throws -> MiniMake.TaskKey {
        let (allTasks, _) = try planBuildInternal(make: &make, wasmProductArtifact: wasmProductArtifact)
        return make.addTask(
            inputTasks: allTasks, output: "all", attributes: [.phony, .silent]
        ) { _ in }
    }

    private func planBuildInternal(
        make: inout MiniMake,
        wasmProductArtifact: URL
    ) throws -> (allTasks: [MiniMake.TaskKey], outputDirTask: MiniMake.TaskKey) {
        // Prepare output directory
        let outputDirTask = make.addTask(
            inputFiles: [selfPath], output: outputDir.path, attributes: [.silent]
        ) {
            try Self.createDirectory(atPath: $0.output)
        }

        var packageInputs: [MiniMake.TaskKey] = []

        // Guess the build configuration from the parent directory name of .wasm file
        let buildConfiguration = wasmProductArtifact.deletingLastPathComponent().lastPathComponent
        let wasm: MiniMake.TaskKey

        let shouldOptimize: Bool
        let wasmOptPath = try? which("wasm-opt")
        if buildConfiguration == "debug" {
            shouldOptimize = false
        } else {
            if wasmOptPath != nil {
                shouldOptimize = true
            } else {
                print("Warning: wasm-opt not found in PATH, skipping optimizations")
                shouldOptimize = false
            }
        }

        if let wasmOptPath = wasmOptPath, shouldOptimize {
            // Optimize the wasm in release mode
            let tmpDir = outputDir.deletingLastPathComponent().appending(path: "\(outputDir.lastPathComponent).tmp")
            let tmpDirTask = make.addTask(
                inputFiles: [selfPath], output: tmpDir.path, attributes: [.silent]
            ) {
                try Self.createDirectory(atPath: $0.output)
            }
            let stripWasmPath = tmpDir.appending(path: wasmFilename + ".strip").path

            // First, strip DWARF sections as their existence enables DWARF preserving mode in wasm-opt
            let stripWasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact.path], inputTasks: [outputDirTask, tmpDirTask],
                output: stripWasmPath
            ) {
                print("Stripping debug information...")
                try Self.runCommand(wasmOptPath, [wasmProductArtifact.path, "--strip-dwarf", "--debuginfo", "-o", $0.output])
            }
            // Then, run wasm-opt with all optimizations
            wasm = make.addTask(
                inputFiles: [selfPath], inputTasks: [outputDirTask, stripWasm],
                output: outputDir.appending(path: wasmFilename).path
            ) {
                print("Optimizing the wasm file...")
                try Self.runCommand(wasmOptPath, [stripWasmPath, "--debuginfo", "-Os", "-o", $0.output])
            }
        } else {
            // Copy the wasm product artifact
            wasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact.path], inputTasks: [outputDirTask],
                output: outputDir.appending(path: wasmFilename).path
            ) {
                try Self.syncFile(from: wasmProductArtifact.path, to: $0.output)
            }
        }
        packageInputs.append(wasm)

        // Write package.json
        let packageJSON = make.addTask(
            inputFiles: [selfPath], inputTasks: [outputDirTask],
            output: outputDir.appending(path: "package.json").path
        ) {
            let packageJSON = """
                {
                    "name": "\(options.packageName ?? context.package.id.lowercased())",
                    "version": "0.0.0",
                    "type": "module",
                    "exports": {
                        ".": "./index.js",
                        "./wasm": "./\(wasmFilename)"
                    },
                    "dependencies": {
                        "@bjorn3/browser_wasi_shim": "^0.4.1"
                    }
                }
                """
            try packageJSON.write(toFile: $0.output, atomically: true, encoding: .utf8)
        }
        packageInputs.append(packageJSON)

        // Copy the template files
        for (file, output) in [
            ("Plugins/PackageToJS/Templates/index.js", "index.js"),
            ("Plugins/PackageToJS/Templates/index.d.ts", "index.d.ts"),
            ("Plugins/PackageToJS/Templates/instantiate.js", "instantiate.js"),
            ("Plugins/PackageToJS/Templates/instantiate.d.ts", "instantiate.d.ts"),
            ("Sources/JavaScriptKit/Runtime/index.mjs", "runtime.js"),
        ] {
            packageInputs.append(planCopyTemplateFile(
                make: &make, file: file, output: output, outputDirTask: outputDirTask,
                inputs: []
            ))
        }
        return (packageInputs, outputDirTask)
    }

    /// Construct the test build plan and return the root task key
    func planTestBuild(
        make: inout MiniMake,
        wasmProductArtifact: URL
    ) throws -> (rootTask: MiniMake.TaskKey, binDir: URL) {
        var (allTasks, outputDirTask) = try planBuildInternal(make: &make, wasmProductArtifact: wasmProductArtifact)

        let binDir = outputDir.appending(path: "bin")
        let binDirTask = make.addTask(
            inputFiles: [selfPath], inputTasks: [outputDirTask],
            output: binDir.path
        ) {
            try Self.createDirectory(atPath: $0.output)
        }
        allTasks.append(binDirTask)

        // Copy the template files
        for (file, output) in [
            ("Plugins/PackageToJS/Templates/test.js", "test.js"),
            ("Plugins/PackageToJS/Templates/test.d.ts", "test.d.ts"),
            ("Plugins/PackageToJS/Templates/bin/test.js", "bin/test.js"),
        ] {
            allTasks.append(planCopyTemplateFile(
                make: &make, file: file, output: output, outputDirTask: outputDirTask,
                inputs: [binDirTask]
            ))
        }
        let rootTask = make.addTask(
            inputTasks: allTasks, output: "all", attributes: [.phony, .silent]
        ) { _ in }
        return (rootTask, binDir)
    }

    private func planCopyTemplateFile(
        make: inout MiniMake,
        file: String,
        output: String,
        outputDirTask: MiniMake.TaskKey,
        inputs: [MiniMake.TaskKey]
    ) -> MiniMake.TaskKey {
        let inputPath = selfPackage.directoryURL.appending(path: file)
        let substitutions = [
            "@PACKAGE_TO_JS_MODULE_PATH@": wasmFilename
        ]
        return make.addTask(
            inputFiles: [selfPath, inputPath.path], inputTasks: [outputDirTask] + inputs,
            output: outputDir.appending(path: output).path
        ) {
            var content = try String(contentsOf: inputPath, encoding: .utf8)
            for (key, value) in substitutions {
                content = content.replacingOccurrences(of: key, with: value)
            }
            try content.write(toFile: $0.output, atomically: true, encoding: .utf8)
        }
    }
}
