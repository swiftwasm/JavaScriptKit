import JavaScriptEventLoop
import JavaScriptKit
import SwiftParser
import class Foundation.JSONDecoder

@JS class PlayBridgeJS {
    @JS init() {}

    @JS func update(swiftSource: String, dtsSource: String) throws(JSException) -> PlayBridgeJSOutput {
        do {
            return try _update(swiftSource: swiftSource, dtsSource: dtsSource)
        } catch let error as JSException {
            throw error
        } catch {
            throw JSException(message: String(describing: error))
        }
    }

    func _update(swiftSource: String, dtsSource: String) throws -> PlayBridgeJSOutput {
        let moduleName = "Playground"
        let exportSwift = ExportSwift(progress: .silent, moduleName: moduleName, exposeToGlobal: false)
        let sourceFile = Parser.parse(source: swiftSource)
        try exportSwift.addSourceFile(sourceFile, "Playground.swift")
        let exportResult = try exportSwift.finalize()
        let ts2swift = try createTS2Swift()
        let importSwiftMacroDecls = try ts2swift.convert(dtsSource)
        let importSwift = ImportSwiftMacros(progress: .silent, moduleName: moduleName)
        let importSourceFile = Parser.parse(source: importSwiftMacroDecls)
        importSwift.addSourceFile(importSourceFile, "Playground.Macros.swift")
        importSwift.addSourceFile(sourceFile, "Playground.swift")
        let importResult = try importSwift.finalize()
        let skeleton = BridgeJSSkeleton(
            moduleName: moduleName,
            exported: exportResult.map { $0.outputSkeleton },
            imported: importResult.outputSkeleton
        )
        let linker = BridgeJSLink(skeletons: [skeleton], sharedMemory: false)
        let linked = try linker.link()

        return PlayBridgeJSOutput(
            outputJs: linked.outputJs,
            outputDts: linked.outputDts,
            importSwiftMacroDecls: importSwiftMacroDecls,
            swiftGlue: (importResult.outputSwift ?? "") + "\n\n" + (exportResult?.outputSwift ?? "")
        )
    }
}

@JS class PlayBridgeJSOutput {
    let _outputJs: String
    let _outputDts: String
    let _importSwiftMacroDecls: String
    let _swiftGlue: String

    init(outputJs: String, outputDts: String, importSwiftMacroDecls: String, swiftGlue: String) {
        self._outputJs = outputJs
        self._outputDts = outputDts
        self._importSwiftMacroDecls = importSwiftMacroDecls
        self._swiftGlue = swiftGlue
    }

    @JS func outputJs() -> String { self._outputJs }
    @JS func outputDts() -> String { self._outputDts }
    @JS func importSwiftMacroDecls() -> String { self._importSwiftMacroDecls }
    @JS func swiftGlue() -> String { self._swiftGlue }
}
