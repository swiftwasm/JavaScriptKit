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
        var useCDN: Bool = false
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

    static func deriveBuildConfiguration(wasmProductArtifact: URL) -> (configuration: String, triple: String) {
        // e.g. path/to/.build/wasm32-unknown-wasi/debug/Basic.wasm -> ("debug", "wasm32-unknown-wasi")

        // First, resolve symlink to get the actual path as SwiftPM 6.0 and earlier returns unresolved
        // symlink path for product artifact.
        let wasmProductArtifact = wasmProductArtifact.resolvingSymlinksInPath()
        let buildConfiguration = wasmProductArtifact.deletingLastPathComponent().lastPathComponent
        let triple = wasmProductArtifact.deletingLastPathComponent().deletingLastPathComponent().lastPathComponent
        return (buildConfiguration, triple)
    }

    static func runTest(testRunner: URL, currentDirectoryURL: URL, extraArguments: [String]) throws {
        let node = try which("node")
        let arguments = ["--experimental-wasi-unstable-preview1", testRunner.path] + extraArguments
        print("Running test...")
        logCommandExecution(node.path, arguments)

        let task = Process()
        task.executableURL = node
        task.arguments = arguments
        task.currentDirectoryURL = currentDirectoryURL
        try task.forwardTerminationSignals {
            try task.run()
            task.waitUntilExit()
        }
        // swift-testing returns EX_UNAVAILABLE (which is 69 in wasi-libc) for "no tests found"
        guard task.terminationStatus == 0 || task.terminationStatus == 69 else {
            throw PackageToJSError("Test failed with status \(task.terminationStatus)")
        }
    }
}

struct PackageToJSError: Swift.Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = "Error: " + message
    }
}

protocol PackagingSystem {
    func createDirectory(atPath: String) throws
    func syncFile(from: String, to: String) throws
    func writeFile(atPath: String, content: Data) throws

    func wasmOpt(_ arguments: [String], input: String, output: String) throws
    func npmInstall(packageDir: String) throws
}

extension PackagingSystem {
    func createDirectory(atPath: String) throws {
        guard !FileManager.default.fileExists(atPath: atPath) else { return }
        try FileManager.default.createDirectory(
            atPath: atPath, withIntermediateDirectories: true, attributes: nil
        )
    }

    func syncFile(from: String, to: String) throws {
        if FileManager.default.fileExists(atPath: to) {
            try FileManager.default.removeItem(atPath: to)
        }
        try FileManager.default.copyItem(atPath: from, toPath: to)
        try FileManager.default.setAttributes(
            [.modificationDate: Date()], ofItemAtPath: to
        )
    }

    func writeFile(atPath: String, content: Data) throws {
        do {
            try content.write(to: URL(fileURLWithPath: atPath))
        } catch {
            throw PackageToJSError("Failed to write file \(atPath): \(error)")
        }
    }
}

final class DefaultPackagingSystem: PackagingSystem {

    private let printWarning: (String) -> Void

    init(printWarning: @escaping (String) -> Void) {
        self.printWarning = printWarning
    }

    func npmInstall(packageDir: String) throws {
        try runCommand(try which("npm"), ["-C", packageDir, "install"])
    }

    lazy var warnMissingWasmOpt: () = {
        self.printWarning("Warning: wasm-opt is not installed, optimizations will not be applied")
    }()

    func wasmOpt(_ arguments: [String], input: String, output: String) throws {
        guard let wasmOpt = try? which("wasm-opt") else {
            _ = warnMissingWasmOpt
            try FileManager.default.copyItem(atPath: input, toPath: output)
            return
        }
        try runCommand(wasmOpt, arguments + ["-o", output, input])
    }

    private func runCommand(_ command: URL, _ arguments: [String]) throws {
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
}

internal func which(_ executable: String) throws -> URL {
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

/// Plans the build for packaging.
struct PackagingPlanner {
    /// The options for packaging
    let options: PackageToJS.PackageOptions
    /// The package ID of the package that this plugin is running on
    let packageId: String
    /// The directory of the package that contains this plugin
    let selfPackageDir: BuildPath
    /// The path of this file itself, used to capture changes of planner code
    let selfPath: BuildPath
    /// The directory for the final output
    let outputDir: BuildPath
    /// The directory for intermediate files
    let intermediatesDir: BuildPath
    /// The filename of the .wasm file
    let wasmFilename = "main.wasm"
    /// The path to the .wasm product artifact
    let wasmProductArtifact: BuildPath
    /// The build configuration
    let configuration: String
    /// The target triple
    let triple: String
    /// The system interface to use
    let system: any PackagingSystem

    init(
        options: PackageToJS.PackageOptions,
        packageId: String,
        intermediatesDir: BuildPath,
        selfPackageDir: BuildPath,
        outputDir: BuildPath,
        wasmProductArtifact: BuildPath,
        configuration: String,
        triple: String,
        selfPath: BuildPath = BuildPath(absolute: #filePath),
        system: any PackagingSystem
    ) {
        self.options = options
        self.packageId = packageId
        self.selfPackageDir = selfPackageDir
        self.outputDir = outputDir
        self.intermediatesDir = intermediatesDir
        self.selfPath = selfPath
        self.wasmProductArtifact = wasmProductArtifact
        self.configuration = configuration
        self.triple = triple
        self.system = system
    }

    // MARK: - Build plans

    /// Construct the build plan and return the root task key
    func planBuild(
        make: inout MiniMake,
        buildOptions: PackageToJS.BuildOptions
    ) throws -> MiniMake.TaskKey {
        let (allTasks, _, _, _) = try planBuildInternal(
            make: &make, splitDebug: buildOptions.splitDebug, noOptimize: buildOptions.noOptimize
        )
        return make.addTask(
            inputTasks: allTasks, output: BuildPath(phony: "all"), attributes: [.phony, .silent]
        ) { _, _ in }
    }

    private func planBuildInternal(
        make: inout MiniMake,
        splitDebug: Bool, noOptimize: Bool
    ) throws -> (
        allTasks: [MiniMake.TaskKey],
        outputDirTask: MiniMake.TaskKey,
        intermediatesDirTask: MiniMake.TaskKey,
        packageJsonTask: MiniMake.TaskKey
    ) {
        // Prepare output directory
        let outputDirTask = make.addTask(
            inputFiles: [selfPath], output: outputDir, attributes: [.silent]
        ) {
            try system.createDirectory(atPath: $1.resolve(path: $0.output).path)
        }

        var packageInputs: [MiniMake.TaskKey] = []

        // Guess the build configuration from the parent directory name of .wasm file
        let wasm: MiniMake.TaskKey

        let shouldOptimize: Bool
        if self.configuration == "debug" {
            shouldOptimize = false
        } else {
            shouldOptimize = !noOptimize
        }

        let intermediatesDirTask = make.addTask(
            inputFiles: [selfPath], output: intermediatesDir, attributes: [.silent]
        ) {
            try system.createDirectory(atPath: $1.resolve(path: $0.output).path)
        }

        let finalWasmPath = outputDir.appending(path: wasmFilename)

        if shouldOptimize {
            // Optimize the wasm in release mode
            // If splitDebug is true, we need to place the DWARF-stripped wasm file (but "name" section remains)
            // in the output directory.
            let stripWasmPath = (splitDebug ? outputDir : intermediatesDir).appending(path: wasmFilename + ".debug")

            // First, strip DWARF sections as their existence enables DWARF preserving mode in wasm-opt
            let stripWasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact], inputTasks: [outputDirTask, intermediatesDirTask],
                output: stripWasmPath
            ) {
                print("Stripping DWARF debug info...")
                try system.wasmOpt(["--strip-dwarf", "--debuginfo"], input: $1.resolve(path: wasmProductArtifact).path, output: $1.resolve(path: $0.output).path)
            }
            // Then, run wasm-opt with all optimizations
            wasm = make.addTask(
                inputFiles: [selfPath, stripWasmPath], inputTasks: [outputDirTask, stripWasm],
                output: finalWasmPath
            ) {
                print("Optimizing the wasm file...")
                try system.wasmOpt(["-Os"], input: $1.resolve(path: stripWasmPath).path, output: $1.resolve(path: $0.output).path)
            }
        } else {
            // Copy the wasm product artifact
            wasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact], inputTasks: [outputDirTask],
                output: finalWasmPath
            ) {
                try system.syncFile(from: $1.resolve(path: wasmProductArtifact).path, to: $1.resolve(path: $0.output).path)
            }
        }
        packageInputs.append(wasm)

        let wasmImportsPath = intermediatesDir.appending(path: "wasm-imports.json")
        let wasmImportsTask = make.addTask(
            inputFiles: [selfPath, finalWasmPath], inputTasks: [outputDirTask, intermediatesDirTask, wasm],
            output: wasmImportsPath
        ) {
            let metadata = try parseImports(
                moduleBytes: try Data(contentsOf: URL(fileURLWithPath: $1.resolve(path: finalWasmPath).path))
            )
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try jsonEncoder.encode(metadata)
            try system.writeFile(atPath: $1.resolve(path: $0.output).path, content: jsonData)
        }

        packageInputs.append(wasmImportsTask)

        let platformsDir = outputDir.appending(path: "platforms")
        let platformsDirTask = make.addTask(
            inputFiles: [selfPath], output: platformsDir, attributes: [.silent]
        ) {
            try system.createDirectory(atPath: $1.resolve(path: $0.output).path)
        }

        let packageJsonTask = planCopyTemplateFile(
            make: &make, file: "Plugins/PackageToJS/Templates/package.json", output: "package.json", outputDirTask: outputDirTask,
            inputFiles: [], inputTasks: []
        )
        packageInputs.append(packageJsonTask)

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
                inputFiles: [wasmImportsPath], inputTasks: [platformsDirTask, wasmImportsTask],
                wasmImportsPath: wasmImportsPath
            ))
        }
        return (packageInputs, outputDirTask, intermediatesDirTask, packageJsonTask)
    }

    /// Construct the test build plan and return the root task key
    func planTestBuild(
        make: inout MiniMake
    ) throws -> (rootTask: MiniMake.TaskKey, binDir: BuildPath) {
        var (allTasks, outputDirTask, intermediatesDirTask, packageJsonTask) = try planBuildInternal(
            make: &make, splitDebug: false, noOptimize: false
        )

        // Install npm dependencies used in the test harness
        allTasks.append(make.addTask(
            inputFiles: [
                selfPath,
                outputDir.appending(path: "package.json"),
            ], inputTasks: [intermediatesDirTask, packageJsonTask],
            output: intermediatesDir.appending(path: "npm-install.stamp")
        ) {
            try system.npmInstall(packageDir: $1.resolve(path: outputDir).path)
            try system.writeFile(atPath: $1.resolve(path: $0.output).path, content: Data())
        })

        let binDir = outputDir.appending(path: "bin")
        let binDirTask = make.addTask(
            inputFiles: [selfPath], inputTasks: [outputDirTask],
            output: binDir
        ) {
            try system.createDirectory(atPath: $1.resolve(path: $0.output).path)
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
            inputTasks: allTasks, output: BuildPath(phony: "all"), attributes: [.phony, .silent]
        ) { _, _ in }
        return (rootTask, binDir)
    }

    private func planCopyTemplateFile(
        make: inout MiniMake,
        file: String,
        output: String,
        outputDirTask: MiniMake.TaskKey,
        inputFiles: [BuildPath],
        inputTasks: [MiniMake.TaskKey],
        wasmImportsPath: BuildPath? = nil
    ) -> MiniMake.TaskKey {

        struct Salt: Encodable {
            let conditions: [String: Bool]
            let substitutions: [String: String]
        }

        let inputPath = selfPackageDir.appending(path: file)
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
            inputFiles: [selfPath, inputPath] + inputFiles, inputTasks: [outputDirTask] + inputTasks,
            output: outputDir.appending(path: output), salt: salt
        ) {
            var substitutions = constantSubstitutions

            if let wasmImportsPath = wasmImportsPath {
                let wasmImportsPath = $1.resolve(path: wasmImportsPath)
                let importEntries = try JSONDecoder().decode([ImportEntry].self, from: Data(contentsOf: wasmImportsPath))
                let memoryImport = importEntries.first { $0.module == "env" && $0.name == "memory" }
                if case .memory(let type) = memoryImport?.kind {
                    substitutions["PACKAGE_TO_JS_MEMORY_INITIAL"] = "\(type.minimum)"
                    substitutions["PACKAGE_TO_JS_MEMORY_MAXIMUM"] = "\(type.maximum ?? type.minimum)"
                    substitutions["PACKAGE_TO_JS_MEMORY_SHARED"] = "\(type.shared)"
                }
            }

            let inputPath = $1.resolve(path: inputPath)
            var content = try String(contentsOf: inputPath, encoding: .utf8)
            let options = PreprocessOptions(conditions: conditions, substitutions: substitutions)
            content = try preprocess(source: content, file: inputPath.path, options: options)
            try system.writeFile(atPath: $1.resolve(path: $0.output).path, content: Data(content.utf8))
        }
    }
}

// MARK: - Utilities

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
