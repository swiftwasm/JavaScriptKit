import _CJavaScriptKit

/// Unwind Wasm module execution stack and rewind it after specified milliseconds,
/// allowing JavaScript events to continue to be processed.
/// **Important**: Wasm module must be [asyncified](https://emscripten.org/docs/porting/asyncify.html),
/// otherwise JavaScriptKit's runtime will throw an exception.
public func pauseExecution(milliseconds: Int32) {
    _sleep(milliseconds)
}
