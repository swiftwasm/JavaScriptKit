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

        let swiftToSkeleton = SwiftToSkeleton(progress: .silent, moduleName: moduleName, exposeToGlobal: false)
        swiftToSkeleton.addSourceFile(Parser.parse(source: swiftSource), inputFilePath: "Playground.swift")

        let ts2swift = try createTS2Swift()
        let importSwiftMacroDecls = try ts2swift.convert(dtsSource)
        swiftToSkeleton.addSourceFile(
            Parser.parse(source: importSwiftMacroDecls),
            inputFilePath: "Playground.Macros.swift"
        )

        let skeleton = try swiftToSkeleton.finalize()

        let exportResult = try skeleton.exported.flatMap {
            let exportSwift = ExportSwift(progress: .silent, moduleName: moduleName, skeleton: $0)
            return try exportSwift.finalize()
        }
        let importResult = try skeleton.imported.flatMap {
            let importTS = ImportTS(progress: .silent, moduleName: moduleName, skeleton: $0)
            return try importTS.finalize()
        }
        let linker = BridgeJSLink(skeletons: [skeleton], sharedMemory: false)
        let linked = try linker.link()

        return PlayBridgeJSOutput(
            outputJs: linked.outputJs,
            outputDts: linked.outputDts,
            importSwiftMacroDecls: importSwiftMacroDecls,
            swiftGlue: (importResult ?? "") + "\n\n" + (exportResult ?? "")
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
