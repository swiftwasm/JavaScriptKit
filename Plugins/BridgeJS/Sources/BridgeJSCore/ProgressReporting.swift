struct ProgressReporting {
    let print: (String) -> Void

    init(verbose: Bool) {
        self.init(print: verbose ? { Swift.print($0) } : { _ in })
    }

    private init(print: @escaping (String) -> Void) {
        self.print = print
    }

    static var silent: ProgressReporting {
        return ProgressReporting(print: { _ in })
    }

    func print(_ message: String) {
        self.print(message)
    }
}
