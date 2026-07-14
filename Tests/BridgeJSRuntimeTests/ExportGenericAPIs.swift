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

@JS public func exportGenericIdentity<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T {
    value
}

@JS public func exportGenericEcho<T: BridgedSwiftGenericBridgeable>(_ value: T, tag: Int) -> T {
    value
}

@JS public func exportGenericPickFirst<T: BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) -> T {
    a
}

@JS public func exportGenericPickSecond<T: BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) -> T {
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

@JS public func exportGenericArrayIdentity<T: BridgedSwiftGenericBridgeable>(_ values: [T]) -> [T] {
    values
}

@JS public func exportGenericOptionalIdentity<T: BridgedSwiftGenericBridgeable>(_ value: T?) -> T? {
    value
}

@JS public func exportGenericDictIdentity<T: BridgedSwiftGenericBridgeable>(_ values: [String: T]) -> [String: T] {
    values
}

nonisolated(unsafe) var _lastWrappedPoint = ExportGenericPoint(x: 0, y: 0)
nonisolated(unsafe) var _lastTag = 0

@JS public func exportGenericWrapPointAndTag<T: BridgedSwiftGenericBridgeable>(
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
    T: BridgedSwiftGenericBridgeable,
    U: BridgedSwiftGenericBridgeable
>(_ a: T, _ b: U) -> T {
    a
}

@JS
public func exportGenericCombineSecond<
    T: BridgedSwiftGenericBridgeable,
    U: BridgedSwiftGenericBridgeable
>(_ a: T, _ b: U) -> U {
    b
}

@JS
public func exportGenericCombineTripleLast<
    T: BridgedSwiftGenericBridgeable,
    U: BridgedSwiftGenericBridgeable,
    V: BridgedSwiftGenericBridgeable
>(_ a: T, _ b: U, _ c: V) -> V {
    c
}

@JS public final class ExportGenericMethodBox {
    @JS public init() {}
    @JS public func echo<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
    @JS
    public func combine<
        T: BridgedSwiftGenericBridgeable,
        U: BridgedSwiftGenericBridgeable
    >(_ a: T, _ b: U) -> U {
        b
    }
    @JS public static func wrapArray<T: BridgedSwiftGenericBridgeable>(_ value: T) -> [T] {
        [value]
    }
}

@JS public struct ExportGenericMethodPair {
    @JS public init() {}
    @JS public func first<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
    @JS public func maybe<T: BridgedSwiftGenericBridgeable>(_ value: T, present: Bool) -> T? {
        present ? value : nil
    }
    @JS public func dict<T: BridgedSwiftGenericBridgeable>(_ value: T) -> [String: T] {
        ["value": value]
    }
    @JS public static func wrap<T: BridgedSwiftGenericBridgeable>(_ value: T) -> [T] {
        [value]
    }
}

@JS public enum ExportGenericMethodFactory {
    case primary
    @JS public static func one<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        value
    }
}

@JS public enum ExportGenericMethodNamespace {
    @JS public static func make<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T {
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
