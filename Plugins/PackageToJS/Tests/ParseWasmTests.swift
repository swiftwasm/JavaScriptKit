import Foundation
import Testing

@testable import PackageToJS

@Suite struct ParseWasmTests {
    /// A module importing `wasi_snapshot_preview1.proc_exit`, `env.memory` and `env.__stack_pointer`
    private var moduleBytes: Data {
        var bytes: [UInt8] = [
            0x00, 0x61, 0x73, 0x6D,  // magic
            0x01, 0x00, 0x00, 0x00,  // version
        ]
        // Type section: [(i32) -> ()]
        let typeSection: [UInt8] = [0x01, 0x60, 0x01, 0x7F, 0x00]
        bytes += [0x01, UInt8(typeSection.count)] + typeSection

        var importSection: [UInt8] = [0x03]  // 3 imports
        func name(_ value: String) -> [UInt8] {
            [UInt8(value.utf8.count)] + Array(value.utf8)
        }
        importSection += name("wasi_snapshot_preview1") + name("proc_exit") + [0x00, 0x00]
        importSection += name("env") + name("memory") + [0x02, 0x00, 0x11]
        importSection += name("env") + name("__stack_pointer") + [0x03, 0x7F, 0x01]
        bytes += [0x02, UInt8(importSection.count)] + importSection

        return Data(bytes)
    }

    @Test func parseAllImportKinds() throws {
        let imports = try parseImports(moduleBytes: moduleBytes)
        #expect(imports.count == 3)
        #expect(imports[0].module == "wasi_snapshot_preview1")
        #expect(imports[0].name == "proc_exit")
        if case .function = imports[0].kind {
        } else {
            Issue.record("expected a function import, got \(imports[0].kind)")
        }
        #expect(imports[2].name == "__stack_pointer")
        if case .global = imports[2].kind {
        } else {
            Issue.record("expected a global import, got \(imports[2].kind)")
        }
    }

    /// WASI is detected by the imported functions, so they must not be dropped while parsing.
    @Test func deriveFeaturesFromParsedImports() throws {
        let features = WasmFeatures(imports: try parseImports(moduleBytes: moduleBytes))
        #expect(features.isWASI == true)
        #expect(features.sharedMemory == false)
        #expect(features.importedMemory?.minimum == 17)
    }
}
