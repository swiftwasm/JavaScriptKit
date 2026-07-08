@JS struct ExportPoint {
    var x: Int
    var y: Int
}

@JS enum ExportNamespace {
    @JS struct Metadata {
        var label: String
        var count: Int
    }

    @JS enum Level: Int {
        case low = 1
        case high = 9
    }
}

@JS enum ExportMode: String {
    case on
    case off
}

@JS enum ExportColor {
    case red
    case green
}

@JS enum ExportTagged {
    case number(value: Int)
    case text(value: String)
}

@JS final class ExportBox {
    @JS var value: Int
    @JS init(value: Int) {
        self.value = value
    }
    @JS func get() -> Int {
        value
    }
}

@JS public func genericExportIdentity<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
    return value
}

@JS public func genericExportArray<T: _BridgedSwiftGenericBridgeable>(_ values: [T]) -> [T] {
    return values
}

@JS public func genericExportOptional<T: _BridgedSwiftGenericBridgeable>(_ value: T?) -> T? {
    return value
}

@JS public func genericExportDictionary<T: _BridgedSwiftGenericBridgeable>(_ values: [String: T]) -> [String: T] {
    return values
}

@JS public func genericExportEcho<T: _BridgedSwiftGenericBridgeable>(_ value: T, tag: Int) -> T {
    return value
}

@JS public func genericExportStructConcreteLeading<T: _BridgedSwiftGenericBridgeable>(_ v: T, _ p: ExportPoint) -> T {
    return v
}

@JS public func genericExportStructAndScalar<T: _BridgedSwiftGenericBridgeable>(_ p: ExportPoint, tag: Int, _ v: T) -> T
{
    return v
}

@JS public func genericExportPair<T: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) -> T {
    return a
}

@JS public func genericExportCombine<T: _BridgedSwiftGenericBridgeable, U: _BridgedSwiftGenericBridgeable>(
    _ a: T,
    _ b: U
) -> T {
    return a
}

@JS public func genericExportCombineReturnU<T: _BridgedSwiftGenericBridgeable, U: _BridgedSwiftGenericBridgeable>(
    _ a: T,
    _ b: U
) -> U {
    return b
}

@JS
public func genericExportCaseDistinct<
    T: _BridgedSwiftGenericBridgeable,
    t: _BridgedSwiftGenericBridgeable
>(_ a: T, _ b: t) -> T {
    return a
}

@JS final class GenericBox {
    @JS init() {}

    @JS func wrap<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        return value
    }

    @JS func combine<T: _BridgedSwiftGenericBridgeable, t: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: t) -> T {
        return a
    }

    @JS static func makeArray<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> [T] {
        return [value]
    }
}

@JS struct GenericPair {
    @JS init() {}

    @JS func first<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        return value
    }

    @JS func combine<T: _BridgedSwiftGenericBridgeable, t: _BridgedSwiftGenericBridgeable>(_ a: T, _ b: t) -> T {
        return a
    }

    @JS func maybe<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T? {
        return value
    }

    @JS func dict<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> [String: T] {
        return ["value": value]
    }

    @JS static func wrap<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> [T] {
        return [value]
    }
}

@JS enum GenericFactory {
    case primary

    @JS static func one<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        return value
    }
}

@JS enum GenericNamespace {
    @JS static func make<T: _BridgedSwiftGenericBridgeable>(_ value: T) -> T {
        return value
    }
}
