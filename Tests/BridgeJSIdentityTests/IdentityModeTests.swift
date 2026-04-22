import XCTest
import JavaScriptKit

@JSClass struct IdentityModeTestImports {
    @JSFunction static func runJsIdentityModeTests() throws(JSException)
}

final class IdentityModeTests: XCTestCase {
    func testRunJsIdentityModeTests() throws {
        try IdentityModeTestImports.runJsIdentityModeTests()
    }
}

@JS class IdentityTestSubject {
    @JS var value: Int

    @JS init(value: Int) {
        self.value = value
    }

    @JS var currentValue: Int { value }
}

nonisolated(unsafe) private var _sharedSubject: IdentityTestSubject?

@JS func getSharedSubject() -> IdentityTestSubject {
    if _sharedSubject == nil {
        _sharedSubject = IdentityTestSubject(value: 42)
    }
    return _sharedSubject!
}

@JS func resetSharedSubject() {
    _sharedSubject = nil
}

@JS class RetainLeakSubject {
    nonisolated(unsafe) static var deinits: Int = 0

    @JS var tag: Int

    @JS init(tag: Int) {
        self.tag = tag
    }

    deinit {
        Self.deinits += 1
    }
}

nonisolated(unsafe) private var _retainLeakSubject: RetainLeakSubject?

@JS func getRetainLeakSubject() -> RetainLeakSubject {
    if _retainLeakSubject == nil {
        _retainLeakSubject = RetainLeakSubject(tag: 1)
    }
    return _retainLeakSubject!
}

@JS func resetRetainLeakSubject() {
    _retainLeakSubject = nil
}

@JS func getRetainLeakDeinits() -> Int {
    RetainLeakSubject.deinits
}

@JS func resetRetainLeakDeinits() {
    RetainLeakSubject.deinits = 0
}

// MARK: - Array identity tests

@JS class ArrayIdentityElement {
    nonisolated(unsafe) static var deinits: Int = 0

    @JS var tag: Int

    @JS init(tag: Int) {
        self.tag = tag
    }

    deinit {
        Self.deinits += 1
    }
}

nonisolated(unsafe) private var _arrayPool: [ArrayIdentityElement] = []

@JS func setupArrayPool(_ count: Int) {
    _arrayPool = (0..<count).map { ArrayIdentityElement(tag: $0) }
}

@JS func getArrayPool() -> [ArrayIdentityElement] {
    return _arrayPool
}

@JS func getArrayPoolElement(_ index: Int) -> ArrayIdentityElement? {
    guard index >= 0, index < _arrayPool.count else { return nil }
    return _arrayPool[index]
}

@JS func getArrayPoolDeinits() -> Int {
    ArrayIdentityElement.deinits
}

@JS func resetArrayPoolDeinits() {
    ArrayIdentityElement.deinits = 0
}

@JS func clearArrayPool() {
    _arrayPool = []
}
