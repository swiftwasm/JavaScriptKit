public struct BridgeJSCoreError: Swift.Error, CustomStringConvertible {
    public let description: String

    public init(_ message: String) {
        self.description = message
    }
}
