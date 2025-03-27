#if canImport(PackagePlugin)
// Import minimal Foundation APIs to speed up overload resolution
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import class Foundation.Process
@preconcurrency import class Foundation.ProcessInfo
@preconcurrency import class Foundation.FileManager
@preconcurrency import struct Foundation.CocoaError
@preconcurrency import func Foundation.fputs
@preconcurrency import func Foundation.exit
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
                        build.logText.contains("ld.gold: --export-if-defined=__main_argc_argv: unknown option")
                            || build.logText.contains("-static-stdlib is no longer supported for Apple platforms")
                    else { return nil }
                    let didYouMean =
                        [
                            "swift", "package", "--swift-sdk", "wasm32-unknown-wasi", "js",
                        ] + arguments
                    return """
                        Please pass `--swift-sdk` to "swift package".

                        Did you mean this?
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
            (
                // In case selected toolchain is a Xcode toolchain, not OSS toolchain
                { build, arguments in
                    guard
                        build.logText.contains(
                            "No available targets are compatible with triple \"wasm32-unknown-wasi\""
                        )
                    else {
                        return nil
                    }
                    return """
                        The selected toolchain might be an Xcode toolchain, which doesn't support WebAssembly target.

                        Please use a swift.org Open Source toolchain with WebAssembly support.
                        See https://book.swiftwasm.org/getting-started/setup.html for more information.
                        """
                }),
        ]

    private func emitHintMessage(_ message: String) {
        printStderr("\n" + "\u{001B}[1m\u{001B}[97mHint:\u{001B}[0m " + message)
    }

    private func reportBuildFailure(
        _ build: PackageManager.BuildResult,
        _ arguments: [String]
    ) {
        for diagnostic in Self.friendlyBuildDiagnostics {
            if let message = diagnostic(build, arguments) {
                emitHintMessage(message)
                return
            }
        }
    }

    func performCommand(context: PluginContext, arguments: [String]) throws {
        do {
            if arguments.first == "test" {
                return try performTestCommand(context: context, arguments: Array(arguments.dropFirst()))
            }

            return try performBuildCommand(context: context, arguments: arguments)
        } catch let error as CocoaError where error.code == .fileWriteNoPermission {
            guard let filePath = error.filePath else { throw error }

            let packageDir = context.package.directoryURL
            printStderr("\n\u{001B}[1m\u{001B}[91merror:\u{001B}[0m \(error.localizedDescription)")

            if filePath.hasPrefix(packageDir.path) {
                // Emit hint for --allow-writing-to-package-directory if the destination path
                // is under the package directory
                let didYouMean =
                    [
                        "swift", "package", "--swift-sdk", "wasm32-unknown-wasi",
                        "plugin", "--allow-writing-to-package-directory",
                        "js",
                    ] + arguments
                emitHintMessage(
                    """
                    Please pass `--allow-writing-to-package-directory` to "swift package".

                    Did you mean this?
                        \(didYouMean.joined(separator: " "))
                    """
                )
            } else {
                // Emit hint for --allow-writing-to-directory <directory>
                // if the destination path is outside the package directory
                let didYouMean =
                    [
                        "swift", "package", "--swift-sdk", "wasm32-unknown-wasi",
                        "plugin", "--allow-writing-to-directory", "\(filePath)",
                        "js",
                    ] + arguments
                emitHintMessage(
                    """
                    Please pass `--allow-writing-to-directory <directory>` to "swift package".

                    Did you mean this?
                        \(didYouMean.joined(separator: " "))
                    """
                )
            }
            exit(1)
        }
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
                "Unexpected arguments: \(extractor.remainingArguments.joined(separator: " "))"
            )
            printStderr(PackageToJS.BuildOptions.help())
            exit(1)
        }

        // Build products
        let selfPackage = try findSelfPackage(in: context.package)
        let productName = try buildOptions.product ?? deriveDefaultProduct(package: context.package)
        let build = try buildWasm(
            productName: productName,
            selfPackage: selfPackage,
            context: context,
            options: buildOptions.packageOptions
        )
        guard build.succeeded else {
            reportBuildFailure(build, arguments)
            exit(1)
        }
        let productArtifact = try build.findWasmArtifact(for: productName)
        let outputDir =
            if let outputPath = buildOptions.packageOptions.outputPath {
                URL(fileURLWithPath: outputPath)
            } else {
                context.pluginWorkDirectoryURL.appending(path: "Package")
            }
        var make = MiniMake(
            explain: buildOptions.packageOptions.explain,
            printProgress: self.printProgress
        )
        let planner = PackagingPlanner(
            options: buildOptions.packageOptions,
            context: context,
            selfPackage: selfPackage,
            outputDir: outputDir,
            wasmProductArtifact: productArtifact,
            wasmFilename: productArtifact.lastPathComponent
        )
        let rootTask = try planner.planBuild(
            make: &make,
            buildOptions: buildOptions
        )
        cleanIfBuildGraphChanged(root: rootTask, make: make, context: context)
        print("Packaging...")
        let scope = MiniMake.VariableScope(variables: [:])
        try make.build(output: rootTask, scope: scope)
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
                "Unexpected arguments: \(extractor.remainingArguments.joined(separator: " "))"
            )
            printStderr(PackageToJS.TestOptions.help())
            exit(1)
        }

        let selfPackage = try findSelfPackage(in: context.package)
        let productName = "\(context.package.displayName)PackageTests"
        let build = try buildWasm(
            productName: productName,
            selfPackage: selfPackage,
            context: context,
            options: testOptions.packageOptions
        )
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
            let packageDir = context.package.directoryURL
            let path = packageDir.appending(path: ".build/debug/\(productName).\(fileExtension)").path
            if FileManager.default.fileExists(atPath: path) {
                productArtifact = URL(fileURLWithPath: path)
                break
            }
        }
        guard let productArtifact = productArtifact else {
            throw PackageToJSError(
                "Failed to find '\(productName).wasm' or '\(productName).xctest'"
            )
        }
        let outputDir =
            if let outputPath = testOptions.packageOptions.outputPath {
                URL(fileURLWithPath: outputPath)
            } else {
                context.pluginWorkDirectoryURL.appending(path: "PackageTests")
            }
        var make = MiniMake(
            explain: testOptions.packageOptions.explain,
            printProgress: self.printProgress
        )
        let planner = PackagingPlanner(
            options: testOptions.packageOptions,
            context: context,
            selfPackage: selfPackage,
            outputDir: outputDir,
            wasmProductArtifact: productArtifact,
            // If the product artifact doesn't have a .wasm extension, add it
            // to deliver it with the correct MIME type when serving the test
            // files for browser tests.
            wasmFilename: productArtifact.lastPathComponent.hasSuffix(".wasm")
                ? productArtifact.lastPathComponent
                : productArtifact.lastPathComponent + ".wasm"
        )
        let (rootTask, binDir) = try planner.planTestBuild(
            make: &make
        )
        cleanIfBuildGraphChanged(root: rootTask, make: make, context: context)
        print("Packaging tests...")
        let scope = MiniMake.VariableScope(variables: [:])
        try make.build(output: rootTask, scope: scope)
        print("Packaging tests finished")

        if !testOptions.buildOnly {
            let testRunner = scope.resolve(path: binDir.appending(path: "test.js"))
            try PackageToJS.runTest(
                testRunner: testRunner,
                currentDirectoryURL: context.pluginWorkDirectoryURL,
                outputDir: outputDir,
                testOptions: testOptions
            )
        }
    }

    private func buildWasm(
        productName: String,
        selfPackage: Package,
        context: PluginContext,
        options: PackageToJS.PackageOptions
    ) throws
        -> PackageManager.BuildResult
    {
        let buildConfiguration: PackageManager.BuildConfiguration
        if let configuration = options.configuration {
            guard let _buildConfiguration = PackageManager.BuildConfiguration(rawValue: configuration) else {
                fatalError("Invalid build configuration: \(configuration)")
            }
            buildConfiguration = _buildConfiguration
        } else {
            buildConfiguration = .inherit
        }
        var parameters = PackageManager.BuildParameters(
            configuration: buildConfiguration,
            logging: options.verbose ? .verbose : .concise
        )
        parameters.echoLogs = true
        parameters.otherSwiftcFlags = ["-color-diagnostics"]
        if !isBuildingForEmbedded(selfPackage: selfPackage) {
            // NOTE: We only support static linking for now, and the new SwiftDriver
            // does not infer `-static-stdlib` for WebAssembly targets intentionally
            // for future dynamic linking support.
            parameters.otherSwiftcFlags += [
                "-static-stdlib", "-Xclang-linker", "-mexec-model=reactor",
            ]
            parameters.otherLinkerFlags += [
                "--export-if-defined=__main_argc_argv"
            ]

            // Enable code coverage options if requested
            if options.enableCodeCoverage {
                parameters.otherSwiftcFlags += ["-profile-coverage-mapping", "-profile-generate"]
                parameters.otherCFlags += ["-fprofile-instr-generate", "-fcoverage-mapping"]
            }
        }
        return try self.packageManager.build(.product(productName), parameters: parameters)
    }

    /// Check if the build is for embedded WebAssembly
    private func isBuildingForEmbedded(selfPackage: Package) -> Bool {
        let coreTarget = selfPackage.targets.first { $0.name == "JavaScriptKit" }
        guard let swiftTarget = coreTarget as? SwiftSourceModuleTarget else {
            return false
        }
        // SwiftPM defines "Embedded" compilation condition when `Embedded` experimental
        // feature is enabled.
        // TODO: This should be replaced with a proper trait-based solution in the future.
        return swiftTarget.compilationConditions.contains("Embedded")
    }

    /// Find JavaScriptKit package in the dependencies of the given package recursively
    private func findSelfPackage(in package: Package) throws -> Package {
        guard
            let selfPackage = findPackageInDependencies(
                package: package,
                id: Self.JAVASCRIPTKIT_PACKAGE_ID
            )
        else {
            throw PackageToJSError("Failed to find JavaScriptKit in dependencies!?")
        }
        return selfPackage
    }

    /// Clean if the build graph of the packaging process has changed
    ///
    /// This is especially important to detect user changes debug/release
    /// configurations, which leads to placing the .wasm file in a different
    /// path.
    private func cleanIfBuildGraphChanged(
        root: MiniMake.TaskKey,
        make: MiniMake,
        context: PluginContext
    ) {
        let buildFingerprint = context.pluginWorkDirectoryURL.appending(path: "minimake.json")
        let lastBuildFingerprint = try? Data(contentsOf: buildFingerprint)
        let currentBuildFingerprint = try? make.computeFingerprint(root: root)
        if lastBuildFingerprint != currentBuildFingerprint {
            printStderr("Build graph changed, cleaning...")
            make.cleanEverything(scope: MiniMake.VariableScope(variables: [:]))
        }
        try? currentBuildFingerprint?.write(to: buildFingerprint)
    }

    private func printProgress(context: MiniMake.ProgressPrinter.Context, message: String) {
        let buildCwd = FileManager.default.currentDirectoryPath
        let outputPath = context.scope.resolve(path: context.subject.output).path
        let displayName =
            outputPath.hasPrefix(buildCwd + "/")
            ? String(outputPath.dropFirst(buildCwd.count + 1)) : outputPath
        printStderr("[\(context.built + 1)/\(context.total)] \(displayName): \(message)")
    }
}

private func printStderr(_ message: String) {
    fputs(message + "\n", stderr)
}

// MARK: - Options parsing

extension PackageToJS.PackageOptions {
    static func parse(from extractor: inout ArgumentExtractor) -> PackageToJS.PackageOptions {
        let outputPath = extractor.extractOption(named: "output").last
        let configuration: String? =
            (extractor.extractOption(named: "configuration") + extractor.extractSingleDashOption(named: "c")).last
        let packageName = extractor.extractOption(named: "package-name").last
        let explain = extractor.extractFlag(named: "explain")
        let useCDN = extractor.extractFlag(named: "use-cdn")
        let verbose = extractor.extractFlag(named: "verbose")
        let enableCodeCoverage = extractor.extractFlag(named: "enable-code-coverage")
        return PackageToJS.PackageOptions(
            outputPath: outputPath,
            configuration: configuration,
            packageName: packageName,
            explain: explain != 0,
            verbose: verbose != 0,
            useCDN: useCDN != 0,
            enableCodeCoverage: enableCodeCoverage != 0
        )
    }

    static func optionsHelp() -> String {
        return """
              --output <path>            Path to the output directory (default: .build/plugins/PackageToJS/outputs/Package)
              -c, --configuration <name> The build configuration to use (values: debug, release; default: debug)
              --package-name <name>      Name of the package (default: lowercased Package.swift name)
              --use-cdn                  Whether to use CDN for dependency packages
              --enable-code-coverage     Whether to enable code coverage collection
              --explain                  Whether to explain the build plan
              --verbose                  Whether to print verbose output
            """
    }
}

extension PackageToJS.BuildOptions {
    static func parse(from extractor: inout ArgumentExtractor) -> PackageToJS.BuildOptions {
        let product = extractor.extractOption(named: "product").last
        let noOptimize = extractor.extractFlag(named: "no-optimize")
        let rawDebugInfoFormat = extractor.extractOption(named: "debug-info-format").last
        var debugInfoFormat: PackageToJS.DebugInfoFormat = .none
        if let rawDebugInfoFormat = rawDebugInfoFormat {
            guard let format = PackageToJS.DebugInfoFormat(rawValue: rawDebugInfoFormat) else {
                fatalError(
                    "Invalid debug info format: \(rawDebugInfoFormat), expected one of \(PackageToJS.DebugInfoFormat.allCases.map(\.rawValue).joined(separator: ", "))"
                )
            }
            debugInfoFormat = format
        }
        let packageOptions = PackageToJS.PackageOptions.parse(from: &extractor)
        return PackageToJS.BuildOptions(
            product: product,
            noOptimize: noOptimize != 0,
            debugInfoFormat: debugInfoFormat,
            packageOptions: packageOptions
        )
    }

    static func help() -> String {
        return """
            OVERVIEW: Builds a JavaScript module from a Swift package.

            USAGE: swift package --swift-sdk <swift-sdk> [SwiftPM options] js [options] [subcommand]

            OPTIONS:
              --product <product>        Product to build (default: executable target if there's only one)
              --no-optimize              Whether to disable wasm-opt optimization
              --debug-info-format        The format of debug info to keep in the final wasm file (values: none, dwarf, name; default: none)
            \(PackageToJS.PackageOptions.optionsHelp())

            SUBCOMMANDS:
              test  Builds and runs tests

            EXAMPLES:
              $ swift package --swift-sdk wasm32-unknown-wasi js
              # Build a specific product
              $ swift package --swift-sdk wasm32-unknown-wasi js --product Example
              # Build in release configuration
              $ swift package --swift-sdk wasm32-unknown-wasi js -c release

              # Run tests
              $ swift package --swift-sdk wasm32-unknown-wasi js test
            """
    }
}

extension PackageToJS.TestOptions {
    static func parse(from extractor: inout ArgumentExtractor) -> PackageToJS.TestOptions {
        let buildOnly = extractor.extractFlag(named: "build-only")
        let listTests = extractor.extractFlag(named: "list-tests")
        let filter = extractor.extractOption(named: "filter")
        let prelude = extractor.extractOption(named: "prelude").last
        let environment = extractor.extractOption(named: "environment").last
        let inspect = extractor.extractFlag(named: "inspect")
        let extraNodeArguments = extractor.extractSingleDashOption(named: "Xnode")
        let packageOptions = PackageToJS.PackageOptions.parse(from: &extractor)
        var options = PackageToJS.TestOptions(
            buildOnly: buildOnly != 0,
            listTests: listTests != 0,
            filter: filter,
            prelude: prelude,
            environment: environment,
            inspect: inspect != 0,
            extraNodeArguments: extraNodeArguments,
            packageOptions: packageOptions
        )

        if !options.buildOnly, !options.packageOptions.useCDN {
            options.packageOptions.useCDN = true
        }

        return options
    }

    static func help() -> String {
        return """
            OVERVIEW: Builds and runs tests

            USAGE: swift package --swift-sdk <swift-sdk> [SwiftPM options] js test [options]

            OPTIONS:
              --build-only               Whether to build only
              --prelude <path>           Path to the prelude script
              --environment <name>       The environment to use for the tests (values: node, browser; default: node)
              --inspect                  Whether to run tests in the browser with inspector enabled
              -Xnode <args>              Extra arguments to pass to Node.js
            \(PackageToJS.PackageOptions.optionsHelp())

            EXAMPLES:
              $ swift package --swift-sdk wasm32-unknown-wasi js test
              $ swift package --swift-sdk wasm32-unknown-wasi js test --environment browser
              # Just build tests, don't run them
              $ swift package --swift-sdk wasm32-unknown-wasi js test --build-only
              $ node .build/plugins/PackageToJS/outputs/PackageTests/bin/test.js
            """
    }
}

// MARK: - PackagePlugin helpers

extension ArgumentExtractor {
    fileprivate mutating func extractSingleDashOption(named name: String) -> [String] {
        let parts = remainingArguments.split(separator: "--", maxSplits: 1, omittingEmptySubsequences: false)
        var args = Array(parts[0])
        let literals = Array(parts.count == 2 ? parts[1] : [])

        var values: [String] = []
        var idx = 0
        while idx < args.count {
            var arg = args[idx]
            if arg == "-\(name)" {
                args.remove(at: idx)
                if idx < args.count {
                    let val = args[idx]
                    values.append(val)
                    args.remove(at: idx)
                }
            } else if arg.starts(with: "-\(name)=") {
                args.remove(at: idx)
                arg.removeFirst(2 + name.count)
                values.append(arg)
            } else {
                idx += 1
            }
        }

        self = ArgumentExtractor(args + literals)
        return values
    }
}

/// Derive default product from the package
/// - Returns: The name of the product to build
/// - Throws: `PackageToJSError` if there's no executable product or if there's more than one
internal func deriveDefaultProduct(package: Package) throws -> String {
    let executableProducts = package.products(ofType: ExecutableProduct.self)
    guard !executableProducts.isEmpty else {
        throw PackageToJSError(
            "Make sure there's at least one executable product in your Package.swift"
        )
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
        outputDir: URL,
        wasmProductArtifact: URL,
        wasmFilename: String
    ) {
        let outputBaseName = outputDir.lastPathComponent
        let (configuration, triple) = PackageToJS.deriveBuildConfiguration(wasmProductArtifact: wasmProductArtifact)
        let system = DefaultPackagingSystem(printWarning: printStderr)
        self.init(
            options: options,
            packageId: context.package.id,
            intermediatesDir: BuildPath(
                absolute: context.pluginWorkDirectoryURL.appending(path: outputBaseName + ".tmp").path
            ),
            selfPackageDir: BuildPath(absolute: selfPackage.directoryURL.path),
            outputDir: BuildPath(absolute: outputDir.path),
            wasmProductArtifact: BuildPath(absolute: wasmProductArtifact.path),
            wasmFilename: wasmFilename,
            configuration: configuration,
            triple: triple,
            system: system
        )
    }
}

#endif
