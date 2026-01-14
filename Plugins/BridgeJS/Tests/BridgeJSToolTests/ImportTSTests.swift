import Testing
import Foundation
@testable import BridgeJSCore
@testable import TS2Skeleton

@Suite struct ImportTSTests {
    static let inputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(
        "Inputs"
    )

    static func collectInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix("Async.d.ts") }
    }

    @Test(arguments: collectInputs())
    func snapshot(input: String) throws {
        var api = ImportTS(progress: .silent, moduleName: "Check")
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let nodePath = try #require(which("node"))
        let tsconfigPath = url.deletingLastPathComponent().appendingPathComponent("tsconfig.json")
        try api.addSourceFile(url.path, tsconfigPath: tsconfigPath.path, nodePath: nodePath)
        let outputSwift = try #require(try api.finalize())
        let name = url.deletingPathExtension().deletingPathExtension().deletingPathExtension().lastPathComponent
        try assertSnapshot(
            name: name,
            filePath: #filePath,
            function: #function,
            input: outputSwift.data(using: .utf8)!,
            fileExtension: "swift"
        )
    }
}
