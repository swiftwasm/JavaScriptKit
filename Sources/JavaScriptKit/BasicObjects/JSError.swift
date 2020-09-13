public final class JSError {
    private let ref: JSObject
    private static let constructor = JSObject.global.Error.function!

    public init(message: String) {
        ref = Self.constructor.new([message])
    }

    public var message: String {
        ref.message.string!
    }

    public var name: String {
        ref.name.string!
    }
}

extension JSError: CustomStringConvertible {
    public var description: String { ref.description }
}