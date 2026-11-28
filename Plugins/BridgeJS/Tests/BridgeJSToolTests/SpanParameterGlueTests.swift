import Testing

@Suite struct SpanParameterGlueTests {
    @Test(arguments: [false, true])
    func generatedSpanParameterGlue(sharedMemory: Bool) throws {
        try expectLinkedGlueScriptPasses(
            fixture: "SpanParameters.swift",
            script: "SpanParameterGlueTests.mjs",
            sharedMemory: sharedMemory
        )
    }
}
