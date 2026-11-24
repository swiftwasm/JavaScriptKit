#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_readBytes")
fileprivate func bjs_readBytes_extern(_ bytesPointer: Int32, _ bytesCount: Int32) -> Float64
#else
fileprivate func bjs_readBytes_extern(_ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_readBytes(_ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    return bjs_readBytes_extern(bytesPointer, bytesCount)
}

func _$readBytes(_ bytes: Swift.Span<UInt8>) throws(JSException) -> Double {
    let ret0 = bytes.bridgeJSWithLoweredParameter { (bytesPointer, bytesCount) in
        let ret = bjs_readBytes(bytesPointer, bytesCount)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_fillBytes")
fileprivate func bjs_fillBytes_extern(_ bytesPointer: Int32, _ bytesCount: Int32) -> Void
#else
fileprivate func bjs_fillBytes_extern(_ bytesPointer: Int32, _ bytesCount: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_fillBytes(_ bytesPointer: Int32, _ bytesCount: Int32) -> Void {
    return bjs_fillBytes_extern(bytesPointer, bytesCount)
}

func _$fillBytes(_ bytes: inout Swift.MutableSpan<UInt8>) throws(JSException) -> Void {
    bytes.bridgeJSWithLoweredParameter { (bytesPointer, bytesCount) in
        bjs_fillBytes(bytesPointer, bytesCount)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_copyBytes")
fileprivate func bjs_copyBytes_extern(_ sourcePointer: Int32, _ sourceCount: Int32, _ labelWord0: Int32, _ labelWord1: Int32, _ labelWord2: Int32, _ destinationPointer: Int32, _ destinationCount: Int32) -> Float64
#else
fileprivate func bjs_copyBytes_extern(_ sourcePointer: Int32, _ sourceCount: Int32, _ labelWord0: Int32, _ labelWord1: Int32, _ labelWord2: Int32, _ destinationPointer: Int32, _ destinationCount: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_copyBytes(_ sourcePointer: Int32, _ sourceCount: Int32, _ labelWord0: Int32, _ labelWord1: Int32, _ labelWord2: Int32, _ destinationPointer: Int32, _ destinationCount: Int32) -> Float64 {
    return bjs_copyBytes_extern(sourcePointer, sourceCount, labelWord0, labelWord1, labelWord2, destinationPointer, destinationCount)
}

func _$copyBytes(_ source: Swift.Span<UInt8>, _ label: String, _ destination: inout Swift.MutableSpan<UInt8>) throws(JSException) -> Double {
    let ret0 = source.bridgeJSWithLoweredParameter { (sourcePointer, sourceCount) in
        let ret1 = label.bridgeJSWithLoweredParameter { (labelWord0, labelWord1, labelWord2) in
            let ret2 = destination.bridgeJSWithLoweredParameter { (destinationPointer, destinationCount) in
                let ret = bjs_copyBytes(sourcePointer, sourceCount, labelWord0, labelWord1, labelWord2, destinationPointer, destinationCount)
                return ret
            }
            return ret2
        }
        return ret1
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ByteSink_init")
fileprivate func bjs_ByteSink_init_extern(_ headerPointer: Int32, _ headerCount: Int32) -> Int32
#else
fileprivate func bjs_ByteSink_init_extern(_ headerPointer: Int32, _ headerCount: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ByteSink_init(_ headerPointer: Int32, _ headerCount: Int32) -> Int32 {
    return bjs_ByteSink_init_extern(headerPointer, headerCount)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ByteSink_checksum_static")
fileprivate func bjs_ByteSink_checksum_static_extern(_ bytesPointer: Int32, _ bytesCount: Int32) -> Float64
#else
fileprivate func bjs_ByteSink_checksum_static_extern(_ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ByteSink_checksum_static(_ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    return bjs_ByteSink_checksum_static_extern(bytesPointer, bytesCount)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ByteSink_write")
fileprivate func bjs_ByteSink_write_extern(_ self: Int32, _ bytesPointer: Int32, _ bytesCount: Int32) -> Float64
#else
fileprivate func bjs_ByteSink_write_extern(_ self: Int32, _ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ByteSink_write(_ self: Int32, _ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    return bjs_ByteSink_write_extern(self, bytesPointer, bytesCount)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ByteSink_read")
fileprivate func bjs_ByteSink_read_extern(_ self: Int32, _ bytesPointer: Int32, _ bytesCount: Int32) -> Float64
#else
fileprivate func bjs_ByteSink_read_extern(_ self: Int32, _ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ByteSink_read(_ self: Int32, _ bytesPointer: Int32, _ bytesCount: Int32) -> Float64 {
    return bjs_ByteSink_read_extern(self, bytesPointer, bytesCount)
}

func _$ByteSink_init(_ header: Swift.Span<UInt8>) throws(JSException) -> JSObject {
    let ret0 = header.bridgeJSWithLoweredParameter { (headerPointer, headerCount) in
        let ret = bjs_ByteSink_init(headerPointer, headerCount)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ByteSink_checksum(_ bytes: Swift.Span<UInt8>) throws(JSException) -> Double {
    let ret0 = bytes.bridgeJSWithLoweredParameter { (bytesPointer, bytesCount) in
        let ret = bjs_ByteSink_checksum_static(bytesPointer, bytesCount)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$ByteSink_write(_ self: JSObject, _ bytes: Swift.Span<UInt8>) throws(JSException) -> Double {
    let ret0 = bytes.bridgeJSWithLoweredParameter { (bytesPointer, bytesCount) in
        let selfValue = self.bridgeJSLowerParameter()
        let ret = bjs_ByteSink_write(selfValue, bytesPointer, bytesCount)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$ByteSink_read(_ self: JSObject, _ bytes: inout Swift.MutableSpan<UInt8>) throws(JSException) -> Double {
    let ret0 = bytes.bridgeJSWithLoweredParameter { (bytesPointer, bytesCount) in
        let selfValue = self.bridgeJSLowerParameter()
        let ret = bjs_ByteSink_read(selfValue, bytesPointer, bytesCount)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}