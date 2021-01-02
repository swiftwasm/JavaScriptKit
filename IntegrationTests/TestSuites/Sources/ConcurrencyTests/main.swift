import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.install()
let fetch = JSObject.global.fetch.function!.async

func printZen(prefix: String) async {
  let result = await try! fetch("https://api.github.com/zen").object!
  let text = await try! result.asyncing.text!()
  print("\(prefix): \(text)")
}
func run(_ prefix: String) {
  JavaScriptEventLoop.runAsync {
    await printZen(prefix: prefix)
  }
}

run("Today's lucky word")
