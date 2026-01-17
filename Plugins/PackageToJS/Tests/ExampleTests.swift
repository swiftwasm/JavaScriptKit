import Foundation
import Testing

@testable import PackageToJS

extension Trait where Self == ConditionTrait {
    static var requireSwiftSDK: ConditionTrait {
        .enabled(
            if: ProcessInfo.processInfo.environment["SWIFT_SDK_ID"] != nil
                && ProcessInfo.processInfo.environment["SWIFT_PATH"] != nil,
            "Requires SWIFT_SDK_ID and SWIFT_PATH environment variables"
        )
    }

    static func requireSwiftSDK(triple: String) -> ConditionTrait {
        .enabled(
            if: {
                guard let swiftSDKID = ProcessInfo.processInfo.environment["SWIFT_SDK_ID"],
                    ProcessInfo.processInfo.environment["SWIFT_PATH"] != nil
                else {
                    return false
                }
                func sanityCheckCompatibility(triple: String) -> Bool {
                    return swiftSDKID.hasSuffix(triple)
                }
                // For compatibility with old SDKs, we check wasm32-unknown-wasi as well when
                // wasm32-unknown-wasip1 is requested.
                if triple == "wasm32-unknown-wasip1" {
                    if sanityCheckCompatibility(triple: "wasm32-unknown-wasi") {
                        return true
                    }
                }
                return sanityCheckCompatibility(triple: triple)
            }(),
            "Requires SWIFT_SDK_ID and SWIFT_PATH environment variables"
        )
    }

    static func requireEmbeddedSwiftInToolchain(triple: String) -> ConditionTrait {
        // Check if $SWIFT_PATH/../lib/swift/embedded/wasm32-unknown-none-wasm/ exists
        return .enabled(
            if: {
                guard let swiftPath = ProcessInfo.processInfo.environment["SWIFT_PATH"] else {
                    return false
                }
                let embeddedPath = URL(fileURLWithPath: swiftPath).deletingLastPathComponent()
                    .appending(path: "lib/swift/embedded/\(triple)")
                return FileManager.default.fileExists(atPath: embeddedPath.path)
            }(),
            "Requires embedded Swift SDK under $SWIFT_PATH/../lib/swift/embedded"
        )
    }

    static func requireEmbeddedSwiftInSwiftSDK() -> ConditionTrait {
        // Check if ${SWIFT_SDK_ID}-embedded is available
        return .enabled(
            if: {
                /// Check if the Swift SDK with the given ID is available.
                func isSwiftSDKAvailable(_ id: String, swiftPath: String) -> Bool {
                    let swiftExecutable = URL(
                        fileURLWithPath: "swift",
                        relativeTo: URL(fileURLWithPath: swiftPath)
                    )
                    let process = Process()
                    process.executableURL = swiftExecutable
                    let arguments = ["sdk", "configure", "--show-configuration", id]
                    process.arguments = arguments
                    process.standardOutput = FileHandle.nullDevice
                    process.standardError = FileHandle.nullDevice
                    do {
                        try process.run()
                        process.waitUntilExit()
                        return process.terminationStatus == 0
                    } catch {
                        return false
                    }
                }
                guard let swiftPath = ProcessInfo.processInfo.environment["SWIFT_PATH"],
                    let swiftSDKID = ProcessInfo.processInfo.environment["SWIFT_SDK_ID"]
                else {
                    return false
                }
                guard
                    ["wasm32-unknown-wasi", "wasm32-unknown-wasip1"].contains(where: {
                        swiftSDKID.hasSuffix($0)
                    })
                else {
                    // Only non-threads SDKs are supported for embedded in Swift SDK
                    return false
                }
                let embeddedSDKID = "\(swiftSDKID)-embedded"
                return isSwiftSDKAvailable(embeddedSDKID, swiftPath: swiftPath)
            }(),
            "Requires SWIFT_SDK_ID to contain 'embedded'"
        )
    }
}

@Suite struct ExampleTests {
    static func getSwiftSDKID() -> String? {
        ProcessInfo.processInfo.environment["SWIFT_SDK_ID"]
    }

    static func getSwiftPath() -> String? {
        ProcessInfo.processInfo.environment["SWIFT_PATH"]
    }

    static func getEmbeddedSwiftSDKID() -> String? {
        guard let swiftSDKID = getSwiftSDKID() else { return nil }
        return "\(swiftSDKID)-embedded"
    }

    static let repoPath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()

    static func copyRepository(to destination: URL) throws {
        try FileManager.default.createDirectory(
            atPath: destination.path,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let ignore = [
            ".git",
            ".vscode",
            ".build",
            "node_modules",
            "Tests/TemporaryDirectory",
        ]

        let enumerator = FileManager.default.enumerator(atPath: repoPath.path)!
        while let file = enumerator.nextObject() as? String {
            let sourcePath = repoPath.appending(path: file)
            let destinationPath = destination.appending(path: file)
            if ignore.contains(where: { file.hasSuffix($0) }) {
                enumerator.skipDescendants()
                continue
            }

            // Copy symbolic links
            if let resourceValues = try? sourcePath.resourceValues(forKeys: [.isSymbolicLinkKey]),
                resourceValues.isSymbolicLink == true
            {
                try FileManager.default.createDirectory(
                    at: destinationPath.deletingLastPathComponent(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                let linkDestination = try! FileManager.default.destinationOfSymbolicLink(atPath: sourcePath.path)
                try FileManager.default.createSymbolicLink(
                    atPath: destinationPath.path,
                    withDestinationPath: linkDestination
                )
                continue
            }

            // Skip directories
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: sourcePath.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    continue
                }
            }

            do {
                try FileManager.default.createDirectory(
                    at: destinationPath.deletingLastPathComponent(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                try FileManager.default.copyItem(at: sourcePath, to: destinationPath)
            } catch {
                print("Failed to copy \(sourcePath) to \(destinationPath): \(error)")
                throw error
            }
        }
    }

    typealias RunProcess = (_ executableURL: URL, _ args: [String], _ env: [String: String]) throws -> Void
    typealias RunSwift = (_ args: [String], _ env: [String: String]) throws -> Void

    func withPackage(
        at path: String,
        assertTerminationStatus: (Int32) -> Bool = { $0 == 0 },
        body: @escaping (URL, _ runProcess: RunProcess, _ runSwift: RunSwift) throws -> Void
    ) throws {
        try withTemporaryDirectory { tempDir, retain in
            let destination = tempDir.appending(path: Self.repoPath.lastPathComponent)
            try Self.copyRepository(to: destination)
            func runProcess(_ executableURL: URL, _ args: [String], _ env: [String: String]) throws {
                let process = Process()
                process.executableURL = executableURL
                process.arguments = args
                process.currentDirectoryURL = destination.appending(path: path)
                process.environment = ProcessInfo.processInfo.environment.merging(env) { _, new in
                    new
                }
                let stdoutPath = tempDir.appending(path: "stdout.txt")
                let stderrPath = tempDir.appending(path: "stderr.txt")
                _ = FileManager.default.createFile(atPath: stdoutPath.path, contents: nil)
                _ = FileManager.default.createFile(atPath: stderrPath.path, contents: nil)
                process.standardOutput = try FileHandle(forWritingTo: stdoutPath)
                process.standardError = try FileHandle(forWritingTo: stderrPath)

                try process.run()
                process.waitUntilExit()
                if !assertTerminationStatus(process.terminationStatus) {
                    retain = true
                }
                try #require(
                    assertTerminationStatus(process.terminationStatus),
                    """
                    Swift package should build successfully, check \(destination.appending(path: path).path) for details
                    stdout: \(stdoutPath.path)
                    stderr: \(stderrPath.path)
                    arguments: \(args)

                    \((try? String(contentsOf: stdoutPath, encoding: .utf8)) ?? "<<stdout is empty>>")
                    \((try? String(contentsOf: stderrPath, encoding: .utf8)) ?? "<<stderr is empty>>")
                    """
                )
            }
            func runSwift(_ args: [String], _ env: [String: String]) throws {
                let swiftExecutable = URL(
                    fileURLWithPath: "swift",
                    relativeTo: URL(fileURLWithPath: try #require(Self.getSwiftPath()))
                )
                try runProcess(swiftExecutable, args, env)
            }
            try body(destination.appending(path: path), runProcess, runSwift)
        }
    }

    /// FIXME: swift-testing uses too much stack space, so we need to increase the stack size for tests using swift-testing.
    static var stackSizeLinkerFlags: [String] {
        [
            "--toolset",
            URL(fileURLWithPath: #filePath).deletingLastPathComponent().appending(path: "Inputs/example-toolset.json")
                .path,
        ]
    }

    @Test(.requireSwiftSDK)
    func basic() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(at: "Examples/Basic") { packageDir, _, runSwift in
            try runSwift(["package", "--swift-sdk", swiftSDKID, "js"], [:])
            try runSwift(["package", "--swift-sdk", swiftSDKID, "js", "--debug-info-format", "dwarf"], [:])
            try runSwift(["package", "--swift-sdk", swiftSDKID, "js", "--debug-info-format", "name"], [:])
            try runSwift(
                ["package", "--swift-sdk", swiftSDKID, "-Xswiftc", "-DJAVASCRIPTKIT_WITHOUT_WEAKREFS", "js"],
                [:]
            )
        }
    }

    // FIXME: This test fails on Swift 6.3 and later due to memory corruption
    // Enable it back when https://github.com/swiftlang/swift-driver/pull/1987 is included in the snapshot
    #if !compiler(>=6.3)
    @Test(.requireSwiftSDK)
    func testing() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(at: "Examples/Testing") { packageDir, runProcess, runSwift in
            try runProcess(which("npm"), ["install"], [:])
            try runProcess(which("npx"), ["playwright", "install", "chromium-headless-shell"], [:])

            try runSwift(["package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test"], [:])
            try withTemporaryDirectory(body: { tempDir, _ in
                let scriptContent = """
                    const fs = require('fs');
                    const path = require('path');
                    const scriptPath = path.join(__dirname, 'test.txt');
                    fs.writeFileSync(scriptPath, 'Hello, world!');
                    """
                try scriptContent.write(to: tempDir.appending(path: "script.js"), atomically: true, encoding: .utf8)
                let scriptPath = tempDir.appending(path: "script.js")
                try runSwift(
                    [
                        "package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test",
                        "-Xnode=--require=\(scriptPath.path)",
                    ],
                    [:]
                )
                let testPath = tempDir.appending(path: "test.txt")
                try #require(FileManager.default.fileExists(atPath: testPath.path), "test.txt should exist")
                try #require(
                    try String(contentsOf: testPath, encoding: .utf8) == "Hello, world!",
                    "test.txt should be created by the script"
                )
            })
            try runSwift(
                ["package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test", "--environment", "browser"],
                [:]
            )
        }
    }

    #if compiler(>=6.1)
    @Test(.requireSwiftSDK)
    func testingWithCoverage() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        let swiftPath = try #require(Self.getSwiftPath())
        try withPackage(at: "Examples/Testing") { packageDir, runProcess, runSwift in
            try runSwift(
                ["package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test", "--enable-code-coverage"],
                [
                    "LLVM_PROFDATA_PATH": URL(fileURLWithPath: swiftPath).appending(path: "llvm-profdata").path
                ]
            )
            do {
                let profdata = packageDir.appending(
                    path: ".build/plugins/PackageToJS/outputs/PackageTests/default.profdata"
                )
                let possibleWasmPaths = ["CounterPackageTests.xctest.wasm", "CounterPackageTests.wasm"].map {
                    packageDir.appending(path: ".build/plugins/PackageToJS/outputs/PackageTests/\($0)")
                }
                let wasmPath = try #require(
                    possibleWasmPaths.first(where: { FileManager.default.fileExists(atPath: $0.path) }),
                    "No wasm file found"
                )
                let llvmCov = try which("llvm-cov")
                try runProcess(llvmCov, ["report", "-instr-profile", profdata.path, wasmPath.path], [:])
            }
        }
    }
    #endif
    #endif  // compiler(>=6.3)

    @Test(.requireSwiftSDK(triple: "wasm32-unknown-wasip1-threads"))
    func multithreading() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(at: "Examples/Multithreading") { packageDir, _, runSwift in
            try runSwift(["package", "--swift-sdk", swiftSDKID, "js"], [:])
        }
    }

    @Test(.requireSwiftSDK(triple: "wasm32-unknown-wasip1-threads"))
    func offscreenCanvas() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(at: "Examples/OffscrenCanvas") { packageDir, _, runSwift in
            try runSwift(["package", "--swift-sdk", swiftSDKID, "js"], [:])
        }
    }

    @Test(.requireSwiftSDK(triple: "wasm32-unknown-wasip1-threads"))
    func actorOnWebWorker() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(at: "Examples/ActorOnWebWorker") { packageDir, _, runSwift in
            try runSwift(["package", "--swift-sdk", swiftSDKID, "js"], [:])
        }
    }

    // FIXME: This test fails on the current main snapshot
    #if !compiler(>=6.3)
    @Test(.requireEmbeddedSwiftInSwiftSDK())
    func embeddedWasmUnknownWasi() throws {
        let swiftSDKID = try #require(Self.getEmbeddedSwiftSDKID())
        try withPackage(at: "Examples/Embedded") { packageDir, _, runSwift in
            try runSwift(
                ["package", "--swift-sdk", swiftSDKID, "js", "-c", "release"],
                [
                    "JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM": "true"
                ]
            )
        }
    }
    #endif  // compiler(>=6.3)

    @Test(.requireSwiftSDK)
    func continuationLeakInTest_XCTest() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(
            at: "Plugins/PackageToJS/Fixtures/ContinuationLeakInTest/XCTest",
            assertTerminationStatus: { $0 != 0 }
        ) { packageDir, _, runSwift in
            try runSwift(["package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test"], [:])
        }
    }

    #if compiler(>=6.1)
    // TODO: Remove triple restriction once swift-testing is shipped in p1-threads SDK
    @Test(.requireSwiftSDK(triple: "wasm32-unknown-wasi"))
    func continuationLeakInTest_SwiftTesting() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(
            at: "Plugins/PackageToJS/Fixtures/ContinuationLeakInTest/SwiftTesting",
            assertTerminationStatus: { $0 != 0 }
        ) { packageDir, _, runSwift in
            try runSwift(["package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test"], [:])
        }
    }
    #endif

    @Test(.requireSwiftSDK)
    func playwrightOnPageLoad_XCTest() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(
            at: "Plugins/PackageToJS/Fixtures/PlaywrightOnPageLoadTest/XCTest",
            assertTerminationStatus: { $0 == 0 }
        ) { packageDir, runProcess, runSwift in
            try runProcess(which("npm"), ["install"], [:])
            try runProcess(which("npx"), ["playwright", "install", "chromium-headless-shell"], [:])

            try runSwift(
                ["package", "--disable-sandbox"] + Self.stackSizeLinkerFlags + [
                    "--swift-sdk", swiftSDKID, "js", "test", "--environment", "browser",
                    "--playwright-expose", "../expose.js",
                ],
                [:]
            )
        }
    }

    #if compiler(>=6.1)
    // TODO: Remove triple restriction once swift-testing is shipped in p1-threads SDK
    @Test(.requireSwiftSDK(triple: "wasm32-unknown-wasi"))
    func playwrightOnPageLoad_SwiftTesting() throws {
        let swiftSDKID = try #require(Self.getSwiftSDKID())
        try withPackage(
            at: "Plugins/PackageToJS/Fixtures/PlaywrightOnPageLoadTest/SwiftTesting",
            assertTerminationStatus: { $0 == 0 }
        ) { packageDir, runProcess, runSwift in
            try runProcess(which("npm"), ["install"], [:])
            try runProcess(which("npx"), ["playwright", "install", "chromium-headless-shell"], [:])

            try runSwift(
                [
                    "package", "--disable-sandbox", "--swift-sdk", swiftSDKID, "js", "test", "--environment", "browser",
                    "--playwright-expose", "../expose.js",
                ],
                [:]
            )
        }
    }
    #endif
}
