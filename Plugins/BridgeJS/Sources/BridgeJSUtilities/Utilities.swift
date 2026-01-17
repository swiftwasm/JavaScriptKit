import Foundation

extension String {
    public var capitalizedFirstLetter: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
}

public enum BridgeJSGeneratedFile {
    public static let skipLine = "// bridge-js: skip"

    public static func hasSkipComment(_ content: String) -> Bool {
        content.starts(with: skipLine + "\n")
    }

    public static var swiftPreamble: String {
        """
        \(skipLine)
        // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
        // DO NOT EDIT.
        //
        // To update this file, just rebuild your project or run
        // `swift package bridge-js`.

        @_spi(BridgeJS) @_spi(Experimental) import JavaScriptKit
        """.trimmingCharacters(in: .newlines)
    }
}
