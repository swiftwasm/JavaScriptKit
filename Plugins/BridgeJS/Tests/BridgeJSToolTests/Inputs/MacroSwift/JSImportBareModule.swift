@JSFunction(jsName: "basename", from: .module("node:path"))
func nodeBasename(_ path: String) throws(JSException) -> String

@JSFunction(jsName: "dirname", from: .module("node:path"))
func nodeDirname(_ path: String) throws(JSException) -> String

@JSGetter(jsName: "version", from: .module("some-package"))
var packageVersion: String

@JSFunction(jsName: .default, from: .module("default-export-package"))
func callDefaultExport(_ value: Int) throws(JSException) -> Int

@JSGetter(jsName: .default, from: .module("/Modules/DefaultExport.mjs"))
var localDefaultExport: JSObject

@JSClass(jsName: "File", from: .module("@scope/package"))
struct ScopedFile {
    @JSFunction init(_ value: Int) throws(JSException)
    @JSFunction static func create(_ value: Int) throws(JSException) -> ScopedFile
    @JSFunction func read() throws(JSException) -> Int
    @JSGetter var size: Int
}
