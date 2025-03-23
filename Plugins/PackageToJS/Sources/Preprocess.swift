/// Preprocesses a source file
///
/// The preprocessor takes a source file and interprets
/// the following directives:
///
/// - `/* #if <condition> */`
/// - `/* #else */`
/// - `/* #endif */`
/// - `@<VARIABLE>@`
/// - `import.meta.<VARIABLE>`
///
/// The condition is a boolean expression that can use the variables
/// defined in the `options`. Variable names must be `[a-zA-Z0-9_]+`.
/// Contents between `if-else-endif` blocks will be included or excluded
/// based on the condition like C's `#if` directive.
///
/// `@<VARIABLE>@` and `import.meta.<VARIABLE>` will be substituted with
/// the value of the variable.
///
/// The preprocessor will return the preprocessed source code.
func preprocess(source: String, file: String? = nil, options: PreprocessOptions) throws -> String {
    let preprocessor = Preprocessor(source: source, file: file, options: options)
    let tokens = try preprocessor.tokenize()
    let parsed = try preprocessor.parse(tokens: tokens)
    return try preprocessor.preprocess(parsed: parsed)
}

struct PreprocessOptions {
    /// The conditions to evaluate in the source code
    var conditions: [String: Bool] = [:]
    /// The variables to substitute in the source code
    var substitutions: [String: String] = [:]
}

private struct Preprocessor {
    enum Token: Equatable {
        case `if`(condition: String)
        case `else`
        case `endif`
        case block(String)
    }

    struct TokenInfo {
        let token: Token
        let position: String.Index
    }

    struct PreprocessorError: Error, CustomStringConvertible {
        let file: String?
        let message: String
        let source: String
        let line: Int
        let column: Int

        init(file: String?, message: String, source: String, line: Int, column: Int) {
            self.file = file
            self.message = message
            self.source = source
            self.line = line
            self.column = column
        }

        init(file: String?, message: String, source: String, index: String.Index) {
            let (line, column) = Self.computeLineAndColumn(from: index, in: source)
            self.init(file: file, message: message, source: source, line: line, column: column)
        }

        /// Get the 1-indexed line and column
        private static func computeLineAndColumn(
            from index: String.Index,
            in source: String
        ) -> (line: Int, column: Int) {
            var line = 1
            var column = 1
            for char in source[..<index] {
                if char == "\n" {
                    line += 1
                    column = 1
                } else {
                    column += 1
                }
            }
            return (line, column)
        }

        var description: String {
            let lines = source.split(separator: "\n", omittingEmptySubsequences: false)
            let lineIndex = line - 1
            let lineNumberWidth = "\(line + 1)".count

            var description = ""
            if let file = file {
                description += "\(file):"
            }
            description += "\(line):\(column): \(message)\n"

            // Show context lines
            if lineIndex > 0 {
                description += formatLine(number: line - 1, content: lines[lineIndex - 1], width: lineNumberWidth)
            }
            description += formatLine(number: line, content: lines[lineIndex], width: lineNumberWidth)
            description += formatPointer(column: column, width: lineNumberWidth)
            if lineIndex + 1 < lines.count {
                description += formatLine(number: line + 1, content: lines[lineIndex + 1], width: lineNumberWidth)
            }

            return description
        }

        private func formatLine(number: Int, content: String.SubSequence, width: Int) -> String {
            return "\(number)".padding(toLength: width, withPad: " ", startingAt: 0) + "  | \(content)\n"
        }

        private func formatPointer(column: Int, width: Int) -> String {
            let padding = String(repeating: " ", count: width) + "  | " + String(repeating: " ", count: column - 1)
            return padding + "^\n"
        }
    }

    let source: String
    let file: String?
    let options: PreprocessOptions

    init(source: String, file: String?, options: PreprocessOptions) {
        self.source = source
        self.file = file
        self.options = options
    }

    func unexpectedTokenError(expected: Token?, token: Token, at index: String.Index) -> PreprocessorError {
        let message = expected.map { "Expected \($0) but got \(token)" } ?? "Unexpected token \(token)"
        return PreprocessorError(
            file: file,
            message: message,
            source: source,
            index: index
        )
    }

    func unexpectedCharacterError(
        expected: CustomStringConvertible,
        character: Character,
        at index: String.Index
    ) -> PreprocessorError {
        return PreprocessorError(
            file: file,
            message: "Expected \(expected) but got \(character)",
            source: source,
            index: index
        )
    }

    func unexpectedDirectiveError(at index: String.Index) -> PreprocessorError {
        return PreprocessorError(
            file: file,
            message: "Unexpected directive",
            source: source,
            index: index
        )
    }

    func eofError(at index: String.Index) -> PreprocessorError {
        return PreprocessorError(
            file: file,
            message: "Unexpected end of input",
            source: source,
            index: index
        )
    }

    func undefinedVariableError(name: String, at index: String.Index) -> PreprocessorError {
        return PreprocessorError(
            file: file,
            message: "Undefined variable \(name)",
            source: source,
            index: index
        )
    }

    func tokenize() throws -> [TokenInfo] {
        var cursor = source.startIndex
        var tokens: [TokenInfo] = []

        var bufferStart = cursor

        func consume(_ count: Int = 1) {
            cursor = source.index(cursor, offsetBy: count)
        }

        func takeIdentifier() throws -> String {
            var identifier = ""
            var char = try peek()
            while ["a"..."z", "A"..."Z", "0"..."9"].contains(where: { $0.contains(char) })
                || char == "_"
            {
                identifier.append(char)
                consume()
                char = try peek()
            }
            return identifier
        }

        func expect(_ expected: Character) throws {
            guard try peek() == expected else {
                throw unexpectedCharacterError(expected: expected, character: try peek(), at: cursor)
            }
            consume()
        }

        func expect(_ expected: String) throws {
            guard
                let endIndex = source.index(
                    cursor,
                    offsetBy: expected.count,
                    limitedBy: source.endIndex
                )
            else {
                throw eofError(at: cursor)
            }
            guard source[cursor..<endIndex] == expected else {
                throw unexpectedCharacterError(expected: expected, character: try peek(), at: cursor)
            }
            consume(expected.count)
        }

        func peek() throws -> Character {
            guard cursor < source.endIndex else {
                throw eofError(at: cursor)
            }
            return source[cursor]
        }

        func peek2() throws -> (Character, Character) {
            guard cursor < source.endIndex, source.index(after: cursor) < source.endIndex else {
                throw eofError(at: cursor)
            }
            let char1 = source[cursor]
            let char2 = source[source.index(after: cursor)]
            return (char1, char2)
        }

        func addToken(_ token: Token, at position: String.Index) {
            tokens.append(.init(token: token, position: position))
        }

        func flushBufferToken() {
            guard bufferStart < cursor else { return }
            addToken(.block(String(source[bufferStart..<cursor])), at: bufferStart)
            bufferStart = cursor
        }

        while cursor < source.endIndex {
            guard case .some(("/", "*")) = try? peek2() else {
                consume()
                continue
            }
            let directiveStart = cursor
            // Push the current buffer to the tokens
            flushBufferToken()

            consume(2)
            // Start of a block comment
            guard try peek2() == (" ", "#") else {
                continue
            }
            consume(2)
            // Start of a directive
            let directiveSource = source[cursor...]
            let directives: [String: () throws -> Token] = [
                "if": {
                    try expect(" ")
                    let condition = try takeIdentifier()
                    return .if(condition: condition)
                },
                "else": {
                    return .else
                },
                "endif": {
                    return .endif
                },
            ]
            var token: Token?
            for (keyword, factory) in directives {
                guard directiveSource.hasPrefix(keyword) else {
                    continue
                }
                consume(keyword.count)
                token = try factory()
                try expect(" */")
                break
            }
            guard let token = token else {
                throw unexpectedDirectiveError(at: directiveStart)
            }
            // Skip a trailing newline
            if (try? peek()) == "\n" {
                consume()
            }
            addToken(token, at: directiveStart)
            bufferStart = cursor
        }
        flushBufferToken()
        return tokens
    }

    enum ParseResult {
        case block(String)
        indirect case `if`(
            condition: String,
            then: [ParseResult],
            else: [ParseResult],
            position: String.Index
        )
    }

    func parse(tokens: [TokenInfo]) throws -> [ParseResult] {
        var cursor = tokens.startIndex

        func consume() {
            cursor = tokens.index(after: cursor)
        }

        func parse() throws -> ParseResult {
            switch tokens[cursor].token {
            case .block(let content):
                consume()
                return .block(content)
            case .if(let condition):
                let ifPosition = tokens[cursor].position
                consume()
                var then: [ParseResult] = []
                var `else`: [ParseResult] = []
                while cursor < tokens.endIndex && tokens[cursor].token != .else
                    && tokens[cursor].token != .endif
                {
                    then.append(try parse())
                }
                if case .else = tokens[cursor].token {
                    consume()
                    while cursor < tokens.endIndex && tokens[cursor].token != .endif {
                        `else`.append(try parse())
                    }
                }
                guard case .endif = tokens[cursor].token else {
                    throw unexpectedTokenError(
                        expected: .endif,
                        token: tokens[cursor].token,
                        at: tokens[cursor].position
                    )
                }
                consume()
                return .if(condition: condition, then: then, else: `else`, position: ifPosition)
            case .else, .endif:
                throw unexpectedTokenError(
                    expected: nil,
                    token: tokens[cursor].token,
                    at: tokens[cursor].position
                )
            }
        }
        var results: [ParseResult] = []
        while cursor < tokens.endIndex {
            results.append(try parse())
        }
        return results
    }

    func preprocess(parsed: [ParseResult]) throws -> String {
        var result = ""

        func appendBlock(content: String) {
            // Apply substitutions
            var substitutedContent = content
            for (key, value) in options.substitutions {
                substitutedContent = substitutedContent.replacingOccurrences(
                    of: "@" + key + "@",
                    with: value
                )
                substitutedContent = substitutedContent.replacingOccurrences(
                    of: "import.meta." + key,
                    with: value
                )
            }
            result.append(substitutedContent)
        }

        func evaluate(parsed: ParseResult) throws {
            switch parsed {
            case .block(let content):
                appendBlock(content: content)
            case .if(let condition, let then, let `else`, let position):
                guard let condition = options.conditions[condition] else {
                    throw undefinedVariableError(name: condition, at: position)
                }
                let blocks = condition ? then : `else`
                for block in blocks {
                    try evaluate(parsed: block)
                }
            }
        }
        for parsed in parsed {
            try evaluate(parsed: parsed)
        }
        return result
    }
}
