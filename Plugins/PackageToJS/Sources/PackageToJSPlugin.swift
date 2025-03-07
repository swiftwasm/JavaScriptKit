#if canImport(PackagePlugin)
import struct Foundation.URL
import struct Foundation.Data
import class Foundation.Process
import class Foundation.ProcessInfo
import class Foundation.FileManager
import func Foundation.fputs
import func Foundation.exit
@preconcurrency import var Foundation.stderr
import PackagePlugin

/// The main entry point for the PackageToJS plugin.
@main
struct PackageToJSPlugin: CommandPlugin {
    static let friendlyBuildDiagnostics:
        [@Sendable (_ build: PackageManager.BuildResult, _ arguments: [String]) -> String?] = [
            (
                // In case user misses the `--swift-sdk` option
                { build, arguments in
                    guard
                        build.logText.contains(
                            "ld.gold: --export-if-defined=__main_argc_argv: unknown option")
                    else { return nil }
                    let didYouMean =
                        [
                            "swift", "package", "--swift-sdk", "wasm32-unknown-wasi", "js",
                        ] + arguments
                    return """
                        Please pass the `--swift-sdk` option to the "swift package" command.

                        Did you mean:
                        \(didYouMean.joined(separator: " "))
                        """
                }),
            (
                // In case selected Swift SDK version is not compatible with the Swift compiler version
                { build, arguments in
                    let regex =
                        #/module compiled with Swift (?<swiftSDKVersion>\d+\.\d+(?:\.\d+)?) cannot be imported by the Swift (?<compilerVersion>\d+\.\d+(?:\.\d+)?) compiler/#
                    guard let match = build.logText.firstMatch(of: regex) else { return nil }
                    let swiftSDKVersion = match.swiftSDKVersion
                    let compilerVersion = match.compilerVersion
                    return """
                        Swift versions mismatch:
                        - Swift SDK version: \(swiftSDKVersion)
                        - Swift compiler version: \(compilerVersion)

                        Please ensure you are using matching versions of the Swift SDK and Swift compiler.

                        1. Use 'swift --version' to check your Swift compiler version
                        2. Use 'swift sdk list' to check available Swift SDKs
                        3. Select a matching SDK version with --swift-sdk option
                        """
                }),
        ]
    private func reportBuildFailure(
        _ build: PackageManager.BuildResult, _ arguments: [String]
    ) {
        for diagnostic in Self.friendlyBuildDiagnostics {
            if let message = diagnostic(build, arguments) {
                printStderr("\n" + message)
            }
        }
    }

    func performCommand(context: PluginContext, arguments: [String]) throws {
        if arguments.first == "test" {
            return try performTestCommand(context: context, arguments: Array(arguments.dropFirst()))
        }

        return try performBuildCommand(context: context, arguments: arguments)
    }

    static let JAVASCRIPTKIT_PACKAGE_ID: Package.ID = "javascriptkit"

    func performBuildCommand(context: PluginContext, arguments: [String]) throws {
        if arguments.contains(where: { ["-h", "--help"].contains($0) }) {
            printStderr(PackageToJS.BuildOptions.help())
            return
        }

        var extractor = ArgumentExtractor(arguments)
        let buildOptions = PackageToJS.BuildOptions.parse(from: &extractor)

        if extractor.remainingArguments.count > 0 {
            printStderr(
                "Unexpected arguments: \(extractor.remainingArguments.joined(separator: " "))")
            printStderr(PackageToJS.BuildOptions.help())
            exit(1)
        }

        // Build products
        let productName = try buildOptions.product ?? deriveDefaultProduct(package: context.package)
        let build = try buildWasm(
            productName: productName, context: context, options: buildOptions.options)
        guard build.succeeded else {
            reportBuildFailure(build, arguments)
            exit(1)
        }
        let productArtifact = try build.findWasmArtifact(for: productName)
        let outputDir =
            if let outputPath = buildOptions.options.outputPath {
                URL(fileURLWithPath: outputPath)
            } else {
                context.pluginWorkDirectoryURL.appending(path: "Package")
            }
        guard
            let selfPackage = findPackageInDependencies(
                package: context.package, id: Self.JAVASCRIPTKIT_PACKAGE_ID)
        else {
            throw PackageToJSError("Failed to find JavaScriptKit in dependencies!?")
        }
        var make = MiniMake(
            explain: buildOptions.options.explain,
            printProgress: self.printProgress
        )
        let planner = PackagingPlanner(
            options: buildOptions.options, context: context, selfPackage: selfPackage,
            outputDir: outputDir)
        let rootTask = try planner.planBuild(
            make: &make, splitDebug: buildOptions.splitDebug, wasmProductArtifact: productArtifact)
        cleanIfBuildGraphChanged(root: rootTask, make: make, context: context)
        print("Packaging...")
        try make.build(output: rootTask)
        print("Packaging finished")
    }

    func performTestCommand(context: PluginContext, arguments: [String]) throws {
        if arguments.contains(where: { ["-h", "--help"].contains($0) }) {
            printStderr(PackageToJS.TestOptions.help())
            return
        }

        var extractor = ArgumentExtractor(arguments)
        let testOptions = PackageToJS.TestOptions.parse(from: &extractor)

        if extractor.remainingArguments.count > 0 {
            printStderr(
                "Unexpected arguments: \(extractor.remainingArguments.joined(separator: " "))")
            printStderr(PackageToJS.TestOptions.help())
            exit(1)
        }

        let productName = "\(context.package.displayName)PackageTests"
        let build = try buildWasm(
            productName: productName, context: context, options: testOptions.options)
        guard build.succeeded else {
            reportBuildFailure(build, arguments)
            exit(1)
        }

        // NOTE: Find the product artifact from the default build directory
        //       because PackageManager.BuildResult doesn't include the
        //       product artifact for tests.
        //       This doesn't work when `--scratch-path` is used but
        //       we don't have a way to guess the correct path. (we can find
        //       the path by building a dummy executable product but it's
        //       not worth the overhead)
        var productArtifact: URL?
        for fileExtension in ["wasm", "xctest"] {
            let path = ".build/debug/\(productName).\(fileExtension)"
            if FileManager.default.fileExists(atPath: path) {
                productArtifact = URL(fileURLWithPath: path)
                break
            }
        }
        guard let productArtifact = productArtifact else {
            throw PackageToJSError(
                "Failed to find '\(productName).wasm' or '\(productName).xctest'")
        }
        let outputDir =
            if let outputPath = testOptions.options.outputPath {
                URL(fileURLWithPath: outputPath)
            } else {
                context.pluginWorkDirectoryURL.appending(path: "PackageTests")
            }
        guard
            let selfPackage = findPackageInDependencies(
                package: context.package, id: Self.JAVASCRIPTKIT_PACKAGE_ID)
        else {
            throw PackageToJSError("Failed to find JavaScriptKit in dependencies!?")
        }
        var make = MiniMake(
            explain: testOptions.options.explain,
            printProgress: self.printProgress
        )
        let planner = PackagingPlanner(
            options: testOptions.options, context: context, selfPackage: selfPackage,
            outputDir: outputDir)
        let (rootTask, binDir) = try planner.planTestBuild(
            make: &make, wasmProductArtifact: productArtifact)
        cleanIfBuildGraphChanged(root: rootTask, make: make, context: context)
        print("Packaging tests...")
        try make.build(output: rootTask)
        print("Packaging tests finished")

        let testRunner = binDir.appending(path: "test.js")
        if !testOptions.buildOnly {
            var extraArguments: [String] = []
            if testOptions.listTests {
                extraArguments += ["--list-tests"]
            }
            try runTest(
                testRunner: testRunner, context: context,
                extraArguments: extraArguments + testOptions.filter
            )
            try runTest(
                testRunner: testRunner, context: context,
                extraArguments: ["--testing-library", "swift-testing"] + extraArguments
                    + testOptions.filter.flatMap { ["--filter", $0] }
            )
        }
    }

    private func runTest(testRunner: URL, context: PluginContext, extraArguments: [String]) throws {
        let node = try which("node")
        let arguments = ["--experimental-wasi-unstable-preview1", testRunner.path] + extraArguments
        print("Running test...")
        logCommandExecution(node.path, arguments)

        let task = Process()
        task.executableURL = node
        task.arguments = arguments
        task.currentDirectoryURL = context.pluginWorkDirectoryURL
        try task.run()
        task.waitUntilExit()
        // swift-testing returns EX_UNAVAILABLE (which is 69 in wasi-libc) for "no tests found"
        guard task.terminationStatus == 0 || task.terminationStatus == 69 else {
            throw PackageToJSError("Test failed with status \(task.terminationStatus)")
        }
    }

    private func buildWasm(productName: String, context: PluginContext, options: PackageToJS.PackageOptions) throws
        -> PackageManager.BuildResult
    {
        var parameters = PackageManager.BuildParameters(
            configuration: .inherit,
            logging: .concise
        )
        parameters.echoLogs = true
        let buildingForEmbedded =
            ProcessInfo.processInfo.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(
                Bool.init) ?? false
        if !buildingForEmbedded {
            // NOTE: We only support static linking for now, and the new SwiftDriver
            // does not infer `-static-stdlib` for WebAssembly targets intentionally
            // for future dynamic linking support.
            parameters.otherSwiftcFlags = [
                "-static-stdlib", "-Xclang-linker", "-mexec-model=reactor",
            ]
            parameters.otherLinkerFlags = [
                "--export-if-defined=__main_argc_argv"
            ]
        }
        return try self.packageManager.build(.product(productName), parameters: parameters)
    }

    /// Clean if the build graph of the packaging process has changed
    ///
    /// This is especially important to detect user changes debug/release
    /// configurations, which leads to placing the .wasm file in a different
    /// path.
    private func cleanIfBuildGraphChanged(
        root: MiniMake.TaskKey,
        make: MiniMake, context: PluginContext
    ) {
        let buildFingerprint = context.pluginWorkDirectoryURL.appending(path: "minimake.json")
        let lastBuildFingerprint = try? Data(contentsOf: buildFingerprint)
        let currentBuildFingerprint = try? make.computeFingerprint(root: root)
        if lastBuildFingerprint != currentBuildFingerprint {
            print("Build graph changed, cleaning...")
            make.cleanEverything()
        }
        try? currentBuildFingerprint?.write(to: buildFingerprint)
    }

    private func printProgress(task: MiniMake.Task, total: Int, built: Int, message: String) {
        printStderr("[\(built + 1)/\(total)] \(task.displayName): \(message)")
    }

    private func printStderr(_ message: String) {
        fputs(message + "\n", stderr)
    }
}

// MARK: - Options parsing

extension PackageToJS.PackageOptions {
    static func parse(from extractor: inout ArgumentExtractor) -> PackageToJS.PackageOptions {
        let outputPath = extractor.extractOption(named: "output").last
        let packageName = extractor.extractOption(named: "package-name").last
        let explain = extractor.extractFlag(named: "explain")
        return PackageToJS.PackageOptions(
            outputPath: outputPath, packageName: packageName, explain: explain != 0
        )
    }
}

extension PackageToJS.BuildOptions {
    static func parse(from extractor: inout ArgumentExtractor) -> PackageToJS.BuildOptions {
        let product = extractor.extractOption(named: "product").last
        let splitDebug = extractor.extractFlag(named: "split-debug")
        let options = PackageToJS.PackageOptions.parse(from: &extractor)
        return PackageToJS.BuildOptions(product: product, splitDebug: splitDebug != 0, options: options)
    }

    static func help() -> String {
        return """
            OVERVIEW: Builds a JavaScript module from a Swift package.

            USAGE: swift package --swift-sdk <swift-sdk> [SwiftPM options] PackageToJS [options] [subcommand]

            OPTIONS:
              --product <product>   Product to build (default: executable target if there's only one)
              --output <path>       Path to the output directory (default: .build/plugins/PackageToJS/outputs/Package)
              --package-name <name> Name of the package (default: lowercased Package.swift name)
              --explain             Whether to explain the build plan
              --split-debug         Whether to split debug information into a separate .wasm.debug file (default: false)

            SUBCOMMANDS:
              test  Builds and runs tests

            EXAMPLES:
              $ swift package --swift-sdk wasm32-unknown-wasi plugin js
              # Build a specific product
              $ swift package --swift-sdk wasm32-unknown-wasi plugin js --product Example
              # Build in release configuration
              $ swift package --swift-sdk wasm32-unknown-wasi -c release plugin js

              # Run tests
              $ swift package --swift-sdk wasm32-unknown-wasi plugin js test
            """
    }
}

extension PackageToJS.TestOptions {
    static func parse(from extractor: inout ArgumentExtractor) -> PackageToJS.TestOptions {
        let buildOnly = extractor.extractFlag(named: "build-only")
        let listTests = extractor.extractFlag(named: "list-tests")
        let filter = extractor.extractOption(named: "filter")
        let options = PackageToJS.PackageOptions.parse(from: &extractor)
        return PackageToJS.TestOptions(
            buildOnly: buildOnly != 0, listTests: listTests != 0,
            filter: filter, options: options
        )
    }

    static func help() -> String {
        return """
            OVERVIEW: Builds and runs tests

            USAGE: swift package --swift-sdk <swift-sdk> [SwiftPM options] PackageToJS test [options]

            OPTIONS:
              --build-only          Whether to build only (default: false)

            EXAMPLES:
              $ swift package --swift-sdk wasm32-unknown-wasi plugin js test
              # Just build tests, don't run them
              $ swift package --swift-sdk wasm32-unknown-wasi plugin js test --build-only
              $ node .build/plugins/PackageToJS/outputs/PackageTests/bin/test.js
            """
    }
}

// MARK: - PackagePlugin helpers

/// Derive default product from the package
/// - Returns: The name of the product to build
/// - Throws: `PackageToJSError` if there's no executable product or if there's more than one
internal func deriveDefaultProduct(package: Package) throws -> String {
    let executableProducts = package.products(ofType: ExecutableProduct.self)
    guard !executableProducts.isEmpty else {
        throw PackageToJSError(
            "Make sure there's at least one executable product in your Package.swift")
    }
    guard executableProducts.count == 1 else {
        throw PackageToJSError(
            "Failed to disambiguate the product. Pass one of \(executableProducts.map(\.name).joined(separator: ", ")) to the --product option"
        )

    }
    return executableProducts[0].name
}

extension PackageManager.BuildResult {
    /// Find `.wasm` executable artifact
    internal func findWasmArtifact(for product: String) throws -> URL {
        let executables = self.builtArtifacts.filter {
            ($0.kind == .executable) && ($0.url.lastPathComponent == "\(product).wasm")
        }
        guard !executables.isEmpty else {
            throw PackageToJSError(
                "Failed to find '\(product).wasm' from executable artifacts of product '\(product)'"
            )
        }
        guard executables.count == 1, let executable = executables.first else {
            throw PackageToJSError(
                "Failed to disambiguate executable product artifacts from \(executables.map(\.url.path).joined(separator: ", "))"
            )
        }
        return executable.url
    }
}

private func findPackageInDependencies(package: Package, id: Package.ID) -> Package? {
    var visited: Set<Package.ID> = []
    func visit(package: Package) -> Package? {
        if visited.contains(package.id) { return nil }
        visited.insert(package.id)
        if package.id == id { return package }
        for dependency in package.dependencies {
            if let found = visit(package: dependency.package) {
                return found
            }
        }
        return nil
    }
    return visit(package: package)
}

extension PackagingPlanner {
    init(
        options: PackageToJS.PackageOptions,
        context: PluginContext,
        selfPackage: Package,
        outputDir: URL
    ) {
        self.init(
            options: options,
            packageId: context.package.id,
            pluginWorkDirectoryURL: context.pluginWorkDirectoryURL,
            selfPackageDir: selfPackage.directoryURL,
            outputDir: outputDir
        )
    }
}

#endif
