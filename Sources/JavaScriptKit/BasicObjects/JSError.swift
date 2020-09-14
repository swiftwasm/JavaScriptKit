public final class JSError: Error {
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

    public var stack: String {
        ref.stack.string!
    }
}

extension JSError: CustomStringConvertible {
    public var description: String { ref.description }
}
