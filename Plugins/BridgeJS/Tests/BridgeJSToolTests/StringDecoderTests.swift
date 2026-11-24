import Testing

@Suite struct StringDecoderTests {
    @Test(arguments: [false, true])
    func generatedStringDecoder(sharedMemory: Bool) throws {
        try expectLinkedGlueScriptPasses(
            fixture: "StringReturn.swift",
            script: "StringDecoderTests.mjs",
            sharedMemory: sharedMemory
        )
    }
}
