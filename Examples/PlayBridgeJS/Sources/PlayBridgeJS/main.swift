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
        let exportSwift = ExportSwift(progress: .silent, moduleName: "Playground")
        let sourceFile = Parser.parse(source: swiftSource)
        try exportSwift.addSourceFile(sourceFile, "Playground.swift")
        let exportResult = try exportSwift.finalize()
        var importTS = ImportTS(progress: .silent, moduleName: "Playground")
        let ts2skeleton = try createTS2Skeleton()
        let skeletonJSONString = try ts2skeleton.convert(dtsSource)
        let decoder = JSONDecoder()
        let importSkeleton = try decoder.decode(
            ImportedFileSkeleton.self,
            from: skeletonJSONString.data(using: .utf8)!
        )
        importTS.addSkeleton(importSkeleton)
        let importSwiftGlue = try importTS.finalize()

        let linker = BridgeJSLink(
            exportedSkeletons: exportResult.map { [$0.outputSkeleton] } ?? [],
            importedSkeletons: [
                ImportedModuleSkeleton(
                    moduleName: "Playground",
                    children: [importSkeleton]
                )
            ],
            sharedMemory: false,
            exposeToGlobal: true
        )
        let linked = try linker.link()

        return PlayBridgeJSOutput(
            outputJs: linked.outputJs,
            outputDts: linked.outputDts,
            importSwiftGlue: importSwiftGlue ?? "",
            exportSwiftGlue: exportResult?.outputSwift ?? ""
        )
    }
}

@JS class PlayBridgeJSOutput {
    let _outputJs: String
    let _outputDts: String
    let _importSwiftGlue: String
    let _exportSwiftGlue: String

    init(outputJs: String, outputDts: String, importSwiftGlue: String, exportSwiftGlue: String) {
        self._outputJs = outputJs
        self._outputDts = outputDts
        self._importSwiftGlue = importSwiftGlue
        self._exportSwiftGlue = exportSwiftGlue
    }

    @JS func outputJs() -> String { self._outputJs }
    @JS func outputDts() -> String { self._outputDts }
    @JS func importSwiftGlue() -> String { self._importSwiftGlue }
    @JS func exportSwiftGlue() -> String { self._exportSwiftGlue }
}
