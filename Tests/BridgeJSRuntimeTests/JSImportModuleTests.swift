import JavaScriptKit
import XCTest

@JSFunction(from: .module("/Modules/JSImportModule.mjs"))
func moduleAdd(_ lhs: Int, _ rhs: Int) throws(JSException) -> Int

@JSFunction(jsName: "renamedFunction", from: .module("/Modules/JSImportModule.mjs"))
func moduleRenamed() throws(JSException) -> String

@JSGetter(jsName: "version", from: .module("/Modules/JSImportModule.mjs"))
var moduleVersion: String

@JSClass(jsName: "ModuleCounter", from: .module("/Modules/JSImportModule.mjs"))
struct ImportedModuleCounter {
    @JSFunction init(_ value: Int) throws(JSException)
    @JSFunction static func create(_ value: Int) throws(JSException) -> ImportedModuleCounter
    @JSFunction func increment() throws(JSException) -> Int
    @JSGetter var value: Int
    @JSSetter func setValue(_ value: Int) throws(JSException)
}

final class JSImportModuleTests: XCTestCase {
    func testModuleFunctionAndGetter() throws {
        XCTAssertEqual(try moduleAdd(20, 22), 42)
        XCTAssertEqual(try moduleRenamed(), "loaded from a module")
        XCTAssertEqual(try moduleVersion, "module-v1")
    }

    func testModuleClassStaticAndInstanceAPIs() throws {
        let constructed = try ImportedModuleCounter(3)
        XCTAssertEqual(try constructed.increment(), 4)
        try constructed.setValue(9)
        XCTAssertEqual(try constructed.value, 9)

        let created = try ImportedModuleCounter.create(40)
        XCTAssertEqual(try created.increment(), 41)
    }
}
