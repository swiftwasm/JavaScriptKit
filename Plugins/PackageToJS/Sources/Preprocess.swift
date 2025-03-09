/// Preprocesses a source file
///
/// The preprocessor takes a source file and interprets
/// the following directives:
///
/// - `/* #if <condition> */`
/// - `/* #else */`
/// - `/* #endif */`
/// - `@VARIABLE@`
///
/// The condition is a boolean expression that can use the variables
/// defined in the `options`. Variable names must be `[a-zA-Z0-9_]+`.
/// Contents between `if-else-endif` blocks will be included or excluded
/// based on the condition like C's `#if` directive.
///
/// `@VARIABLE@` will be substituted with the value of the variable.
///
/// The preprocessor will return the preprocessed source code.
func preprocess(source: String, options: PreprocessOptions) throws -> String {
    let tokens = try Preprocessor.tokenize(source: source)
    let parsed = try Preprocessor.parse(tokens: tokens, source: source, options: options)
    return try Preprocessor.preprocess(parsed: parsed, source: source, options: options)
}

struct PreprocessOptions {
    /// The variables to replace in the source code
    var variables: [String: Bool] = [:]
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

    struct PreprocessorError: Error {
        let message: String
        let source: String
        let line: Int
        let column: Int

        init(message: String, source: String, line: Int, column: Int) {
            self.message = message
            self.source = source
            self.line = line
            self.column = column
        }

        init(message: String, source: String, index: String.Index) {
            func consumeLineColumn(from index: String.Index, in source: String) -> (Int, Int) {
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
            self.message = message
            self.source = source
            let (line, column) = consumeLineColumn(from: index, in: source)
            self.line = line
            self.column = column
        }

        static func expected(
            _ expected: CustomStringConvertible, at index: String.Index, in source: String
        ) -> PreprocessorError {
            return PreprocessorError(
                message: "Expected \(expected) at \(index)", source: source, index: index)
        }

        static func unexpected(token: Token, at index: String.Index, in source: String)
            -> PreprocessorError
        {
            return PreprocessorError(
                message: "Unexpected token \(token) at \(index)", source: source, index: index)
        }

        static func eof(at index: String.Index, in source: String) -> PreprocessorError {
            return PreprocessorError(
                message: "Unexpected end of input", source: source, index: index)
        }
    }

    static func tokenize(source: String) throws -> [TokenInfo] {
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
                throw PreprocessorError.expected(expected, at: cursor, in: source)
            }
            consume()
        }

        func expect(_ expected: String) throws {
            guard
                let endIndex = source.index(
                    cursor, offsetBy: expected.count, limitedBy: source.endIndex)
            else {
                throw PreprocessorError.eof(at: cursor, in: source)
            }
            guard source[cursor..<endIndex] == expected else {
                throw PreprocessorError.expected(expected, at: cursor, in: source)
            }
            consume(expected.count)
        }

        func peek() throws -> Character {
            guard cursor < source.endIndex else {
                throw PreprocessorError.eof(at: cursor, in: source)
            }
            return source[cursor]
        }

        func peek2() throws -> (Character, Character) {
            guard cursor < source.endIndex, source.index(after: cursor) < source.endIndex else {
                throw PreprocessorError.eof(at: cursor, in: source)
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
            }
            guard let token = token else {
                throw PreprocessorError(
                    message: "Unexpected directive", source: source, index: cursor)
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
            condition: String, then: [ParseResult], else: [ParseResult], position: String.Index)
    }

    static func parse(tokens: [TokenInfo], source: String, options: PreprocessOptions) throws
        -> [ParseResult]
    {
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
                    throw PreprocessorError.unexpected(
                        token: tokens[cursor].token, at: tokens[cursor].position, in: source)
                }
                consume()
                return .if(condition: condition, then: then, else: `else`, position: ifPosition)
            case .else, .endif:
                throw PreprocessorError.unexpected(
                    token: tokens[cursor].token, at: tokens[cursor].position, in: source)
            }
        }
        var results: [ParseResult] = []
        while cursor < tokens.endIndex {
            results.append(try parse())
        }
        return results
    }

    static func preprocess(parsed: [ParseResult], source: String, options: PreprocessOptions) throws
        -> String
    {
        var result = ""

        func appendBlock(content: String) {
            // Apply substitutions
            var substitutedContent = content
            for (key, value) in options.substitutions {
                substitutedContent = substitutedContent.replacingOccurrences(
                    of: "@" + key + "@", with: value)
            }
            result.append(substitutedContent)
        }

        func evaluate(parsed: ParseResult) throws {
            switch parsed {
            case .block(let content):
                appendBlock(content: content)
            case .if(let condition, let then, let `else`, let position):
                guard let condition = options.variables[condition] else {
                    throw PreprocessorError.unexpected(
                        token: .if(condition: condition), at: position, in: source)
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
