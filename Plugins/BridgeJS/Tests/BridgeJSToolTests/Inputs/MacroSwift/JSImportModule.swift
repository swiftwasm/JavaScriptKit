@JSFunction(from: .snippet("/Modules/JSImportModule.mjs"))
func moduleAdd(_ lhs: Int, _ rhs: Int) throws(JSException) -> Int

@JSFunction(jsName: "renamedFunction", from: .snippet("/Modules/JSImportModule.mjs"))
func moduleRenamed() throws(JSException) -> String

@JSGetter(jsName: "version", from: .snippet("/Modules/JSImportModule.mjs"))
var moduleVersion: String

@JSClass(from: .snippet("/Modules/ModuleCounter.mjs"))
struct ModuleCounter {
    @JSFunction init(_ value: Int) throws(JSException)
    @JSFunction static func create(_ value: Int) throws(JSException) -> ModuleCounter
    @JSFunction func increment() throws(JSException) -> Int
    @JSGetter var value: Int
    @JSSetter func setValue(_ value: Int) throws(JSException)
}
