@preconcurrency import class Foundation.Process
@preconcurrency import class Foundation.Pipe
@preconcurrency import class Foundation.ProcessInfo
@preconcurrency import class Foundation.FileManager
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import struct Foundation.ObjCBool
@preconcurrency import func Foundation.kill
@preconcurrency import var Foundation.SIGINT
@preconcurrency import var Foundation.SIGTERM
import protocol Dispatch.DispatchSourceSignal
import class Dispatch.DispatchSource
import SwiftParser
import SwiftSyntax

#if canImport(BridgeJSCore)
import BridgeJSCore
#endif
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

internal func which(
    _ executable: String,
    environment: [String: String] = ProcessInfo.processInfo.environment
) -> URL? {
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
    return nil
}

extension BridgeJSConfig {
    /// Find a tool from the system PATH, using environment variable override, or bridge-js.config.json
    public func findTool(_ name: String, targetDirectory: URL) throws -> URL {
        if let tool = tools?[name] {
            return URL(fileURLWithPath: tool)
        }
        if let url = which(name) {
            return url
        }

        // Emit a helpful error message with a suggestion to create a local config override.
        throw BridgeJSCoreError(
            """
            Executable "\(name)" not found in PATH. \
            Hint: Try setting the JAVASCRIPTKIT_\(name.uppercased().replacingOccurrences(of: "-", with: "_"))_EXEC environment variable, \
            or create a local config override with:
              echo '{ "tools": { "\(name)": "'$(which \(name))'" } }' > \(targetDirectory.appendingPathComponent("bridge-js.config.local.json").path)
            """
        )
    }
}

/// Invokes ts2swift to convert TypeScript definitions to macro-annotated Swift
/// - Parameters:
///   - dtsFile: Path to the TypeScript definition file
///   - tsconfigPath: Path to the TypeScript project configuration file
///   - nodePath: Path to the node executable
///   - progress: Progress reporting instance
///   - outputPath: Optional path to write the output file. If nil, output is collected from stdout (for testing)
/// - Returns: The generated Swift source code (always collected from stdout for return value)
public func invokeTS2Swift(
    dtsFile: String,
    globalDtsFiles: [String] = [],
    tsconfigPath: String,
    nodePath: URL,
    progress: ProgressReporting,
    outputPath: String? = nil
) throws -> String {
    let ts2swiftPath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("JavaScript")
        .appendingPathComponent("bin")
        .appendingPathComponent("ts2swift.js")
    var arguments = [ts2swiftPath.path, dtsFile, "--project", tsconfigPath]
    for global in globalDtsFiles {
        arguments.append(contentsOf: ["--global", global])
    }
    if let outputPath = outputPath {
        arguments.append(contentsOf: ["--output", outputPath])
    }

    progress.print("Running ts2swift...")
    progress.print("  \(([nodePath.path] + arguments).joined(separator: " "))")

    let process = Process()
    let stdoutPipe = Pipe()
    nonisolated(unsafe) var stdoutData = Data()

    process.executableURL = nodePath
    process.arguments = arguments
    process.standardOutput = stdoutPipe

    stdoutPipe.fileHandleForReading.readabilityHandler = { handle in
        let data = handle.availableData
        if data.count > 0 {
            stdoutData.append(data)
        }
    }
    try process.forwardTerminationSignals {
        try process.run()
        process.waitUntilExit()
    }

    if process.terminationStatus != 0 {
        throw BridgeJSCoreError("ts2swift returned \(process.terminationStatus)")
    }
    return String(decoding: stdoutData, as: UTF8.self)
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
