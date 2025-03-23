import Testing

@testable import PackageToJS

@Suite struct PreprocessTests {
    @Test func thenBlock() throws {
        let source = """
            /* #if FOO */
            console.log("FOO");
            /* #else */
            console.log("BAR");
            /* #endif */
            """
        let options = PreprocessOptions(conditions: ["FOO": true])
        let result = try preprocess(source: source, options: options)
        #expect(result == "console.log(\"FOO\");\n")
    }

    @Test func elseBlock() throws {
        let source = """
            /* #if FOO */
            console.log("FOO");
            /* #else */
            console.log("BAR");
            /* #endif */
            """
        let options = PreprocessOptions(conditions: ["FOO": false])
        let result = try preprocess(source: source, options: options)
        #expect(result == "console.log(\"BAR\");\n")
    }

    @Test func onelineIf() throws {
        let source = """
            /* #if FOO */console.log("FOO");/* #endif */
            """
        let options = PreprocessOptions(conditions: ["FOO": true])
        let result = try preprocess(source: source, options: options)
        #expect(result == "console.log(\"FOO\");")
    }

    @Test func undefinedVariable() throws {
        let source = """
            /* #if FOO */
            /* #endif */
            """
        let options = PreprocessOptions(conditions: [:])
        #expect(throws: Error.self) {
            try preprocess(source: source, options: options)
        }
    }

    @Test func substitution() throws {
        let source = "@FOO@"
        let options = PreprocessOptions(substitutions: ["FOO": "BAR"])
        let result = try preprocess(source: source, options: options)
        #expect(result == "BAR")
    }

    @Test func missingEndOfDirective() throws {
        let source = """
            /* #if FOO
            """
        #expect(throws: Error.self) {
            try preprocess(source: source, options: PreprocessOptions())
        }
    }

    @Test(arguments: [
        (foo: true, bar: true, expected: "console.log(\"FOO\");\nconsole.log(\"FOO & BAR\");\n"),
        (foo: true, bar: false, expected: "console.log(\"FOO\");\nconsole.log(\"FOO & !BAR\");\n"),
        (foo: false, bar: true, expected: "console.log(\"!FOO\");\n"),
        (foo: false, bar: false, expected: "console.log(\"!FOO\");\n"),
    ])
    func nestedIfDirectives(foo: Bool, bar: Bool, expected: String) throws {
        let source = """
            /* #if FOO */
            console.log("FOO");
            /* #if BAR */
            console.log("FOO & BAR");
            /* #else */
            console.log("FOO & !BAR");
            /* #endif */
            /* #else */
            console.log("!FOO");
            /* #endif */
            """
        let options = PreprocessOptions(conditions: ["FOO": foo, "BAR": bar])
        let result = try preprocess(source: source, options: options)
        #expect(result == expected)
    }

    @Test func multipleSubstitutions() throws {
        let source = """
            const name = "@NAME@";
            const version = "@VERSION@";
            """
        let options = PreprocessOptions(substitutions: [
            "NAME": "MyApp",
            "VERSION": "1.0.0",
        ])
        let result = try preprocess(source: source, options: options)
        #expect(
            result == """
                const name = "MyApp";
                const version = "1.0.0";
                """
        )
    }

    @Test func invalidVariableName() throws {
        let source = """
            /* #if invalid-name */
            console.log("error");
            /* #endif */
            """
        #expect(throws: Error.self) {
            try preprocess(source: source, options: PreprocessOptions())
        }
    }

    @Test func emptyBlocks() throws {
        let source = """
            /* #if FOO */
            /* #else */
            /* #endif */
            """
        let options = PreprocessOptions(conditions: ["FOO": true])
        let result = try preprocess(source: source, options: options)
        #expect(result == "")
    }

    @Test func ignoreNonDirectiveComments() throws {
        let source = """
            /* Normal comment */
            /** Doc comment */
            """
        let result = try preprocess(source: source, options: PreprocessOptions())
        #expect(result == source)
    }
}
