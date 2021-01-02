import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.install()
let fetch = JSObject.global.fetch.function!.async

func printZen() async {
  let result = await try! fetch("https://api.github.com/zen").object!
  let text = await try! result.asyncing.text!()
  print(text)
}

JavaScriptEventLoop.runAsync {
  await printZen()
}
