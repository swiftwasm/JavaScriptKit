#!/usr/bin/env swift

import class Foundation.FileManager
import class Foundation.Process
import class Foundation.ProcessInfo
import struct Foundation.URL
import func Foundation.exit

/// The root directory of the project.
let projectRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()

/// Returns the path to the executable if it is found in the PATH environment variable.
func which(_ executable: String) -> URL? {
    do {
        // Check overriding environment variable
        let envVariable = executable.uppercased().replacingOccurrences(of: "-", with: "_") + "_PATH"
        if let path = ProcessInfo.processInfo.environment[envVariable] {
            if FileManager.default.isExecutableFile(atPath: path) {
                return URL(fileURLWithPath: path)
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
    return nil
}

/// Runs the `swift-format` command with the given arguments in the project root.
func swiftFormat(_ arguments: [String]) throws {
    guard let swiftFormat = which("swift-format") else {
        print("swift-format not found in PATH")
        exit(1)
    }
    print("[Utilities/format.swift] Running \(swiftFormat.path)")
    let task = Process()
    task.executableURL = swiftFormat
    task.arguments = arguments
    task.currentDirectoryURL = projectRoot
    try task.run()
    task.waitUntilExit()
    if task.terminationStatus != 0 {
        print("swift-format failed with status \(task.terminationStatus)")
        exit(1)
    }
    print("[Utilities/format.swift] Done")
}

/// Patterns to exclude from formatting.
let excluded: Set<String> = [
    ".git",
    ".build",
    ".index-build",
    "node_modules",
    "__Snapshots__",
    // Exclude the script itself to avoid changing its file mode.
    URL(fileURLWithPath: #filePath).lastPathComponent,
]

/// Returns a list of file paths to format.
func filesToFormat() -> [String] {
    var files: [String] = []
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(
        at: projectRoot, includingPropertiesForKeys: nil
    )!
    for case let fileURL as URL in enumerator {
        if excluded.contains(fileURL.lastPathComponent) {
            if fileURL.hasDirectoryPath {
                enumerator.skipDescendants()
            }
            continue
        }
        guard fileURL.pathExtension == "swift" else { continue }
        files.append(fileURL.path)
    }
    return files
}

let arguments = CommandLine.arguments[1...]
switch arguments.first {
case "lint":
    try swiftFormat(["lint", "--parallel", "--recursive"] + filesToFormat())
case "format", nil:
    try swiftFormat(["format", "--parallel", "--in-place", "--recursive"] + filesToFormat())
case let subcommand?:
    print("Unknown subcommand: \(subcommand)")
    print("Usage: format.swift lint|format")
    exit(1)
}
