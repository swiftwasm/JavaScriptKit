import SwiftSyntax

struct DiagnosticError: Error {
    let node: Syntax
    let message: String

    init(node: some SyntaxProtocol, message: String) {
        self.node = Syntax(node)
        self.message = message
    }

    func formattedDescription(fileName: String) -> String {
        let locationConverter = SourceLocationConverter(fileName: fileName, tree: node.root)
        let location = locationConverter.location(for: node.position)
        return "\(fileName):\(location.line):\(location.column): error: \(message)"
    }
}
