#if _runtime(_multithreaded)
#if canImport(wasi_pthread)
import wasi_pthread
#elseif canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif

@propertyWrapper
final class ThreadLocal<Value>: Sendable {
    var wrappedValue: Value? {
        get {
            guard let pointer = pthread_getspecific(key) else {
                return nil
            }
            return fromPointer(pointer)
        }
        set {
            if let oldPointer = pthread_getspecific(key) {
                release(oldPointer)
            }
            if let newValue = newValue {
                let pointer = toPointer(newValue)
                pthread_setspecific(key, pointer)
            }
        }
    }

    private let key: pthread_key_t
    private let toPointer: @Sendable (Value) -> UnsafeMutableRawPointer
    private let fromPointer: @Sendable (UnsafeMutableRawPointer) -> Value
    private let release: @Sendable (UnsafeMutableRawPointer) -> Void

    init() where Value: AnyObject {
        var key = pthread_key_t()
        pthread_key_create(&key, nil)
        self.key = key
        self.toPointer = { Unmanaged.passRetained($0).toOpaque() }
        self.fromPointer = { Unmanaged<Value>.fromOpaque($0).takeUnretainedValue() }
        self.release = { Unmanaged<Value>.fromOpaque($0).release() }
    }

    class Box {
        let value: Value
        init(_ value: Value) {
            self.value = value
        }
    }

    init(boxing _: Void) {
        var key = pthread_key_t()
        pthread_key_create(&key, nil)
        self.key = key
        self.toPointer = {
            let box = Box($0)
            let pointer = Unmanaged.passRetained(box).toOpaque()
            return pointer
        }
        self.fromPointer = {
            let box = Unmanaged<Box>.fromOpaque($0).takeUnretainedValue()
            return box.value
        }
        self.release = { Unmanaged<Box>.fromOpaque($0).release() }
    }

    deinit {
        if let oldPointer = pthread_getspecific(key) {
            release(oldPointer)
        }
        pthread_key_delete(key)
    }
}

@propertyWrapper
final class LazyThreadLocal<Value>: Sendable {
    private let storage: ThreadLocal<Value>

    var wrappedValue: Value {
        if let value = storage.wrappedValue {
            return value
        }
        let value = initialValue()
        storage.wrappedValue = value
        return value
    }

    private let initialValue: @Sendable () -> Value

    init(initialize: @Sendable @escaping () -> Value) where Value: AnyObject {
        self.storage = ThreadLocal()
        self.initialValue = initialize
    }

    init(initialize: @Sendable @escaping () -> Value) {
        self.storage = ThreadLocal(boxing: ())
        self.initialValue = initialize
    }
}

#endif
