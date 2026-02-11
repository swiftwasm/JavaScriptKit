extension String {
    public var capitalizedFirstLetter: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
}

public enum BridgeJSGeneratedFile {
    /// The magic comment to skip processing by BridgeJS.
    public static let skipLine = "// bridge-js: skip"

    public static func hasSkipComment(_ content: String) -> Bool {
        content.starts(with: skipLine + "\n")
    }

    public static var swiftPreamble: String {
        // The generated Swift file itself should not be processed by BridgeJS again.
        """
        \(skipLine)
        // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
        // DO NOT EDIT.
        //
        // To update this file, just rebuild your project or run
        // `swift package bridge-js`.

        @_spi(BridgeJS) import JavaScriptKit
        """
    }
}

/// A printer for code fragments.
public final class CodeFragmentPrinter {
    public private(set) var lines: [String] = []
    private var indentLevel: Int = 0

    public init(header: String = "") {
        self.lines.append(contentsOf: header.split(separator: "\n").map { String($0) })
    }

    public func nextLine() {
        lines.append("")
    }

    public func write<S: StringProtocol>(_ line: S) {
        if line.isEmpty {
            // Empty lines should not have trailing spaces
            lines.append("")
            return
        }
        lines.append(String(repeating: " ", count: indentLevel * 4) + String(line))
    }

    public func write(lines: [String]) {
        for line in lines {
            write(line)
        }
    }

    public func write(contentsOf printer: CodeFragmentPrinter) {
        self.write(lines: printer.lines)
    }

    public func write(multilineString: String) {
        for line in multilineString.split(separator: "\n") {
            write(line)
        }
    }

    public func indent() {
        indentLevel += 1
    }

    public func unindent() {
        indentLevel -= 1
    }

    public func indent(_ body: () throws -> Void) rethrows {
        indentLevel += 1
        try body()
        indentLevel -= 1
    }
}
