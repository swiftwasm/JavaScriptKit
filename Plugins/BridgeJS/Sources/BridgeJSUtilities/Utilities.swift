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
