// `weird-package` needs a member name that is not a valid JavaScript identifier, so
// the whole origin falls back to a namespace import. `node:path` in the same file
// keeps using named imports, proving the fallback is per-origin.

@JSFunction(jsName: "kebab-case-function", from: .module("weird-package"))
func kebabCaseFunction() throws(JSException) -> Int

@JSGetter(jsName: "dashed-property", from: .module("weird-package"))
var dashedProperty: String

@JSFunction(jsName: "join", from: .module("node:path"))
func joinPaths(_ lhs: String, _ rhs: String) throws(JSException) -> String
