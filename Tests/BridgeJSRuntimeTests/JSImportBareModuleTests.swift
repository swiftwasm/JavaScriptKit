import JavaScriptKit
import XCTest

// A Node built-in module. Nothing is copied into the generated package for this;
// the generated JavaScript imports "node:path" directly and Node resolves it.
@JSFunction(jsName: "basename", from: .module("node:path"))
func nodeBasename(_ path: String) throws(JSException) -> String

@JSFunction(jsName: "join", from: .module("node:path"))
func nodeJoin(_ lhs: String, _ rhs: String) throws(JSException) -> String

// An npm package, resolved through node_modules rather than being built into the runtime.
@JSClass(jsName: "File", from: .module("@bjorn3/browser_wasi_shim"))
struct WasiFile {
    @JSFunction init(_ data: JSObject) throws(JSException)
    @JSGetter var size: Int64
}

// The default export of a module, reached with `jsName: .default`.
@JSGetter(jsName: .default, from: .snippet("/Modules/DefaultExport.mjs"))
var defaultExport: JSObject

final class JSImportBareModuleTests: XCTestCase {
    func testNodeBuiltinModule() throws {
        XCTAssertEqual(try nodeBasename("/a/b/c.txt"), "c.txt")
        XCTAssertEqual(try nodeJoin("a", "b"), "a/b")
    }

    func testNpmPackageClass() throws {
        let bytes = JSObject.global.Uint8Array.function!.new(3)
        let file = try WasiFile(bytes)
        XCTAssertEqual(try file.size, 3)
    }

    func testDefaultExport() throws {
        let module = try defaultExport
        XCTAssertEqual(module.label.string, "from the default export")
        XCTAssertEqual(module.triple!(7).number, 21)
    }
}
