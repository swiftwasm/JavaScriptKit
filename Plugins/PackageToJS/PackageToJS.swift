@preconcurrency import Foundation // For "stderr"
import PackagePlugin

@main
struct PackageToJS: CommandPlugin {
    struct Options {
        /// Product to build (default: executable target if there's only one)
        var product: String?
        /// Name of the package (default: lowercased Package.swift name)
        var packageName: String?
        /// Whether to explain the build plan
        var explain: Bool = false

        static func parse(from extractor: inout ArgumentExtractor) -> Options {
            let product = extractor.extractOption(named: "product").last
            let packageName = extractor.extractOption(named: "package-name").last
            let explain = extractor.extractFlag(named: "explain")
            return Options(product: product, packageName: packageName, explain: explain != 0)
        }

        static func help() -> String {
            return """
                Usage: swift package --swift-sdk <swift-sdk> plugin run PackageToJS [options]

                Options:
                --product <product>   Product to build (default: executable target if there's only one)
                --package-name <name> Name of the package (default: lowercased Package.swift name)
                --explain             Whether to explain the build plan
                """
        }
    }

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

    func performCommand(context: PluginContext, arguments: [String]) throws {
        if arguments.contains(where: { ["-h", "--help"].contains($0) }) {
            print(Options.help())
            return
        }

        var extractor = ArgumentExtractor(arguments)
        let options = Options.parse(from: &extractor)

        // Build products
        let (build, productName) = try buildWasm(options: options, context: context)
        guard build.succeeded else {
            for diagnostic in Self.friendlyBuildDiagnostics {
                if let message = diagnostic(build, arguments) {
                    fputs("\n" + message + "\n", stderr)
                }
            }
            exit(1)
        }

        let productArtifact = try build.findWasmArtifact(for: productName)
        let outputDir = context.pluginWorkDirectory.appending(subpath: "Package")
        guard
            let selfPackage = findPackageInDependencies(
                package: context.package, id: "javascriptkit")
        else {
            throw PackageToJSError("Failed to find JavaScriptKit in dependencies!?")
        }
        var make = MiniMake(explain: options.explain)
        let allTask = constructPackagingPlan(
            make: &make, options: options, context: context, wasmProductArtifact: productArtifact,
            selfPackage: selfPackage, outputDir: outputDir)
        try make.build(output: allTask)
        print("Packaging finished")
    }

    private func buildWasm(options: Options, context: PluginContext) throws -> (
        build: PackageManager.BuildResult, productName: String
    ) {
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
            parameters.otherLinkerFlags = ["--export-if-defined=__main_argc_argv"]
        }
        let productName = try options.product ?? deriveDefaultProduct(package: context.package)
        let build = try self.packageManager.build(.product(productName), parameters: parameters)
        return (build, productName)
    }

    /// Construct the build plan and return the root task key
    private func constructPackagingPlan(
        make: inout MiniMake,
        options: Options,
        context: PluginContext,
        wasmProductArtifact: PackageManager.BuildResult.BuiltArtifact,
        selfPackage: Package,
        outputDir: Path
    ) -> MiniMake.TaskKey {
        let selfPackageURL = selfPackage.directory
        let selfPath = String(#filePath)
        let outputDirTask = make.addTask(inputFiles: [selfPath], output: outputDir.string) {
            guard !FileManager.default.fileExists(atPath: $0.output) else { return }
            try FileManager.default.createDirectory(
                atPath: $0.output, withIntermediateDirectories: true, attributes: nil)
        }

        var packageInputs: [MiniMake.TaskKey] = []

        func syncFile(from: String, to: String) throws {
            if FileManager.default.fileExists(atPath: to) {
                try FileManager.default.removeItem(atPath: to)
            }
            try FileManager.default.copyItem(atPath: from, toPath: to)
        }

        let wasmFilename = "main.wasm"
        let wasm = make.addTask(
            inputFiles: [selfPath, wasmProductArtifact.path.string], inputTasks: [outputDirTask],
            output: outputDir.appending(subpath: wasmFilename).string,
            // FIXME: This is a hack to ensure that the wasm file is always copied
            // even when release/debug configuration is changed.
            attributes: [.phony]
        ) {
            try syncFile(from: wasmProductArtifact.path.string, to: $0.output)
        }
        packageInputs.append(wasm)

        let packageJSON = make.addTask(
            inputFiles: [selfPath], inputTasks: [outputDirTask],
            output: outputDir.appending(subpath: "package.json").string
        ) {
            // Write package.json
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

        let substitutions = [
            "@PACKAGE_TO_JS_MODULE_PATH@": wasmFilename
        ]
        for (file, output) in [
            ("Plugins/PackageToJS/Templates/index.js", "index.js"),
            ("Plugins/PackageToJS/Templates/index.d.ts", "index.d.ts"),
            ("Sources/JavaScriptKit/Runtime/index.mjs", "runtime.js"),
        ] {
            let inputPath = selfPackageURL.appending(subpath: file).string
            let copied = make.addTask(
                inputFiles: [selfPath, inputPath], inputTasks: [outputDirTask],
                output: outputDir.appending(subpath: output).string
            ) {
                var content = try String(contentsOfFile: inputPath)
                for (key, value) in substitutions {
                    content = content.replacingOccurrences(of: key, with: value)
                }
                try content.write(toFile: $0.output, atomically: true, encoding: .utf8)
            }
            packageInputs.append(copied)
        }
        return make.addTask(inputTasks: packageInputs, output: "all", attributes: [.phony]) { _ in }
    }
}

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
    internal func findWasmArtifact(for product: String) throws
        -> PackageManager.BuildResult.BuiltArtifact
    {
        let executables = self.builtArtifacts.filter {
            $0.kind == .executable && $0.path.lastComponent == "\(product).wasm"
        }
        guard !executables.isEmpty else {
            throw PackageToJSError(
                "Failed to find '\(product).wasm' from executable artifacts of product '\(product)'"
            )
        }
        guard executables.count == 1, let executable = executables.first else {
            throw PackageToJSError(
                "Failed to disambiguate executable product artifacts from \(executables.map(\.path.string).joined(separator: ", "))"
            )
        }
        return executable
    }
}

private func findPackageInDependencies(package: Package, id: Package.ID) -> Package? {
    var visited: Set<Package.ID> = []
    func visit(package: Package) -> Package? {
        if visited.contains(package.id) { return nil }
        visited.insert(package.id)
        for dependency in package.dependencies {
            let dependencyPackage = dependency.package
            if dependencyPackage.id == id {
                return dependencyPackage
            }
        }
        for dependency in package.dependencies {
            if let found = visit(package: dependency.package) {
                return found
            }
        }
        return nil
    }
    return visit(package: package)
}

private struct PackageToJSError: Swift.Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = "Error: " + message
    }
}
