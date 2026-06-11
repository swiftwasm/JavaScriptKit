import XCTest
import JavaScriptKit
import JavaScriptEventLoop

// MARK: - Direction A: Swift awaits a JS async callback

@JS func awaitAsyncCallback(_ fetch: (String) async throws(JSException) -> String) async throws(JSException) -> String {
    let resolved = try await fetch("request")
    return "swift-saw:\(resolved)"
}

// MARK: - Direction B: a Swift async closure handed to JS

@JS func makeAsyncParser() -> JSTypedClosure<(String) async throws(JSException) -> String> {
    return JSTypedClosure { (text: String) async throws(JSException) -> String in
        await Task.yield()
        guard let value = Int(text) else {
            throw JSException(JSError(message: "AsyncParseError: \(text)").jsValue)
        }
        return "parsed:\(value)"
    }
}

@JS func makeAsyncEcho() -> JSTypedClosure<(String) async -> String> {
    return JSTypedClosure { (text: String) async -> String in
        await Task.yield()
        return "echo:\(text)"
    }
}

@JS func makeAsyncRecorder() -> JSTypedClosure<(String) async throws(JSException) -> Void> {
    return JSTypedClosure { (text: String) async throws(JSException) -> Void in
        await Task.yield()
        if text == "boom" {
            throw JSException(JSError(message: "AsyncRecorderError").jsValue)
        }
        AsyncRecorderState.lastRecorded = text
    }
}

@JS func lastRecordedValue() -> String {
    return AsyncRecorderState.lastRecorded
}

@JS func makeAsyncPayloadLoader() -> JSTypedClosure<(Bool) async throws(JSException) -> AsyncPayloadResult> {
    return JSTypedClosure { (succeed: Bool) async throws(JSException) -> AsyncPayloadResult in
        await Task.yield()
        return succeed ? .success("loaded") : .failure(42)
    }
}

@JS func awaitPayloadCallback(
    _ load: (Bool) async throws(JSException) -> AsyncPayloadResult
) async throws(JSException) -> String {
    let first = try await load(true)
    let second = try await load(false)
    return "\(payloadSummary(first))|\(payloadSummary(second))"
}

private func payloadSummary(_ result: AsyncPayloadResult) -> String {
    switch result {
    case .success(let value): return "success:\(value)"
    case .failure(let code): return "failure:\(code)"
    case .idle: return "idle"
    }
}

@JS func makeAsyncPointMaker() -> JSTypedClosure<(Double) async -> DataPoint> {
    return JSTypedClosure { (seed: Double) async -> DataPoint in
        await Task.yield()
        return DataPoint(x: seed, y: seed * 2, label: "async:\(seed)", optCount: nil, optFlag: nil)
    }
}

enum AsyncRecorderState {
    nonisolated(unsafe) static var lastRecorded: String = ""
}

// MARK: - XCTest entry point

final class ClosureAsyncTests: XCTestCase {
    func testRunJsClosureAsyncTests() async throws {
        try await ClosureAsyncImports.runJsClosureAsyncTests()
    }
}

@JSClass struct ClosureAsyncImports {
    @JSFunction static func runJsClosureAsyncTests() async throws(JSException)
}
