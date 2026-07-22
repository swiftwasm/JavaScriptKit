public struct BridgeJSLinkOutput: Sendable {
    public struct Module: Equatable, Sendable {
        public let relativePath: String
        public let source: String

        init(relativePath: String, source: String) {
            self.relativePath = relativePath
            self.source = source
        }
    }

    public let outputJs: String
    public let outputDts: String
    public let modules: [Module]

    init(outputJs: String, outputDts: String, modules: [Module]) {
        self.outputJs = outputJs
        self.outputDts = outputDts
        self.modules = modules
    }
}
