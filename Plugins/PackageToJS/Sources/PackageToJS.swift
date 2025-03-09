import Foundation

struct PackageToJS {
    struct PackageOptions {
        /// Path to the output directory
        var outputPath: String?
        /// Name of the package (default: lowercased Package.swift name)
        var packageName: String?
        /// Whether to explain the build plan
        var explain: Bool = false
    }

    struct BuildOptions {
        /// Product to build (default: executable target if there's only one)
        var product: String?
        /// Whether to split debug information into a separate file (default: false)
        var splitDebug: Bool
        /// The options for packaging
        var packageOptions: PackageOptions
    }

    struct TestOptions {
        /// Whether to only build tests, don't run them
        var buildOnly: Bool
        /// Lists all tests
        var listTests: Bool
        /// The filter to apply to the tests
        var filter: [String]
        /// The options for packaging
        var packageOptions: PackageOptions
    }
}

struct PackageToJSError: Swift.Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = "Error: " + message
    }
}

/// Plans the build for packaging.
struct PackagingPlanner {
    /// The options for packaging
    let options: PackageToJS.PackageOptions
    /// The package ID of the package that this plugin is running on
    let packageId: String
    /// The directory of the package that contains this plugin
    let selfPackageDir: URL
    /// The path of this file itself, used to capture changes of planner code
    let selfPath: String
    /// The directory for the final output
    let outputDir: URL
    /// The directory for intermediate files
    let intermediatesDir: URL
    /// The filename of the .wasm file
    let wasmFilename = "main.wasm"
    /// The path to the .wasm product artifact
    let wasmProductArtifact: URL

    init(
        options: PackageToJS.PackageOptions,
        packageId: String,
        pluginWorkDirectoryURL: URL,
        selfPackageDir: URL,
        outputDir: URL,
        wasmProductArtifact: URL
    ) {
        self.options = options
        self.packageId = packageId
        self.selfPackageDir = selfPackageDir
        self.outputDir = outputDir
        self.intermediatesDir = pluginWorkDirectoryURL.appending(path: outputDir.lastPathComponent + ".tmp")
        self.selfPath = String(#filePath)
        self.wasmProductArtifact = wasmProductArtifact
    }

    // MARK: - Primitive build operations

    private static func syncFile(from: String, to: String) throws {
        if FileManager.default.fileExists(atPath: to) {
            try FileManager.default.removeItem(atPath: to)
        }
        try FileManager.default.copyItem(atPath: from, toPath: to)
        try FileManager.default.setAttributes(
            [.modificationDate: Date()], ofItemAtPath: to
        )
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

    // MARK: - Build plans

    /// Construct the build plan and return the root task key
    func planBuild(
        make: inout MiniMake,
        splitDebug: Bool
    ) throws -> MiniMake.TaskKey {
        let (allTasks, _) = try planBuildInternal(
            make: &make, splitDebug: splitDebug
        )
        return make.addTask(
            inputTasks: allTasks, output: "all", attributes: [.phony, .silent]
        ) { _ in }
    }

    func deriveBuildConfiguration() -> (configuration: String, triple: String) {
        // e.g. path/to/.build/wasm32-unknown-wasi/debug/Basic.wasm -> ("debug", "wasm32-unknown-wasi")
        let buildConfiguration = wasmProductArtifact.deletingLastPathComponent().lastPathComponent
        let triple = wasmProductArtifact.deletingLastPathComponent().deletingLastPathComponent().lastPathComponent
        return (buildConfiguration, triple)
    }

    private func planBuildInternal(
        make: inout MiniMake,
        splitDebug: Bool
    ) throws -> (allTasks: [MiniMake.TaskKey], outputDirTask: MiniMake.TaskKey) {
        // Prepare output directory
        let outputDirTask = make.addTask(
            inputFiles: [selfPath], output: outputDir.path, attributes: [.silent]
        ) {
            try Self.createDirectory(atPath: $0.output)
        }

        var packageInputs: [MiniMake.TaskKey] = []

        // Guess the build configuration from the parent directory name of .wasm file
        let (buildConfiguration, triple) = deriveBuildConfiguration()
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
            let intermediatesDirTask = make.addTask(
                inputFiles: [selfPath], output: intermediatesDir.path, attributes: [.silent]
            ) {
                try Self.createDirectory(atPath: $0.output)
            }
            // If splitDebug is true, we need to place the DWARF-stripped wasm file (but "name" section remains)
            // in the output directory.
            let stripWasmPath = (splitDebug ? outputDir : intermediatesDir).appending(path: wasmFilename + ".debug").path

            // First, strip DWARF sections as their existence enables DWARF preserving mode in wasm-opt
            let stripWasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact.path], inputTasks: [outputDirTask, intermediatesDirTask],
                output: stripWasmPath
            ) {
                print("Stripping DWARF debug info...")
                try Self.runCommand(wasmOptPath, [wasmProductArtifact.path, "--strip-dwarf", "--debuginfo", "-o", $0.output])
            }
            // Then, run wasm-opt with all optimizations
            wasm = make.addTask(
                inputFiles: [selfPath], inputTasks: [outputDirTask, stripWasm],
                output: outputDir.appending(path: wasmFilename).path
            ) {
                print("Optimizing the wasm file...")
                try Self.runCommand(wasmOptPath, [stripWasmPath, "-Os", "-o", $0.output])
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
                    "name": "\(options.packageName ?? packageId.lowercased())",
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
    ) throws -> (rootTask: MiniMake.TaskKey, binDir: URL) {
        var (allTasks, outputDirTask) = try planBuildInternal(
            make: &make, splitDebug: false
        )

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
        let inputPath = selfPackageDir.appending(path: file)
        let substitutions = [
            "@PACKAGE_TO_JS_MODULE_PATH@": wasmFilename
        ]
        let (buildConfiguration, triple) = deriveBuildConfiguration()
        let conditions = [
            "USE_SHARED_MEMORY": triple == "wasm32-unknown-wasip1-threads",
            "IS_WASI": triple.hasPrefix("wasm32-unknown-wasi"),
        ]
        return make.addTask(
            inputFiles: [selfPath, inputPath.path], inputTasks: [outputDirTask] + inputs,
            output: outputDir.appending(path: output).path
        ) {
            var content = try String(contentsOf: inputPath, encoding: .utf8)
            let options = PreprocessOptions(conditions: conditions, substitutions: substitutions)
            content = try preprocess(source: content, file: file, options: options)
            try content.write(toFile: $0.output, atomically: true, encoding: .utf8)
        }
    }
}

// MARK: - Utilities

func which(_ executable: String) throws -> URL {
    let pathSeparator: Character
    #if os(Windows)
        pathSeparator = ";"
    #else
        pathSeparator = ":"
    #endif
    let paths = ProcessInfo.processInfo.environment["PATH"]!.split(separator: pathSeparator)
    for path in paths {
        let url = URL(fileURLWithPath: String(path)).appendingPathComponent(executable)
        if FileManager.default.isExecutableFile(atPath: url.path) {
            return url
        }
    }
    throw PackageToJSError("Executable \(executable) not found in PATH")
}

func logCommandExecution(_ command: String, _ arguments: [String]) {
    var fullArguments = [command]
    fullArguments.append(contentsOf: arguments)
    print("$ \(fullArguments.map { "\"\($0)\"" }.joined(separator: " "))")
}