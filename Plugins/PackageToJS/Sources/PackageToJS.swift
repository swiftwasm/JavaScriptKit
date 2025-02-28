import Foundation

struct PackageToJS {
    struct PackageOptions {
        /// Path to the output directory
        var outputPath: String?
        /// Name of the package (default: lowercased Package.swift name)
        var packageName: String?
        /// Whether to explain the build plan
        var explain: Bool = false
        /// Whether to use CDN for dependency packages
        var useCDN: Bool
    }

    struct BuildOptions {
        /// Product to build (default: executable target if there's only one)
        var product: String?
        /// Whether to split debug information into a separate file (default: false)
        var splitDebug: Bool
        /// Whether to apply wasm-opt optimizations in release mode (default: true)
        var noOptimize: Bool
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
        /// The prelude script to use for the tests
        var prelude: String?
        /// The environment to use for the tests
        var environment: String?
        /// Whether to run tests in the browser with inspector enabled
        var inspect: Bool
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
        buildOptions: PackageToJS.BuildOptions
    ) throws -> MiniMake.TaskKey {
        let (allTasks, _, _) = try planBuildInternal(
            make: &make, splitDebug: buildOptions.splitDebug, noOptimize: buildOptions.noOptimize
        )
        return make.addTask(
            inputTasks: allTasks, output: "all", attributes: [.phony, .silent]
        ) { _ in }
    }

    func deriveBuildConfiguration() -> (configuration: String, triple: String) {
        // e.g. path/to/.build/wasm32-unknown-wasi/debug/Basic.wasm -> ("debug", "wasm32-unknown-wasi")

        // First, resolve symlink to get the actual path as SwiftPM 6.0 and earlier returns unresolved
        // symlink path for product artifact.
        let wasmProductArtifact = self.wasmProductArtifact.resolvingSymlinksInPath()
        let buildConfiguration = wasmProductArtifact.deletingLastPathComponent().lastPathComponent
        let triple = wasmProductArtifact.deletingLastPathComponent().deletingLastPathComponent().lastPathComponent
        return (buildConfiguration, triple)
    }

    private func planBuildInternal(
        make: inout MiniMake,
        splitDebug: Bool, noOptimize: Bool
    ) throws -> (
        allTasks: [MiniMake.TaskKey],
        outputDirTask: MiniMake.TaskKey,
        packageJsonTask: MiniMake.TaskKey
    ) {
        // Prepare output directory
        let outputDirTask = make.addTask(
            inputFiles: [selfPath], output: outputDir.path, attributes: [.silent]
        ) {
            try Self.createDirectory(atPath: $0.output)
        }

        var packageInputs: [MiniMake.TaskKey] = []

        // Guess the build configuration from the parent directory name of .wasm file
        let (buildConfiguration, _) = deriveBuildConfiguration()
        let wasm: MiniMake.TaskKey

        let shouldOptimize: Bool
        let wasmOptPath = try? which("wasm-opt")
        if buildConfiguration == "debug" {
            shouldOptimize = false
        } else {
            if wasmOptPath != nil {
                shouldOptimize = !noOptimize
            } else {
                print("Warning: wasm-opt not found in PATH, skipping optimizations")
                shouldOptimize = false
            }
        }

        let intermediatesDirTask = make.addTask(
            inputFiles: [selfPath], output: intermediatesDir.path, attributes: [.silent]
        ) {
            try Self.createDirectory(atPath: $0.output)
        }

        let finalWasmPath = outputDir.appending(path: wasmFilename).path

        if let wasmOptPath = wasmOptPath, shouldOptimize {
            // Optimize the wasm in release mode
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
                output: finalWasmPath
            ) {
                print("Optimizing the wasm file...")
                try Self.runCommand(wasmOptPath, [stripWasmPath, "-Os", "-o", $0.output])
            }
        } else {
            // Copy the wasm product artifact
            wasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact.path], inputTasks: [outputDirTask],
                output: finalWasmPath
            ) {
                try Self.syncFile(from: wasmProductArtifact.path, to: $0.output)
            }
        }
        packageInputs.append(wasm)

        let wasmImportsPath = intermediatesDir.appending(path: "wasm-imports.json")
        let wasmImportsTask = make.addTask(
            inputFiles: [selfPath, finalWasmPath], inputTasks: [outputDirTask, intermediatesDirTask, wasm],
            output: wasmImportsPath.path
        ) {
            let metadata = try parseImports(moduleBytes: Array(try Data(contentsOf: URL(fileURLWithPath: finalWasmPath))))
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try jsonEncoder.encode(metadata)
            try jsonData.write(to: URL(fileURLWithPath: $0.output))
        }

        packageInputs.append(wasmImportsTask)

        let platformsDir = outputDir.appending(path: "platforms")
        let platformsDirTask = make.addTask(
            inputFiles: [selfPath], output: platformsDir.path, attributes: [.silent]
        ) {
            try Self.createDirectory(atPath: $0.output)
        }

        let packageJsonTask = planCopyTemplateFile(
            make: &make, file: "Plugins/PackageToJS/Templates/package.json", output: "package.json", outputDirTask: outputDirTask,
            inputFiles: [], inputTasks: []
        )

        // Copy the template files
        for (file, output) in [
            ("Plugins/PackageToJS/Templates/index.js", "index.js"),
            ("Plugins/PackageToJS/Templates/index.d.ts", "index.d.ts"),
            ("Plugins/PackageToJS/Templates/instantiate.js", "instantiate.js"),
            ("Plugins/PackageToJS/Templates/instantiate.d.ts", "instantiate.d.ts"),
            ("Plugins/PackageToJS/Templates/platforms/browser.js", "platforms/browser.js"),
            ("Plugins/PackageToJS/Templates/platforms/browser.d.ts", "platforms/browser.d.ts"),
            ("Plugins/PackageToJS/Templates/platforms/browser.worker.js", "platforms/browser.worker.js"),
            ("Plugins/PackageToJS/Templates/platforms/node.js", "platforms/node.js"),
            ("Plugins/PackageToJS/Templates/platforms/node.d.ts", "platforms/node.d.ts"),
            ("Sources/JavaScriptKit/Runtime/index.mjs", "runtime.js"),
        ] {
            packageInputs.append(planCopyTemplateFile(
                make: &make, file: file, output: output, outputDirTask: outputDirTask,
                inputFiles: [wasmImportsPath.path], inputTasks: [platformsDirTask, wasmImportsTask],
                wasmImportsPath: wasmImportsPath.path
            ))
        }
        return (packageInputs, outputDirTask, packageJsonTask)
    }

    /// Construct the test build plan and return the root task key
    func planTestBuild(
        make: inout MiniMake
    ) throws -> (rootTask: MiniMake.TaskKey, binDir: URL) {
        var (allTasks, outputDirTask, packageJsonTask) = try planBuildInternal(
            make: &make, splitDebug: false, noOptimize: false
        )

        // Install npm dependencies used in the test harness
        let npm = try which("npm")
        allTasks.append(make.addTask(
            inputFiles: [
                selfPath,
                outputDir.appending(path: "package.json").path,
            ], inputTasks: [outputDirTask, packageJsonTask],
            output: intermediatesDir.appending(path: "npm-install.stamp").path
        ) {
            try Self.runCommand(npm, ["-C", outputDir.path, "install"])
            _ = FileManager.default.createFile(atPath: $0.output, contents: Data(), attributes: nil)
        })

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
            ("Plugins/PackageToJS/Templates/test.browser.html", "test.browser.html"),
            ("Plugins/PackageToJS/Templates/bin/test.js", "bin/test.js"),
        ] {
            allTasks.append(planCopyTemplateFile(
                make: &make, file: file, output: output, outputDirTask: outputDirTask,
                inputFiles: [], inputTasks: [binDirTask]
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
        inputFiles: [String],
        inputTasks: [MiniMake.TaskKey],
        wasmImportsPath: String? = nil
    ) -> MiniMake.TaskKey {

        struct Salt: Encodable {
            let conditions: [String: Bool]
            let substitutions: [String: String]
        }

        let inputPath = selfPackageDir.appending(path: file)
        let (_, triple) = deriveBuildConfiguration()
        let conditions = [
            "USE_SHARED_MEMORY": triple == "wasm32-unknown-wasip1-threads",
            "IS_WASI": triple.hasPrefix("wasm32-unknown-wasi"),
            "USE_WASI_CDN": options.useCDN,
        ]
        let constantSubstitutions = [
            "PACKAGE_TO_JS_MODULE_PATH": wasmFilename,
            "PACKAGE_TO_JS_PACKAGE_NAME": options.packageName ?? packageId.lowercased(),
        ]
        let salt = Salt(conditions: conditions, substitutions: constantSubstitutions)

        return make.addTask(
            inputFiles: [selfPath, inputPath.path] + inputFiles, inputTasks: [outputDirTask] + inputTasks,
            output: outputDir.appending(path: output).path, salt: salt
        ) {
            var substitutions = constantSubstitutions

            if let wasmImportsPath = wasmImportsPath {
                let importEntries = try JSONDecoder().decode([ImportEntry].self, from: Data(contentsOf: URL(fileURLWithPath: wasmImportsPath)))
                let memoryImport = importEntries.first { $0.module == "env" && $0.name == "memory" }
                if case .memory(let type) = memoryImport?.kind {
                    substitutions["PACKAGE_TO_JS_MEMORY_INITIAL"] = "\(type.minimum)"
                    substitutions["PACKAGE_TO_JS_MEMORY_MAXIMUM"] = "\(type.maximum ?? type.minimum)"
                    substitutions["PACKAGE_TO_JS_MEMORY_SHARED"] = "\(type.shared)"
                }
            }

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

extension Foundation.Process {
    // Monitor termination/interrruption signals to forward them to child process
    func setSignalForwarding(_ signalNo: Int32) -> DispatchSourceSignal {
        let signalSource = DispatchSource.makeSignalSource(signal: signalNo)
        signalSource.setEventHandler { [self] in
            signalSource.cancel()
            kill(processIdentifier, signalNo)
        }
        signalSource.resume()
        return signalSource
    }

    func forwardTerminationSignals(_ body: () throws -> Void) rethrows {
        let sources = [
            setSignalForwarding(SIGINT),
            setSignalForwarding(SIGTERM),
        ]
        defer {
            for source in sources {
                source.cancel()
            }
        }
        try body()
    }
}
