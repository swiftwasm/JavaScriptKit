import Foundation

public enum JavaScriptModulePath {
    public static func resolve(_ path: String, relativeTo targetDirectory: URL) -> URL? {
        let lowercasedPath = path.lowercased()
        guard path.hasPrefix("/"),
            !path.split(separator: "/").contains(".."),
            lowercasedPath.hasSuffix(".js") || lowercasedPath.hasSuffix(".mjs")
        else {
            return nil
        }

        let targetRoot = targetDirectory.standardizedFileURL
        let file = URL(fileURLWithPath: targetRoot.path + path).standardizedFileURL
        let targetPrefix = targetRoot.path.hasSuffix("/") ? targetRoot.path : targetRoot.path + "/"
        guard file.path.hasPrefix(targetPrefix) else {
            return nil
        }
        return file
    }

    public static func isRegularFile(at url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile == true
    }
}
