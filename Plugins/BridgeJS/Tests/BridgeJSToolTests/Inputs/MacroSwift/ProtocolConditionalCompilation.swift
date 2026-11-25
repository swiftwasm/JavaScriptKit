import JavaScriptKit

@JS protocol Logger {
    func log(_ message: String)
    #if DEBUG
    func trace(_ message: String)
    #elseif TESTING
    var verbosity: Int { get set }
    #else
    #if os(WASI)
    func flush()
    #endif
    #endif
}
