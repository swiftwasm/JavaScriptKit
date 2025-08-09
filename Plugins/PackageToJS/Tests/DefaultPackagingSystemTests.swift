import Foundation
import Testing

@testable import PackageToJS

@Suite struct DefaultPackagingSystemTests {

    @Test func wasmOptFallbackHandlesNewOutputFile() throws {
        try withTemporaryDirectory { tempDir, _ in
            let inputFile = tempDir.appendingPathComponent("input.wasm")
            let outputFile = tempDir.appendingPathComponent("output.wasm")
            let inputContent = Data("input wasm content".utf8)
            try inputContent.write(to: inputFile)

            var warnings: [String] = []
            // Create system with mock which function that always fails to find wasm-opt
            let system = DefaultPackagingSystem(
                printWarning: { warnings.append($0) },
                which: { _ in throw PackageToJSError("wasm-opt not found") }
            )

            // This should work - fallback should copy file
            try system.wasmOpt(["-Os"], input: inputFile.path, output: outputFile.path)

            // Verify the output file was created with input content
            let finalContent = try Data(contentsOf: outputFile)
            #expect(finalContent == inputContent)
            #expect(warnings.contains { $0.contains("wasm-opt is not installed") })
        }
    }

    @Test func wasmOptFallbackHandlesExistingOutputFile() throws {
        try withTemporaryDirectory { tempDir, _ in
            let inputFile = tempDir.appendingPathComponent("input.wasm")
            let outputFile = tempDir.appendingPathComponent("output.wasm")
            let inputContent = Data("input wasm content".utf8)
            let existingContent = Data("existing output content".utf8)

            // Create input file and existing output file
            try inputContent.write(to: inputFile)
            try existingContent.write(to: outputFile)

            var warnings: [String] = []
            // Create system with mock which function that always fails to find wasm-opt
            let system = DefaultPackagingSystem(
                printWarning: { warnings.append($0) },
                which: { _ in throw PackageToJSError("wasm-opt not found") }
            )

            // This should work - fallback should overwrite existing file
            try system.wasmOpt(["-Os"], input: inputFile.path, output: outputFile.path)

            // Verify the output file was overwritten with input content
            let finalContent = try Data(contentsOf: outputFile)
            #expect(finalContent == inputContent)
            #expect(finalContent != existingContent)
            #expect(warnings.contains { $0.contains("wasm-opt is not installed") })
        }
    }
}
