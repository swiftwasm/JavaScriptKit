@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import class Foundation.JSONEncoder
@preconcurrency import class Foundation.JSONDecoder
@preconcurrency import class Foundation.FileHandle
import SwiftParser
import SwiftSyntax

import BridgeJSCore
import BridgeJSSkeleton
import BridgeJSLink
import BridgeJSUtilities

import ArgumentParser

@main struct BridgeJSToolInternal: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "bridge-js-tool-internal",
        abstract: "BridgeJS Tool Internal",
        version: "0.1.0",
        subcommands: [
            EmitSkeleton.self,
            EmitSwiftThunks.self,
            EmitJS.self,
            EmitDTS.self,
        ]
    )

    static func readData(from file: String) throws -> Data {
        if file == "-" {
            return try FileHandle.standardInput.readToEnd() ?? Data()
        } else {
            return try Data(contentsOf: URL(fileURLWithPath: file))
        }
    }

    struct EmitSkeleton: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "emit-skeleton",
            abstract: "Emit the BridgeJS skeleton",
        )

        @Argument(help: "The input files to emit the BridgeJS skeleton from")
        var inputFiles: [String]

        func run() throws {
            let swiftToSkeleton = SwiftToSkeleton(
                progress: ProgressReporting(verbose: false),
                moduleName: "InternalModule",
                exposeToGlobal: false
            )
            for inputFile in inputFiles.sorted() {
                let content = try String(decoding: readData(from: inputFile), as: UTF8.self)
                if BridgeJSGeneratedFile.hasSkipComment(content) {
                    continue
                }
                let sourceFile = Parser.parse(source: content)
                swiftToSkeleton.addSourceFile(sourceFile, inputFilePath: inputFile)
            }
            let skeleton = try swiftToSkeleton.finalize()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let skeletonData = try encoder.encode(skeleton)
            print(String(data: skeletonData, encoding: .utf8)!)
        }
    }

    struct EmitSwiftThunks: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "emit-swift-thunks",
            abstract: "Emit the Swift thunks",
        )
        @Argument(help: "The skeleton file to emit the Swift thunks from")
        var skeletonFile: String

        func run() throws {
            let skeletonData = try readData(from: skeletonFile)
            let skeleton = try JSONDecoder().decode(BridgeJSSkeleton.self, from: skeletonData)
            let moduleName = "InternalModule"
            let exported = try skeleton.exported.flatMap {
                try ExportSwift(
                    progress: ProgressReporting(verbose: false),
                    moduleName: moduleName,
                    skeleton: $0
                ).finalize()
            }
            let imported = try skeleton.imported.flatMap {
                try ImportTS(
                    progress: ProgressReporting(verbose: false),
                    moduleName: moduleName,
                    skeleton: $0
                ).finalize()
            }
            let combinedSwift = [exported, imported].compactMap { $0 }
            print(combinedSwift.joined(separator: "\n\n"))
        }
    }

    static func linkSkeletons(skeletonFiles: [String]) throws -> (outputJs: String, outputDts: String) {
        var skeletons: [BridgeJSSkeleton] = []
        for skeletonFile in skeletonFiles.sorted() {
            let skeletonData = try readData(from: skeletonFile)
            skeletons.append(try JSONDecoder().decode(BridgeJSSkeleton.self, from: skeletonData))
        }
        let link = BridgeJSLink(skeletons: skeletons, sharedMemory: false)
        return try link.link()
    }

    struct EmitJS: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "emit-js",
            abstract: "Emit the JavaScript glue code",
        )
        @Argument(help: "The skeleton files to emit the JavaScript glue code from")
        var skeletonFiles: [String]

        func run() throws {
            let (outputJs, _) = try linkSkeletons(skeletonFiles: skeletonFiles)
            print(outputJs)
        }
    }

    struct EmitDTS: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "emit-dts",
            abstract: "Emit the TypeScript type definitions",
        )
        @Argument(help: "The skeleton files to emit the TypeScript type definitions from")
        var skeletonFiles: [String]

        func run() throws {
            let (_, outputDts) = try linkSkeletons(skeletonFiles: skeletonFiles)
            print(outputDts)
        }
    }
}
