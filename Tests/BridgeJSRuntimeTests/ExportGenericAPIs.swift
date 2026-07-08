import XCTest
import JavaScriptKit

@JS public struct ExportGenericPoint {
    public var x: Int
    public var y: Int

    @JS public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

@JS public final class ExportGenericBox {
    @JS public var value: Int
    @JS public init(value: Int) {
        self.value = value
    }
    @JS public func get() -> Int {
        value
    }
}

@JS public func exportGenericIdentity<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
    value
}

@JS public func exportGenericEcho<T: _BridgedSwiftGenericBridgeable>(_ value: T, tag: Int) -> T {
    value
}

@JS public func exportGenericPickFirst<T: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) -> T {
    a
}

@JS public func exportGenericPickSecond<T: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) -> T {
    b
}

@JS public enum ExportGenericOutcome {
    case ok(value: Int)
    case fail(reason: String)
}

@JS public func makeExportGenericOutcome(_ value: Int) -> ExportGenericOutcome {
    .ok(value: value)
}

@JS public func exportGenericOutcomeValue(_ outcome: ExportGenericOutcome) -> Int {
    if case .ok(let value) = outcome {
        return value
    }
    return -1
}

@JS public func exportGenericArrayIdentity<T: _BridgedSwiftGenericBridgeable>(_ values: [T]) -> [T] {
    values
}

@JS public func exportGenericOptionalIdentity<T: _BridgedSwiftGenericBridgeable>(_ value: T?) -> T? {
    value
}

@JS public func exportGenericDictIdentity<T: _BridgedSwiftGenericBridgeable>(_ values: [String: T]) -> [String: T] {
    values
}

nonisolated(unsafe) var _lastWrappedPoint = ExportGenericPoint(x: 0, y: 0)
nonisolated(unsafe) var _lastTag = 0

@JS public func exportGenericWrapPointAndTag<T: _BridgedSwiftGenericBridgeable>(
    _ p: ExportGenericPoint,
    tag: Int,
    _ value: T
) -> T {
    _lastWrappedPoint = p
    _lastTag = tag
    return value
}

@JS
public func exportGenericCombineFirst<
    T: _BridgedSwiftGenericBridgeable,
    U: _BridgedSwiftGenericBridgeable
>(_ a: T, _ b: U) -> T {
    a
}

@JS
public func exportGenericCombineSecond<
    T: _BridgedSwiftGenericBridgeable,
    U: _BridgedSwiftGenericBridgeable
>(_ a: T, _ b: U) -> U {
    b
}

@JS
public func exportGenericCombineTripleLast<
    T: _BridgedSwiftGenericBridgeable,
    U: _BridgedSwiftGenericBridgeable,
    V: _BridgedSwiftGenericBridgeable
>(_ a: T, _ b: U, _ c: V) -> V {
    c
}

@JS public final class ExportGenericMethodBox {
    @JS public init() {}
    @JS public func echo<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
    @JS
    public func combine<
        T: _BridgedSwiftGenericBridgeable,
        U: _BridgedSwiftGenericBridgeable
    >(_ a: T, _ b: U) -> U {
        b
    }
    @JS public static func wrapArray<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> [T] {
        [value]
    }
}

@JS public struct ExportGenericMethodPair {
    @JS public init() {}
    @JS public func first<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
    @JS public func maybe<T: _BridgedSwiftGenericBridgeable>(_ value: T, present: Bool) -> T? {
        present ? value : nil
    }
    @JS public func dict<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> [String: T] {
        ["value": value]
    }
    @JS public static func wrap<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> [T] {
        [value]
    }
}

@JS public enum ExportGenericMethodFactory {
    case primary
    @JS public static func one<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
}

@JS public enum ExportGenericMethodNamespace {
    @JS public static func make<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
}

@JS public func lastWrappedPointX() -> Int { _lastWrappedPoint.x }
@JS public func lastWrappedPointY() -> Int { _lastWrappedPoint.y }
@JS public func lastTag() -> Int { _lastTag }

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "runExportGenericTests")
@_extern(c)
func runExportGenericTests() -> Void

final class ExportGenericAPITests: XCTestCase {
    func testExportGenerics() throws {
        runExportGenericTests()
    }
}
