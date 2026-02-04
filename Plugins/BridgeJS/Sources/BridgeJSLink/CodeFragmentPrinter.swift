/// A printer for code fragments.
final class CodeFragmentPrinter {
    private(set) var lines: [String] = []
    private var indentLevel: Int = 0

    init(header: String = "") {
        self.lines.append(contentsOf: header.split(separator: "\n").map { String($0) })
    }

    func nextLine() {
        lines.append("")
    }

    func write<S: StringProtocol>(_ line: S) {
        if line.isEmpty {
            // Empty lines should not have trailing spaces
            lines.append("")
            return
        }
        lines.append(String(repeating: " ", count: indentLevel * 4) + String(line))
    }

    func write(lines: [String]) {
        for line in lines {
            write(line)
        }
    }

    func write(contentsOf printer: CodeFragmentPrinter) {
        self.write(lines: printer.lines)
    }

    func indent() {
        indentLevel += 1
    }

    func unindent() {
        indentLevel -= 1
    }

    func indent(_ body: () throws -> Void) rethrows {
        indentLevel += 1
        try body()
        indentLevel -= 1
    }
}
