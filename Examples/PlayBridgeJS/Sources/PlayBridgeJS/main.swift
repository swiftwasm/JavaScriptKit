import JavaScriptEventLoop
import JavaScriptKit
import SwiftParser
import SwiftSyntax
import class Foundation.JSONDecoder

@JS class PlayBridgeJS {
    @JS init() {}

    /// Structured entry point used by the playground so JS doesn't need to parse diagnostics.
    @JS func updateDetailed(swiftSource: String, dtsSource: String) throws(JSException) -> PlayBridgeJSResult {
        do {
            let output = try _update(swiftSource: swiftSource, dtsSource: dtsSource)
            return PlayBridgeJSResult(output: output, diagnostics: [])
        } catch let error as BridgeJSCoreDiagnosticError {
            let diagnostics = error.diagnostics.map { diag -> PlayBridgeJSDiagnostic in
                let converter = SourceLocationConverter(fileName: diag.file, tree: diag.diagnostic.node.root)
                let start = converter.location(for: diag.diagnostic.node.positionAfterSkippingLeadingTrivia)
                let end = converter.location(for: diag.diagnostic.node.endPositionBeforeTrailingTrivia)

                let startLine = start.line
                let startColumn = start.column
                let endLine = end.line
                let endColumn = max(startColumn + 1, end.column)

                return PlayBridgeJSDiagnostic(
                    file: diag.file,
                    message: diag.diagnostic.message,
                    startLine: startLine,
                    startColumn: startColumn,
                    endLine: endLine,
                    endColumn: endColumn
                )
            }
            return PlayBridgeJSResult(output: nil, diagnostics: diagnostics)
        } catch let error as BridgeJSCoreError {
            throw JSException(message: error.description)
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

@JS struct PlayBridgeJSOutput {
    let outputJs: String
    let outputDts: String
    let importSwiftMacroDecls: String
    let swiftGlue: String
}

@JS struct PlayBridgeJSDiagnostic {
    let file: String
    let message: String
    let startLine: Int
    let startColumn: Int
    let endLine: Int
    let endColumn: Int
}

@JS struct PlayBridgeJSResult {
    let output: PlayBridgeJSOutput?
    let diagnostics: [PlayBridgeJSDiagnostic]
}
