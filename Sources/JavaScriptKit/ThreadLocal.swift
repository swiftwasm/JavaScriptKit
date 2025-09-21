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
    nonisolated(unsafe) var wrappedValue: Value? = nil

    init() where Value: AnyObject {
        wrappedValue = nil
    }
}

/// A property wrapper that lazily initializes a thread-local value
/// for each thread that accesses the value.
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
}
