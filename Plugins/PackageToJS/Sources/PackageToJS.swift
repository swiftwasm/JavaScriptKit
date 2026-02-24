import Foundation

#if os(Windows)
import WinSDK
#endif
struct PackageToJS {
    struct PackageOptions {
        enum Platform: String, CaseIterable {
            case browser
            case node
        }

        /// Path to the output directory
        var outputPath: String?
        /// The build configuration to use (default: debug)
        var configuration: String?
        /// Name of the package (default: lowercased Package.swift name)
        var packageName: String?
        /// Target platform for the generated JavaScript (default: browser)
        var defaultPlatform: Platform = .browser
        /// Whether to explain the build plan (default: false)
        var explain: Bool = false
        /// Whether to print verbose output
        var verbose: Bool = false
        /// Whether to use CDN for dependency packages (default: false)
        var useCDN: Bool = false
        /// Whether to enable code coverage collection (default: false)
        var enableCodeCoverage: Bool = false
    }

    enum DebugInfoFormat: String, CaseIterable {
        /// No debug info
        case none
        /// The all DWARF sections and "name" section
        case dwarf
        /// Only "name" section
        case name
    }

    struct BuildOptions {
        /// Product to build (default: executable target if there's only one)
        var product: String?
        /// Whether to apply wasm-opt optimizations in release mode (default: true)
        var noOptimize: Bool
        /// The format of debug info to keep in the final wasm file (default: none)
        var debugInfoFormat: DebugInfoFormat
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
        /// The script defining Playwright exposed functions
        var playwrightExpose: String?
        /// The extra arguments to pass to node
        var extraNodeArguments: [String]
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

    static func runTest(testRunner: URL, currentDirectoryURL: URL, outputDir: URL, testOptions: TestOptions) throws {
        var testJsArguments: [String] = []
        var testLibraryArguments: [String] = []
        if testOptions.listTests {
            testLibraryArguments.append("--list-tests")
        }
        if let prelude = testOptions.prelude {
            let preludeURL = URL(
                fileURLWithPath: prelude,
                relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            )
            testJsArguments.append("--prelude")
            testJsArguments.append(preludeURL.path)
        }
        if let playwrightExpose = testOptions.playwrightExpose {
            let playwrightExposeURL = URL(
                fileURLWithPath: playwrightExpose,
                relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            )
            testJsArguments.append("--playwright-expose")
            testJsArguments.append(playwrightExposeURL.path)
        }
        if let environment = testOptions.environment {
            testJsArguments.append("--environment")
            testJsArguments.append(environment)
        }
        if testOptions.inspect {
            testJsArguments.append("--inspect")
        }

        let xctestCoverageFile = outputDir.appending(path: "XCTest.profraw")
        do {
            var extraArguments = testJsArguments
            if testOptions.packageOptions.enableCodeCoverage {
                extraArguments.append("--coverage-file")
                extraArguments.append(xctestCoverageFile.path)
            }
            extraArguments.append("--")
            extraArguments.append(contentsOf: testLibraryArguments)
            extraArguments.append(contentsOf: testOptions.filter)

            try PackageToJS.runSingleTestingLibrary(
                testRunner: testRunner,
                currentDirectoryURL: currentDirectoryURL,
                extraArguments: extraArguments,
                testParser: testOptions.packageOptions.verbose
                    ? nil : FancyTestsParser(write: { print($0, terminator: "") }),
                testOptions: testOptions
            )
        }
        let swiftTestingCoverageFile = outputDir.appending(path: "SwiftTesting.profraw")
        do {
            var extraArguments = testJsArguments
            if testOptions.packageOptions.enableCodeCoverage {
                extraArguments.append("--coverage-file")
                extraArguments.append(swiftTestingCoverageFile.path)
            }
            extraArguments.append("--")
            extraArguments.append("--testing-library")
            extraArguments.append("swift-testing")
            extraArguments.append(contentsOf: testLibraryArguments)
            for filter in testOptions.filter {
                extraArguments.append("--filter")
                extraArguments.append(filter)
            }

            try PackageToJS.runSingleTestingLibrary(
                testRunner: testRunner,
                currentDirectoryURL: currentDirectoryURL,
                extraArguments: extraArguments,
                testOptions: testOptions
            )
        }

        if testOptions.packageOptions.enableCodeCoverage {
            let profrawFiles = [xctestCoverageFile.path, swiftTestingCoverageFile.path].filter {
                FileManager.default.fileExists(atPath: $0)
            }
            do {
                try PackageToJS.postProcessCoverageFiles(outputDir: outputDir, profrawFiles: profrawFiles)
            } catch {
                print("Warning: Failed to merge coverage files: \(error)")
            }
        }
    }

    static func runSingleTestingLibrary(
        testRunner: URL,
        currentDirectoryURL: URL,
        extraArguments: [String],
        testParser: FancyTestsParser? = nil,
        testOptions: TestOptions
    ) throws {
        let node = try which("node")
        var arguments = ["--experimental-wasi-unstable-preview1"]
        arguments.append(contentsOf: testOptions.extraNodeArguments)
        arguments.append(testRunner.path)
        arguments.append(contentsOf: extraArguments)

        print("Running test...")
        logCommandExecution(node.path, arguments)

        let task = Process()
        task.executableURL = node
        task.arguments = arguments

        var finalize: () -> Void = {}
        if let testParser = testParser {
            let stdoutBuffer = LineBuffer { line in
                testParser.onLine(line)
            }
            let stdoutPipe = Pipe()
            stdoutPipe.fileHandleForReading.readabilityHandler = { handle in
                stdoutBuffer.append(handle.availableData)
            }
            task.standardOutput = stdoutPipe
            finalize = {
                if let data = try? stdoutPipe.fileHandleForReading.readToEnd() {
                    stdoutBuffer.append(data)
                }
                stdoutBuffer.flush()
                testParser.finalize()
            }
        }

        task.currentDirectoryURL = currentDirectoryURL
        try task.forwardTerminationSignals {
            try task.run()
            task.waitUntilExit()
        }
        finalize()
        // swift-testing returns EX_UNAVAILABLE (which is 69 in wasi-libc) for "no tests found"
        guard [0, 69].contains(task.terminationStatus) else {
            throw PackageToJSError("Test failed with status \(task.terminationStatus)")
        }
    }

    static func postProcessCoverageFiles(outputDir: URL, profrawFiles: [String]) throws {
        let mergedCoverageFile = outputDir.appending(path: "default.profdata")
        do {
            // Merge the coverage files by llvm-profdata
            let arguments = ["merge", "-sparse", "-output", mergedCoverageFile.path] + profrawFiles
            let llvmProfdata = try which("llvm-profdata")
            logCommandExecution(llvmProfdata.path, arguments)
            try runCommand(llvmProfdata, arguments)
            print("Saved profile data to \(mergedCoverageFile.path)")
        }
    }

    class LineBuffer: @unchecked Sendable {
        let lock = NSLock()
        var buffer = ""
        let handler: (String) -> Void

        init(handler: @escaping (String) -> Void) {
            self.handler = handler
        }

        func append(_ data: Data) {
            let string = String(data: data, encoding: .utf8) ?? ""
            append(string)
        }

        func append(_ data: String) {
            lock.lock()
            defer { lock.unlock() }
            buffer.append(data)
            let lines = buffer.split(separator: "\n", omittingEmptySubsequences: false)
            for line in lines.dropLast() {
                handler(String(line))
            }
            buffer = String(lines.last ?? "")
        }

        func flush() {
            lock.lock()
            defer { lock.unlock() }
            handler(buffer)
            buffer = ""
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
            atPath: atPath,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    func syncFile(from: String, to: String) throws {
        if FileManager.default.fileExists(atPath: to) {
            try FileManager.default.removeItem(atPath: to)
        }
        try FileManager.default.copyItem(atPath: from, toPath: to)
        try FileManager.default.setAttributes(
            [.modificationDate: Date()],
            ofItemAtPath: to
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
    private let which: (String) throws -> URL

    init(printWarning: @escaping (String) -> Void, which: @escaping (String) throws -> URL) {
        self.printWarning = printWarning
        self.which = which
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
            // Remove existing output file if it exists (to match wasm-opt behavior)
            if FileManager.default.fileExists(atPath: output) {
                try FileManager.default.removeItem(atPath: output)
            }
            try FileManager.default.copyItem(atPath: input, toPath: output)
            return
        }
        try runCommand(wasmOpt, arguments + ["-o", output, input])
    }
}

internal func which(_ executable: String) throws -> URL {
    let environment = ProcessInfo.processInfo.environment
    func checkCandidate(_ candidate: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: candidate.path, isDirectory: &isDirectory)
        return fileExists && !isDirectory.boolValue && FileManager.default.isExecutableFile(atPath: candidate.path)
    }
    do {
        // Check overriding environment variable
        let envVariable = "JAVASCRIPTKIT_" + executable.uppercased().replacingOccurrences(of: "-", with: "_") + "_EXEC"
        if let executablePath = environment[envVariable] {
            let url = URL(fileURLWithPath: executablePath)
            if checkCandidate(url) {
                return url
            }
        }
    }
    let pathSeparator: Character
    #if os(Windows)
    pathSeparator = ";"
    #else
    pathSeparator = ":"
    #endif
    let paths = environment["PATH"]?.split(separator: pathSeparator) ?? []
    for path in paths {
        let url = URL(fileURLWithPath: String(path)).appendingPathComponent(executable)
        if checkCandidate(url) {
            return url
        }
    }
    throw PackageToJSError("Executable \(executable) not found in PATH")
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
    /// The BridgeJS API skeletons source files
    let skeletons: [BuildPath]
    /// The directory for the final output
    let outputDir: BuildPath
    /// The directory for intermediate files
    let intermediatesDir: BuildPath
    /// The filename of the .wasm file
    let wasmFilename: String
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
        skeletons: [BuildPath],
        outputDir: BuildPath,
        wasmProductArtifact: BuildPath,
        wasmFilename: String,
        configuration: String,
        triple: String,
        // NOTE: We should use `ProcessInfo.processInfo.arguments[0]` instead of `CommandLine.arguments[0]`
        // because the latter may not always be the full executable path (e.g. when invoked through PATH lookup).
        // https://github.com/swiftlang/swift-foundation/blob/f5143f96d01cdb6d280665de8221b75fc8631d95/Sources/FoundationEssentials/ProcessInfo/ProcessInfo.swift#L47
        selfPath: BuildPath = BuildPath(absolute: ProcessInfo.processInfo.arguments[0]),
        system: any PackagingSystem
    ) {
        self.options = options
        self.packageId = packageId
        self.selfPackageDir = selfPackageDir
        self.skeletons = skeletons
        self.outputDir = outputDir
        self.intermediatesDir = intermediatesDir
        self.wasmFilename = wasmFilename
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
            make: &make,
            noOptimize: buildOptions.noOptimize,
            debugInfoFormat: buildOptions.debugInfoFormat
        )
        return make.addTask(
            inputTasks: allTasks,
            output: BuildPath(phony: "all"),
            attributes: [.phony, .silent]
        )
    }

    private func planBuildInternal(
        make: inout MiniMake,
        noOptimize: Bool,
        debugInfoFormat: PackageToJS.DebugInfoFormat
    ) throws -> (
        allTasks: [MiniMake.TaskKey],
        outputDirTask: MiniMake.TaskKey,
        intermediatesDirTask: MiniMake.TaskKey,
        packageJsonTask: MiniMake.TaskKey
    ) {
        // Prepare output directory
        let outputDirTask = make.addTask(
            inputFiles: [selfPath],
            output: outputDir,
            attributes: [.silent]
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
            inputFiles: [selfPath],
            output: intermediatesDir,
            attributes: [.silent]
        ) {
            try system.createDirectory(atPath: $1.resolve(path: $0.output).path)
        }

        let finalWasmPath = outputDir.appending(path: wasmFilename)

        if shouldOptimize {
            let wasmOptInputFile: BuildPath
            let wasmOptInputTask: MiniMake.TaskKey?
            switch debugInfoFormat {
            case .dwarf:
                // Keep the original wasm file
                wasmOptInputFile = wasmProductArtifact
                wasmOptInputTask = nil
            case .name, .none:
                // Optimize the wasm in release mode
                wasmOptInputFile = intermediatesDir.appending(path: wasmFilename + ".no-dwarf")
                // First, strip DWARF sections as their existence enables DWARF preserving mode in wasm-opt
                wasmOptInputTask = make.addTask(
                    inputFiles: [selfPath, wasmProductArtifact],
                    inputTasks: [outputDirTask, intermediatesDirTask],
                    output: wasmOptInputFile
                ) {
                    print("Stripping DWARF debug info...")
                    try system.wasmOpt(
                        ["--strip-dwarf", "--debuginfo"],
                        input: $1.resolve(path: wasmProductArtifact).path,
                        output: $1.resolve(path: $0.output).path
                    )
                }
            }
            // Then, run wasm-opt with all optimizations
            wasm = make.addTask(
                inputFiles: [selfPath, wasmOptInputFile],
                inputTasks: [outputDirTask] + (wasmOptInputTask.map { [$0] } ?? []),
                output: finalWasmPath
            ) {
                print("Optimizing the wasm file...")
                try system.wasmOpt(
                    ["-Os"] + (debugInfoFormat != .none ? ["--debuginfo"] : []),
                    input: $1.resolve(path: wasmOptInputFile).path,
                    output: $1.resolve(path: $0.output).path
                )
            }
        } else {
            // Copy the wasm product artifact
            wasm = make.addTask(
                inputFiles: [selfPath, wasmProductArtifact],
                inputTasks: [outputDirTask],
                output: finalWasmPath
            ) {
                try system.syncFile(
                    from: $1.resolve(path: wasmProductArtifact).path,
                    to: $1.resolve(path: $0.output).path
                )
            }
        }
        packageInputs.append(wasm)

        let wasmImportsPath = intermediatesDir.appending(path: "wasm-imports.json")
        let wasmImportsTask = make.addTask(
            inputFiles: [selfPath, finalWasmPath],
            inputTasks: [outputDirTask, intermediatesDirTask, wasm],
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
            inputFiles: [selfPath],
            output: platformsDir,
            attributes: [.silent]
        ) {
            try system.createDirectory(atPath: $1.resolve(path: $0.output).path)
        }

        let packageJsonTask = planCopyTemplateFile(
            make: &make,
            file: "Plugins/PackageToJS/Templates/package.json",
            output: "package.json",
            outputDirTask: outputDirTask,
            inputFiles: [],
            inputTasks: []
        )
        packageInputs.append(packageJsonTask)

        if skeletons.count > 0 {
            let bridgeJs = outputDir.appending(path: "bridge-js.js")
            let bridgeDts = outputDir.appending(path: "bridge-js.d.ts")
            packageInputs.append(
                make.addTask(inputFiles: skeletons + [selfPath], output: bridgeJs) { _, scope in
                    var link = BridgeJSLink(
                        sharedMemory: Self.isSharedMemoryEnabled(triple: triple)
                    )

                    // Decode skeleton format
                    for skeletonPath in skeletons {
                        let data = try Data(contentsOf: URL(fileURLWithPath: scope.resolve(path: skeletonPath).path))
                        try link.addSkeletonFile(data: data)
                    }

                    let (outputJs, outputDts) = try link.link()
                    try system.writeFile(atPath: scope.resolve(path: bridgeJs).path, content: Data(outputJs.utf8))
                    try system.writeFile(atPath: scope.resolve(path: bridgeDts).path, content: Data(outputDts.utf8))
                }
            )
        }

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
            ("Sources/JavaScriptKit/Runtime/index.d.ts", "runtime.d.ts"),
        ] {
            packageInputs.append(
                planCopyTemplateFile(
                    make: &make,
                    file: file,
                    output: output,
                    outputDirTask: outputDirTask,
                    inputFiles: [wasmImportsPath],
                    inputTasks: [platformsDirTask, wasmImportsTask],
                    wasmImportsPath: wasmImportsPath
                )
            )
        }
        return (packageInputs, outputDirTask, intermediatesDirTask, packageJsonTask)
    }

    /// Construct the test build plan and return the root task key
    func planTestBuild(
        make: inout MiniMake
    ) throws -> (rootTask: MiniMake.TaskKey, binDir: BuildPath) {
        var (allTasks, outputDirTask, intermediatesDirTask, packageJsonTask) = try planBuildInternal(
            make: &make,
            noOptimize: false,
            debugInfoFormat: .dwarf
        )

        // Install npm dependencies used in the test harness
        allTasks.append(
            make.addTask(
                inputFiles: [
                    selfPath,
                    outputDir.appending(path: "package.json"),
                ],
                inputTasks: [intermediatesDirTask, packageJsonTask],
                output: intermediatesDir.appending(path: "npm-install.stamp")
            ) {
                try system.npmInstall(packageDir: $1.resolve(path: outputDir).path)
                try system.writeFile(atPath: $1.resolve(path: $0.output).path, content: Data())
            }
        )

        let binDir = outputDir.appending(path: "bin")
        let binDirTask = make.addTask(
            inputFiles: [selfPath],
            inputTasks: [outputDirTask],
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
            allTasks.append(
                planCopyTemplateFile(
                    make: &make,
                    file: file,
                    output: output,
                    outputDirTask: outputDirTask,
                    inputFiles: [],
                    inputTasks: [binDirTask]
                )
            )
        }
        let rootTask = make.addTask(
            inputTasks: allTasks,
            output: BuildPath(phony: "all"),
            attributes: [.phony, .silent]
        )
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
        let conditions: [String: Bool] = [
            "USE_SHARED_MEMORY": Self.isSharedMemoryEnabled(triple: triple),
            "IS_WASI": triple.hasPrefix("wasm32-unknown-wasi"),
            "USE_WASI_CDN": options.useCDN,
            "HAS_BRIDGE": skeletons.count > 0,
            "HAS_IMPORTS": skeletons.count > 0,
            "TARGET_DEFAULT_PLATFORM_NODE": options.defaultPlatform == .node,
            "TARGET_DEFAULT_PLATFORM_BROWSER": options.defaultPlatform == .browser,
        ]
        let constantSubstitutions: [String: String] = [
            "PACKAGE_TO_JS_MODULE_PATH": wasmFilename,
            "PACKAGE_TO_JS_PACKAGE_NAME": options.packageName ?? packageId.lowercased(),
        ]
        let salt = Salt(conditions: conditions, substitutions: constantSubstitutions)

        return make.addTask(
            inputFiles: [selfPath, inputPath] + inputFiles,
            inputTasks: [outputDirTask] + inputTasks,
            output: outputDir.appending(path: output),
            salt: salt
        ) {
            var substitutions = constantSubstitutions

            if let wasmImportsPath = wasmImportsPath {
                let wasmImportsPath = $1.resolve(path: wasmImportsPath)
                let importEntries = try JSONDecoder().decode(
                    [ImportEntry].self,
                    from: Data(contentsOf: wasmImportsPath)
                )
                let memoryImport = importEntries.first {
                    $0.module == "env" && $0.name == "memory"
                }
                if case .memory(let type) = memoryImport?.kind {
                    substitutions["PACKAGE_TO_JS_MEMORY_INITIAL"] = type.minimum.description
                    substitutions["PACKAGE_TO_JS_MEMORY_MAXIMUM"] = (type.maximum ?? type.minimum).description
                    substitutions["PACKAGE_TO_JS_MEMORY_SHARED"] = type.shared.description
                }
            }

            let inputPath = $1.resolve(path: inputPath)
            var content = try String(contentsOf: inputPath, encoding: .utf8)
            let options = PreprocessOptions(conditions: conditions, substitutions: substitutions)
            content = try preprocess(source: content, file: inputPath.path, options: options)
            try system.writeFile(atPath: $1.resolve(path: $0.output).path, content: Data(content.utf8))
        }
    }

    private static func isSharedMemoryEnabled(triple: String) -> Bool {
        return triple == "wasm32-unknown-wasip1-threads"
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
            #if os(Windows)
            _ = TerminateProcess(processHandle, 0)
            #else
            kill(processIdentifier, signalNo)
            #endif
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
