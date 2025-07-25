@preconcurrency import class Foundation.JSONDecoder
@preconcurrency import class Foundation.Process
@preconcurrency import class Foundation.Pipe
@preconcurrency import class Foundation.ProcessInfo
@preconcurrency import class Foundation.FileManager
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import func Foundation.kill
@preconcurrency import var Foundation.SIGINT
@preconcurrency import var Foundation.SIGTERM
import protocol Dispatch.DispatchSourceSignal
import class Dispatch.DispatchSource

internal func which(_ executable: String) throws -> URL {
    do {
        // Check overriding environment variable
        let envVariable = executable.uppercased().replacingOccurrences(of: "-", with: "_") + "_PATH"
        if let path = ProcessInfo.processInfo.environment[envVariable] {
            let url = URL(fileURLWithPath: path).appendingPathComponent(executable)
            if FileManager.default.isExecutableFile(atPath: url.path) {
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
    let paths = ProcessInfo.processInfo.environment["PATH"]!.split(separator: pathSeparator)
    for path in paths {
        let url = URL(fileURLWithPath: String(path)).appendingPathComponent(executable)
        if FileManager.default.isExecutableFile(atPath: url.path) {
            return url
        }
    }
    throw BridgeJSCoreError("Executable \(executable) not found in PATH")
}

extension ImportTS {
    /// Processes a TypeScript definition file and extracts its API information
    mutating func addSourceFile(_ sourceFile: String, tsconfigPath: String) throws {
        let nodePath = try which("node")
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
