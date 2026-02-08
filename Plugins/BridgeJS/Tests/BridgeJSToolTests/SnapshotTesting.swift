import Testing
import Foundation

func assertSnapshot(
    name: String? = nil,
    filePath: String = #filePath,
    function: String = #function,
    sourceLocation: SourceLocation = #_sourceLocation,
    variant: String? = nil,
    input: Data,
    fileExtension: String = "json"
) throws {
    let testFileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
    let snapshotDir = URL(fileURLWithPath: filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("__Snapshots__")
        .appendingPathComponent(testFileName)
    try FileManager.default.createDirectory(at: snapshotDir, withIntermediateDirectories: true)
    let snapshotName = name ?? String(function[..<function.firstIndex(of: "(")!])
    let snapshotFileName: String = "\(snapshotName)\(variant.map { "_\($0)" } ?? "").\(fileExtension)"
    let snapshotPath = snapshotDir.appendingPathComponent(snapshotFileName)

    if FileManager.default.fileExists(atPath: snapshotPath.path) {
        let existingSnapshot = try String(contentsOf: snapshotPath, encoding: .utf8)
        let actual = String(data: input, encoding: .utf8)!
        let ok = existingSnapshot == actual
        let actualFilePath = snapshotPath.path + ".actual"
        let updateSnapshots = ProcessInfo.processInfo.environment["UPDATE_SNAPSHOTS"] != nil

        if !updateSnapshots {
            if !ok {
                try actual.write(toFile: actualFilePath, atomically: true, encoding: .utf8)
            }

            let diff = ok ? nil : unifiedDiff(expectedPath: snapshotPath.path, actualPath: actualFilePath)
            func buildComment() -> Comment {
                var message = "Snapshot mismatch: \(actualFilePath) \(snapshotPath.path)"
                if let diff {
                    message.append("\n\n" + diff)
                }
                return Comment(rawValue: message)
            }

            #expect(ok, buildComment(), sourceLocation: sourceLocation)
        } else {
            try input.write(to: snapshotPath)
        }
    } else {
        try input.write(to: snapshotPath)
        #expect(Bool(false), "Snapshot created at \(snapshotPath.path)", sourceLocation: sourceLocation)
    }
}

private func unifiedDiff(expectedPath: String, actualPath: String) -> String? {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["diff", "-u", expectedPath, actualPath]
    let output = Pipe()
    process.standardOutput = output
    process.standardError = Pipe()

    do {
        try process.run()
    } catch {
        return nil
    }
    process.waitUntilExit()

    let data = output.fileHandleForReading.readDataToEndOfFile()
    guard !data.isEmpty else { return nil }
    return String(data: data, encoding: .utf8)
}
