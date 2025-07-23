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
        let ok = existingSnapshot == String(data: input, encoding: .utf8)!
        let actualFilePath = snapshotPath.path + ".actual"
        let updateSnapshots = ProcessInfo.processInfo.environment["UPDATE_SNAPSHOTS"] != nil
        func buildComment() -> Comment {
            "Snapshot mismatch: \(actualFilePath) \(snapshotPath.path)"
        }
        if !updateSnapshots {
            #expect(ok, buildComment(), sourceLocation: sourceLocation)
            if !ok {
                try input.write(to: URL(fileURLWithPath: actualFilePath))
            }
        } else {
            try input.write(to: snapshotPath)
        }
    } else {
        try input.write(to: snapshotPath)
        #expect(Bool(false), "Snapshot created at \(snapshotPath.path)", sourceLocation: sourceLocation)
    }
}
