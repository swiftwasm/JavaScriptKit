import Testing
import Foundation
import SwiftParser
@testable import BridgeJSCore
@testable import TS2Swift

@Suite struct ImportTSTests {
    static let inputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(
        "Inputs"
    )

    static func collectInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(".d.ts") }
    }

    @Test(arguments: collectInputs())
    func snapshot(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let name = url.deletingPathExtension().deletingPathExtension().deletingPathExtension().lastPathComponent
        let nodePath = try #require(which("node"))
        let tsconfigPath = url.deletingLastPathComponent().appendingPathComponent("tsconfig.json")

        let swiftSource = try invokeTS2Swift(
            dtsFile: url.path,
            tsconfigPath: tsconfigPath.path,
            nodePath: nodePath,
            progress: .silent
        )
        try assertSnapshot(
            name: name + ".Macros",
            filePath: #filePath,
            function: #function,
            input: swiftSource.data(using: .utf8)!,
            fileExtension: "swift"
        )

        let sourceFile = Parser.parse(source: swiftSource)
        let importSwift = SwiftToSkeleton(progress: .silent, moduleName: "Check", exposeToGlobal: false)
        importSwift.addSourceFile(sourceFile, inputFilePath: "\(name).Macros.swift")
        let skeleton = try importSwift.finalize()

        guard let imported = skeleton.imported else { return }

        let importTS = ImportTS(progress: .silent, moduleName: "Check", skeleton: imported)
        let outputSwift = try #require(try importTS.finalize())
        try assertSnapshot(
            name: name,
            filePath: #filePath,
            function: #function,
            input: outputSwift.data(using: .utf8)!,
            fileExtension: "swift"
        )
    }
}
