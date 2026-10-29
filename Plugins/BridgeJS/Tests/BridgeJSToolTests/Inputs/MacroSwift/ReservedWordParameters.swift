@JS func check(extension: Int, break: Double, function: Bool, in: String) {}
@JS func checkEscaped(_ `in`: String) {}

@JS class ReservedWordBox {
    @JS init(in: Int) {}
    @JS func run(for: Int) {}
    @JS static func make(default: Int) -> Int { 0 }
}

@JS protocol ReservedWordDelegate {
    func handle(in: Int, for: String, _ `default`: Bool)
}

@JSFunction func importedCheck(in: Int, for: String, _ `default`: Bool) throws(JSException)

@JS func checkEscapedCollision(in: Int, _in: Int) {}
@JS func checkGlueNameCollision(instance: Int, swift: String) {}

@JS protocol BacktickedLabelDelegate {
    func handle(`in`: Int)
}

@JSFunction func importedSelfClosure(_ `self`: @escaping () -> Void) throws(JSException)
