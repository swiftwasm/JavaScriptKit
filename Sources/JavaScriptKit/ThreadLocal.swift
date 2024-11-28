#if arch(wasm32)
#if canImport(wasi_pthread)
import wasi_pthread
#endif
#elseif canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif

/// A property wrapper that provides thread-local storage for a value.
///
/// The value is stored in a thread-local variable, which is a separate copy for each thread.
@propertyWrapper
final class ThreadLocal<Value>: Sendable {
#if compiler(>=6.1) && _runtime(_multithreaded)
    /// The wrapped value stored in the thread-local storage.
    /// The initial value is `nil` for each thread.
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

    /// A constructor that requires `Value` to be `AnyObject` to be
    /// able to store the value directly in the thread-local storage.
    init() where Value: AnyObject {
        var key = pthread_key_t()
        pthread_key_create(&key, nil)
        self.key = key
        self.toPointer = { Unmanaged.passRetained($0).toOpaque() }
        self.fromPointer = { Unmanaged<Value>.fromOpaque($0).takeUnretainedValue() }
        self.release = { Unmanaged<Value>.fromOpaque($0).release() }
    }

    private class Box {
        let value: Value
        init(_ value: Value) {
            self.value = value
        }
    }

    /// A constructor that doesn't require `Value` to be `AnyObject` but
    /// boxing the value in heap-allocated memory.
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
#else
    // Fallback implementation for platforms that don't support pthread
    private class SendableBox: @unchecked Sendable {
        var value: Value? = nil
    }
    private let _storage = SendableBox()
    var wrappedValue: Value? {
        get { _storage.value }
        set { _storage.value = newValue }
    }

    init() where Value: AnyObject {
        wrappedValue = nil
    }
    init(boxing _: Void) {
        wrappedValue = nil
    }
#endif

    deinit {
        preconditionFailure("ThreadLocal can only be used as an immortal storage, cannot be deallocated")
    }
}

/// A property wrapper that lazily initializes a thread-local value
/// for each thread that accesses the value.
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
