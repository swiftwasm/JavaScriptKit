// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

struct AnyMyViewControllerDelegate: MyViewControllerDelegate, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func onSomethingHappened() {
    @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onSomethingHappened")
    func _extern_onSomethingHappened(this: Int32)
    _extern_onSomethingHappened(this: Int32(bitPattern: jsObject.id))
    }

    func onValueChanged(_ value: String) {
        @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onValueChanged")
        func _extern_onValueChanged(this: Int32, value: Int32)
        _extern_onValueChanged(this: Int32(bitPattern: jsObject.id), value: value.bridgeJSLowerParameter())
    }

    func onCountUpdated(count: Int) -> Bool {
        @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onCountUpdated")
        func _extern_onCountUpdated(this: Int32, count: Int32) -> Int32
        let ret = _extern_onCountUpdated(this: Int32(bitPattern: jsObject.id), count: count.bridgeJSLowerParameter())
        return Bool.bridgeJSLiftReturn(ret)
    }

    func onLabelUpdated(_ prefix: String, _ suffix: String) {
        @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onLabelUpdated")
        func _extern_onLabelUpdated(this: Int32, prefix: Int32, suffix: Int32)
        _extern_onLabelUpdated(this: Int32(bitPattern: jsObject.id), prefix: prefix.bridgeJSLowerParameter(), suffix: suffix.bridgeJSLowerParameter())
    }

    func isCountEven() -> Bool {
        @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_isCountEven")
        func _extern_isCountEven(this: Int32) -> Int32
        let ret = _extern_isCountEven(this: Int32(bitPattern: jsObject.id))
        return Bool.bridgeJSLiftReturn(ret)
    }

    var eventCount: Int {
        get {
            @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_eventCount_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_eventCount_set")
            func _extern_set(this: Int32, value: Int32)
            _extern_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var delegateName: String {
        get {
            @_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_delegateName_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return String.bridgeJSLiftReturn(ret)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyMyViewControllerDelegate(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

@_expose(wasm, "bjs_MyViewController_init")
@_cdecl("bjs_MyViewController_init")
public func _bjs_MyViewController_init(delegate: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = MyViewController(delegate: AnyMyViewControllerDelegate.bridgeJSLiftParameter(delegate))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_triggerEvent")
@_cdecl("bjs_MyViewController_triggerEvent")
public func _bjs_MyViewController_triggerEvent(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).triggerEvent()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateValue")
@_cdecl("bjs_MyViewController_updateValue")
public func _bjs_MyViewController_updateValue(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).updateValue(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateCount")
@_cdecl("bjs_MyViewController_updateCount")
public func _bjs_MyViewController_updateCount(_self: UnsafeMutableRawPointer, count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).updateCount(_: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateLabel")
@_cdecl("bjs_MyViewController_updateLabel")
public func _bjs_MyViewController_updateLabel(_self: UnsafeMutableRawPointer, prefixBytes: Int32, prefixLength: Int32, suffixBytes: Int32, suffixLength: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).updateLabel(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength), _: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_checkEvenCount")
@_cdecl("bjs_MyViewController_checkEvenCount")
public func _bjs_MyViewController_checkEvenCount(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).checkEvenCount()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_delegate_get")
@_cdecl("bjs_MyViewController_delegate_get")
public func _bjs_MyViewController_delegate_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).delegate as! AnyMyViewControllerDelegate
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_delegate_set")
@_cdecl("bjs_MyViewController_delegate_set")
public func _bjs_MyViewController_delegate_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).delegate = AnyMyViewControllerDelegate.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_secondDelegate_get")
@_cdecl("bjs_MyViewController_secondDelegate_get")
public func _bjs_MyViewController_secondDelegate_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).secondDelegate.flatMap {
        $0 as? AnyMyViewControllerDelegate
    }
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_secondDelegate_set")
@_cdecl("bjs_MyViewController_secondDelegate_set")
public func _bjs_MyViewController_secondDelegate_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).secondDelegate = Optional<AnyMyViewControllerDelegate>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_deinit")
@_cdecl("bjs_MyViewController_deinit")
public func _bjs_MyViewController_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<MyViewController>.fromOpaque(pointer).release()
}

extension MyViewController: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_MyViewController_wrap")
        func _bjs_MyViewController_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_MyViewController_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_MyViewController_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}