#if canImport(PackagePlugin)
import struct Foundation.URL

enum BridgeJSPluginPaths {
    static func skeletonURL(
        targetName: String,
        packageID: String,
        buildPluginWorkDirectoryURL workDirectoryURL: URL
    ) -> URL {
        let pluginsOutputsRootURL =
            workDirectoryURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        return bridgeJSDirectoryURL(
            targetName: targetName,
            packageID: packageID,
            pluginsOutputsRootURL: pluginsOutputsRootURL
        )
        .appending(path: "JavaScript/BridgeJS.json")
    }

    static func skeletonURL(
        targetName: String,
        packageID: String,
        commandPluginWorkDirectoryURL workDirectoryURL: URL
    ) -> URL {
        // workDirectoryURL: ".build/plugins/PackageToJS/outputs/"
        // .build/plugins/outputs/[package]/[target]/destination/BridgeJS/JavaScript/BridgeJS.json
        let pluginsOutputsRootURL =
            workDirectoryURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "outputs")
        return bridgeJSDirectoryURL(
            targetName: targetName,
            packageID: packageID,
            pluginsOutputsRootURL: pluginsOutputsRootURL
        )
        .appending(path: "JavaScript/BridgeJS.json")
    }

    static func bridgeJSSwiftURL(
        targetName: String,
        packageID: String,
        buildPluginWorkDirectoryURL workDirectoryURL: URL
    ) -> URL {
        let pluginsOutputsRootURL =
            workDirectoryURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        return bridgeJSDirectoryURL(
            targetName: targetName,
            packageID: packageID,
            pluginsOutputsRootURL: pluginsOutputsRootURL
        )
        .appending(path: "BridgeJS.swift")
    }

    private static func bridgeJSDirectoryURL(
        targetName: String,
        packageID: String,
        pluginsOutputsRootURL: URL
    ) -> URL {
        pluginsOutputsRootURL
            .appending(path: packageID)
            .appending(path: targetName)
            .appending(path: "destination/BridgeJS")
    }
}
#endif
