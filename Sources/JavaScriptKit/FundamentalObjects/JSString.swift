import _CJavaScriptKit

/// `JSString` represents a string in JavaScript and supports bridging string between JavaScript and Swift.
///
/// Conversion between `Swift.String` and `JSString` can be:
///
/// ```swift
/// // Convert `Swift.String` to `JSString`
/// let jsString: JSString = ...
/// let swiftString: String = String(jsString)
///
/// // Convert `JSString` to `Swift.String`
/// let swiftString: String = ...
/// let jsString: JSString = JSString(swiftString)
/// ```
///
public struct JSString: LosslessStringConvertible, Equatable {
    /// The internal representation of JS compatible string
    /// The initializers of this type must initialize `jsObject` or `buffer`.
    /// And the uninitialized one will be lazily initialized
    class Guts {
        // Owns the JS-side ref via JSObject, whose deinit routes the release to
        // the correct thread via swjs_release_remote when destroyed off-owner-thread.
        lazy var jsObject: JSObject = {
            let ref = buffer.withUTF8 { bufferPtr in
                return swjs_decode_string(bufferPtr.baseAddress!, Int32(bufferPtr.count))
            }
            return JSObject(id: ref)  // captures ownerTid = current thread here
        }()

        lazy var buffer: String = {
            var bytesRef: JavaScriptObjectRef = 0
            let bytesLength = Int(swjs_encode_string(jsObject.id, &bytesRef))
            // +1 for null terminator
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesLength + 1)
            defer {
                buffer.deallocate()
                swjs_release(bytesRef)  // bytesRef is a same-thread temporary
            }
            swjs_load_string(bytesRef, buffer)
            buffer[bytesLength] = 0
            return String(decodingCString: UnsafePointer(buffer), as: UTF8.self)
        }()

        init(from stringValue: String) {
            self.buffer = stringValue
        }

        init(from jsRef: JavaScriptObjectRef) {
            self.jsObject = JSObject(id: jsRef)
        }
    }

    let guts: Guts

    internal init(jsRef: JavaScriptObjectRef) {
        self.guts = Guts(from: jsRef)
    }

    /// Instantiate a new `JSString` with given Swift.String.
    public init(_ stringValue: String) {
        self.guts = Guts(from: stringValue)
    }

    /// A Swift representation of this `JSString`.
    /// Note that this accessor may copy the JS string value into Swift side memory.
    public var description: String { guts.buffer }

    /// Returns a Boolean value indicating whether two strings are equal values.
    ///
    /// - Parameters:
    ///   - lhs: A string to compare.
    ///   - rhs: Another string to compare.
    public static func == (lhs: JSString, rhs: JSString) -> Bool {
        withExtendedLifetime(lhs.guts) { lhsGuts in
            withExtendedLifetime(rhs.guts) { rhsGuts in
                return swjs_value_equals(lhsGuts.jsObject.id, rhsGuts.jsObject.id)
            }
        }
    }
}

extension JSString: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

// MARK: - Internal Helpers
extension JSString {

    func asInternalJSRef() -> JavaScriptObjectRef {
        guts.jsObject.id
    }
}
