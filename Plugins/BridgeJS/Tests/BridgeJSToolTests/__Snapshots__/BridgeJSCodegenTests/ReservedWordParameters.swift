@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check(_ `extension`: Int32, _ `break`: Float64, _ function: Int32, _ inBytes: Int32, _ inLength: Int32) -> Void {
    #if arch(wasm32)
    let `in` = String.bridgeJSLiftParameter(inBytes, inLength)
    let function = Bool.bridgeJSLiftParameter(function)
    let `break` = Double.bridgeJSLiftParameter(`break`)
    let `extension` = Int.bridgeJSLiftParameter(`extension`)
    check(extension: `extension`, break: `break`, function: function, in: `in`)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}