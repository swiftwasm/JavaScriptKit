@preconcurrency import class Foundation.JSONDecoder
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

extension ImportTS {
    /// Processes a TypeScript definition file and extracts its API information
    public mutating func addSourceFile(
        _ sourceFile: String,
        tsconfigPath: String,
        nodePath: URL
    ) throws {
        let ts2skeletonPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("JavaScript")
            .appendingPathComponent("bin")
            .appendingPathComponent("ts2skeleton.js")
        let arguments = [ts2skeletonPath.path, sourceFile, "--project", tsconfigPath]

        progress.print("Running ts2skeleton...")
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
            throw BridgeJSCoreError("ts2skeleton returned \(process.terminationStatus)")
        }
        let skeleton = try JSONDecoder().decode(ImportedFileSkeleton.self, from: stdoutData)
        self.addSkeleton(skeleton)
    }
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
