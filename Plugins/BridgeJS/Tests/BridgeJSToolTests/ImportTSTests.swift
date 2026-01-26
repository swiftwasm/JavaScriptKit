import Testing
import Foundation
import SwiftParser
@testable import BridgeJSCore
@testable import TS2Swift
@testable import BridgeJSSkeleton

@Suite struct ImportTSTests {
    static let inputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(
        "Inputs"
    )
    static let importMacroInputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .appendingPathComponent("ImportMacroInputs")

    static func collectInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(".d.ts") }
    }

    static func collectImportMacroInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.importMacroInputsDirectory.path)
        return inputs.filter { $0.hasSuffix(".swift") }
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
        let importResult = try #require(try importTS.finalize())
        let closureSupport = try ClosureCodegen().renderSupport(
            for: BridgeJSSkeleton(moduleName: "Check", imported: imported)
        )
        let outputSwift = ([closureSupport, importResult] as [String?])
            .compactMap { $0?.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
        try assertSnapshot(
            name: name,
            filePath: #filePath,
            function: #function,
            input: outputSwift.data(using: .utf8)!,
            fileExtension: "swift"
        )
    }

    @Test(arguments: collectImportMacroInputs())
    func snapshotImportMacroInput(input: String) throws {
        let url = Self.importMacroInputsDirectory.appendingPathComponent(input)
        let name = url.deletingPathExtension().lastPathComponent

        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let importSwift = SwiftToSkeleton(progress: .silent, moduleName: "Check", exposeToGlobal: false)
        importSwift.addSourceFile(sourceFile, inputFilePath: "\(name).swift")
        let skeleton = try importSwift.finalize()

        guard let imported = skeleton.imported else { return }
        let importTS = ImportTS(progress: .silent, moduleName: "Check", skeleton: imported)
        let importResult = try #require(try importTS.finalize())
        let closureSupport = try ClosureCodegen().renderSupport(
            for: BridgeJSSkeleton(moduleName: "Check", imported: imported)
        )
        let outputSwift = ([closureSupport, importResult] as [String?])
            .compactMap { $0?.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
        try assertSnapshot(
            name: name + ".ImportMacros",
            filePath: #filePath,
            function: #function,
            input: outputSwift.data(using: .utf8)!,
            fileExtension: "swift"
        )
    }
}
