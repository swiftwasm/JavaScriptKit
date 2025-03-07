import Foundation

struct PackageToJS {
    struct Options {
        /// Path to the output directory
        var outputPath: String?
        /// Name of the package (default: lowercased Package.swift name)
        var packageName: String?
        /// Whether to explain the build plan
        var explain: Bool = false
    }

    struct BuildOptions {
        /// Product to build (default: executable target if there's only one)
        var product: String?
        /// Whether to split debug information into a separate file (default: false)
        var splitDebug: Bool
        var options: Options
    }

    struct TestOptions {
        /// Whether to only build tests, don't run them
        var buildOnly: Bool
        /// Lists all tests
        var listTests: Bool
        /// The filter to apply to the tests
        var filter: [String]
        /// The options
        var options: Options
    }
}

func which(_ executable: String) throws -> URL {
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
    throw PackageToJSError("Executable \(executable) not found in PATH")
}

struct PackageToJSError: Swift.Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = "Error: " + message
    }
}
