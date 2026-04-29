import XCTest
import JavaScriptKit

@JSFunction(from: .global) func gc() throws(JSException) -> Void

@JSClass struct IdentityModeTestImports {
    @JSFunction static func runJsIdentityModeTests() throws(JSException)
}

final class IdentityModeTests: XCTestCase {
    func testRunJsIdentityModeTests() throws {
        try IdentityModeTestImports.runJsIdentityModeTests()
    }

    /// Verifies that identity-cached wrappers are properly reclaimed by GC.
    ///
    /// Creates an identity-mode object, crosses it multiple times (filling the
    /// identity cache), drops all references, triggers GC + event loop ticks,
    /// and verifies the Swift object is deallocated. This proves that the
    /// WeakRef-based identity cache does not prevent garbage collection.
    func testIdentityCachedWrapperIsReclaimedByGC() async throws {
        RetainLeakSubject.deinits = 0

        // Create object and cross it multiple times to fill identity cache
        _retainLeakSubject = RetainLeakSubject(tag: 99)
        weak var weakSubject = _retainLeakSubject

        // Cross to JS 5 times (populates identity cache with WeakRef)
        for _ in 0..<5 {
            _ = getRetainLeakSubject()
        }

        // Drop Swift-side strong reference
        _retainLeakSubject = nil

        // JS wrapper should still be alive via the identity cache's WeakRef,
        // but WeakRef doesn't prevent GC. Trigger GC + event loop ticks to
        // let FinalizationRegistry fire and call deinit.
        for _ in 0..<100 {
            try gc()
            try await Task.sleep(for: .milliseconds(0))
            if weakSubject == nil {
                break
            }
        }

        // The identity-cached wrapper should have been collected,
        // FinalizationRegistry should have fired, deinit should have run.
        XCTAssertNil(weakSubject, "Identity-cached object should be deallocated after GC")
        XCTAssertEqual(RetainLeakSubject.deinits, 1, "Deinit should fire exactly once")
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
