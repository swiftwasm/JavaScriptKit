public struct ProgressReporting {
    let print: (String) -> Void

    public init(verbose: Bool) {
        self.init(print: verbose ? { Swift.print($0) } : { _ in })
    }

    private init(print: @escaping (String) -> Void) {
        self.print = print
    }

    public static var silent: ProgressReporting {
        return ProgressReporting(print: { _ in })
    }

    public func print(_ message: String) {
        self.print(message)
    }
}
