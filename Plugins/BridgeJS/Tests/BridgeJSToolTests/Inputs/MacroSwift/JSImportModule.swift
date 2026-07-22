@JSFunction(from: .module("Modules/JSImportModule.mjs"))
func moduleAdd(_ lhs: Int, _ rhs: Int) throws(JSException) -> Int

@JSFunction(jsName: "renamedFunction", from: .module("Modules/JSImportModule.mjs"))
func moduleRenamed() throws(JSException) -> String

@JSGetter(jsName: "version", from: .module("Modules/JSImportModule.mjs"))
var moduleVersion: String

@JSClass(jsName: "ModuleCounter", from: .module("Modules/JSImportModule.mjs"))
struct ImportedModuleCounter {
    @JSFunction init(_ value: Int) throws(JSException)
    @JSFunction static func create(_ value: Int) throws(JSException) -> ImportedModuleCounter
    @JSFunction func increment() throws(JSException) -> Int
    @JSGetter var value: Int
    @JSSetter func setValue(_ value: Int) throws(JSException)
}
