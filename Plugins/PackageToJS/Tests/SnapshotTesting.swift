import Foundation
import Testing

func assertSnapshot(
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
    let snapshotFileName: String =
        "\(function[..<function.firstIndex(of: "(")!])\(variant.map { "_\($0)" } ?? "").\(fileExtension)"
    let snapshotPath = snapshotDir.appendingPathComponent(snapshotFileName)

    if FileManager.default.fileExists(atPath: snapshotPath.path) {
        let existingSnapshot = try String(contentsOf: snapshotPath, encoding: .utf8)
        let ok = existingSnapshot == String(data: input, encoding: .utf8)!
        let actualFilePath = snapshotPath.path + ".actual"
        func buildComment() -> Comment {
            "Snapshot mismatch: \(actualFilePath) \(snapshotPath.path)"
        }
        if !ok {
            try input.write(to: URL(fileURLWithPath: actualFilePath))
        }
        #expect(ok, buildComment(), sourceLocation: sourceLocation)
    } else {
        try input.write(to: snapshotPath)
        #expect(Bool(false), "Snapshot created at \(snapshotPath.path)", sourceLocation: sourceLocation)
    }
}
