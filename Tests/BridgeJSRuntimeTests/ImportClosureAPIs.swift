@_spi(Experimental) import JavaScriptKit

@JSFunction func jsApplyInt(_ value: Int, _ transform: @escaping (Int) -> Int) throws(JSException) -> Int

@JSFunction func jsMakeAdder(_ base: Int) throws(JSException) -> (Int) -> Int

@JSFunction func jsMapString(_ value: String, _ transform: @escaping (String) -> String) throws(JSException) -> String

@JSFunction func jsMakePrefixer(_ `prefix`: String) throws(JSException) -> (String) -> String

@JSFunction func jsCallTwice(_ value: Int, _ callback: @escaping (Int) -> Void) throws(JSException) -> Int
