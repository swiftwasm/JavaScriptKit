import Foundation
import JavaScriptKit

/// Data <-> Uint8Array conversion. The conversion is lossless and copies the bytes at most once per conversion
extension Data: ConvertibleToJSValue, ConstructibleFromJSValue {
    /// Convert a Data to a JSTypedArray<UInt8>.
    ///
    /// - Returns: A Uint8Array that contains the bytes of the Data.
    public var jsTypedArray: JSTypedArray<UInt8> {
        self.withUnsafeBytes { buffer in
            return JSTypedArray<UInt8>(buffer: buffer.bindMemory(to: UInt8.self))
        }
    }

    /// Convert a Data to a JSValue.
    ///
    /// - Returns: A JSValue that contains the bytes of the Data as a Uint8Array.
    public var jsValue: JSValue { jsTypedArray.jsValue }

    /// Construct a Data from a JSTypedArray<UInt8>.
    public static func construct(from uint8Array: JSTypedArray<UInt8>) -> Data? {
        // First, allocate the data storage
        var data = Data(count: uint8Array.lengthInBytes)
        // Then, copy the byte contents into the Data buffer
        data.withUnsafeMutableBytes { destinationBuffer in
            uint8Array.copyMemory(to: destinationBuffer.bindMemory(to: UInt8.self))
        }
        return data
    }

    /// Construct a Data from a JSValue.
    ///
    /// - Parameter jsValue: The JSValue to construct a Data from.
    /// - Returns: A Data, if the JSValue is a Uint8Array.
    public static func construct(from jsValue: JSValue) -> Data? {
        guard let uint8Array = JSTypedArray<UInt8>(from: jsValue) else {
            // If the JSValue is not a Uint8Array, fail.
            return nil
        }
        return construct(from: uint8Array)
    }
}
