import SwiftSyntax

struct DiagnosticError: Error {
    let node: Syntax
    let message: String
    let hint: String?

    init(node: some SyntaxProtocol, message: String, hint: String? = nil) {
        self.node = Syntax(node)
        self.message = message
        self.hint = hint
    }

    func formattedDescription(fileName: String) -> String {
        let locationConverter = SourceLocationConverter(fileName: fileName, tree: node.root)
        let location = locationConverter.location(for: node.position)
        var description = "\(fileName):\(location.line):\(location.column): error: \(message)"
        if let hint {
            description += "\nHint: \(hint)"
        }
        return description
    }
}
