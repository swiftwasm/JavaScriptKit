import Foundation

/// JavaScript files must be declared as build-command inputs so SwiftPM reruns
/// BridgeJS when a referenced module changes.
func discoverJavaScriptModuleFiles(in directory: URL) -> [URL] {
    guard
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
    else { return [] }

    return enumerator.compactMap { $0 as? URL }.filter(isJavaScriptModuleFile).sorted { $0.path < $1.path }
}

func isJavaScriptModuleFile(_ file: URL) -> Bool {
    ["js", "mjs"].contains(file.pathExtension.lowercased())
}
