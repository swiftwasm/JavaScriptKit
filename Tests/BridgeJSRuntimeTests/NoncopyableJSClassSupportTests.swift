import Testing
import JavaScriptKit

@JSClass struct NoncopyableObject: ~Copyable {
    @JSFunction init(_ start: Int) throws(JSException)
    @JSFunction static func create(_ start: Int) throws(JSException) -> NoncopyableObject
    @JSFunction func value() throws(JSException) -> Int
}

@JSClass struct NoncopyableObjectView: ~Copyable {
    @JSFunction func value() throws(JSException) -> Int
}

@JSClass struct NoncopyableObjectRoundtrip: ~Copyable {
    @JSFunction init() throws(JSException)
    @JSFunction func take(_ object: borrowing NoncopyableObject) throws(JSException) -> Int
    @JSFunction func make(_ start: Int) throws(JSException) -> NoncopyableObject
    @JSGetterFunction func child() throws(JSException) -> NoncopyableObject
    @JSSetter func setChild(_ object: borrowing NoncopyableObject) throws(JSException)
    @JSFunction func adopt(_ object: consuming NoncopyableObject) throws(JSException) -> Int
    @JSFunction func takeCopyable(_ copyable: CopyableObjectRoundtrip) throws(JSException) -> Int
    @JSFunction func makeCopyable(_ start: Int) throws(JSException) -> CopyableObjectRoundtrip
    @JSFunction func failTake(_ object: borrowing NoncopyableObject) throws(JSException) -> Int
    @JSFunction func failMake() throws(JSException) -> NoncopyableObject
}

@JSClass struct CopyableObjectRoundtrip {
    @JSFunction func value() throws(JSException) -> Int
    @JSFunction func take(_ object: borrowing NoncopyableObject) throws(JSException) -> Int
    @JSFunction func make(_ start: Int) throws(JSException) -> NoncopyableObject
}

@JSClass struct NoncopyableSource: ~Copyable {
    @JSFunction init() throws(JSException)
    @JSFunction func forEachObject(
        _ count: Int,
        _ body: JSTypedClosure<(borrowing NoncopyableObject) -> Void>
    ) throws(JSException)
    @JSFunction func forEachObjectEscaping(
        _ count: Int,
        _ body: @escaping (borrowing NoncopyableObject) -> Void
    ) throws(JSException)
    @JSFunction func forEachCopyableEscaping(
        _ count: Int,
        _ body: @escaping (CopyableObjectRoundtrip) -> Void
    ) throws(JSException)
    @JSFunction func load(_ start: Int) async throws(JSException) -> NoncopyableObject
    @JSFunction func loadCopyable(_ start: Int) async throws(JSException) -> CopyableObjectRoundtrip
    @JSFunction func loadFail() async throws(JSException) -> NoncopyableObject
    @JSFunction func use(_ object: borrowing NoncopyableObject) async throws(JSException) -> Int
    @JSFunction func referencesToCreated() throws(JSException) -> Int
    @JSFunction func referencesTo(_ object: borrowing NoncopyableObject) throws(JSException) -> Int
    @JSFunction func takeOptional(_ object: borrowing NoncopyableObject?) throws(JSException) -> Int
    @JSFunction func takeOptionalCopyable(_ copyable: CopyableObjectRoundtrip?) throws(JSException) -> Int
    @JSFunction func findOptional(_ start: Int) throws(JSException) -> NoncopyableObject?
    @JSFunction func findOptionalCopyable(_ start: Int) throws(JSException) -> CopyableObjectRoundtrip?
    @JSFunction func forEachOptional(
        _ count: Int,
        _ body: JSTypedClosure<(borrowing NoncopyableObject?) -> Void>
    ) throws(JSException)
    @JSFunction func loadOptional(_ start: Int) async throws(JSException) -> NoncopyableObject?
    @JSGetterFunction func optionalChild() throws(JSException) -> NoncopyableObject?
    @JSSetter func setOptionalChild(_ object: borrowing NoncopyableObject?) throws(JSException)
    @JSFunction func raw(_ start: Int) throws(JSException) -> JSUniqueRef
    @JSFunction func rawValue(_ ref: borrowing JSUniqueRef) throws(JSException) -> Int
    @JSFunction func maybeRaw(_ start: Int) throws(JSException) -> JSUniqueRef?
    @JSFunction func rawObject(_ start: Int) throws(JSException) -> JSObject
    #if compiler(>=6.4)
    @JSFunction func takeAll(_ objects: borrowing UniqueArray<NoncopyableObject>) throws(JSException) -> Int
    @JSFunction func makeAll(_ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject>
    @JSFunction func takeAllOptional(_ objects: borrowing UniqueArray<NoncopyableObject?>) throws(JSException) -> Int
    @JSFunction func makeAllOptional(_ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject?>
    @JSFunction func makeGrid(_ count: Int) throws(JSException) -> UniqueArray<UniqueArray<NoncopyableObject>>
    @JSFunction func loadAll(_ count: Int) async throws(JSException) -> UniqueArray<NoncopyableObject>
    @JSGetterFunction func children() throws(JSException) -> UniqueArray<NoncopyableObject>
    @JSSetter func setChildren(_ objects: borrowing UniqueArray<NoncopyableObject>) throws(JSException)
    @JSFunction func forEachBatch(
        _ count: Int,
        _ body: JSTypedClosure<(borrowing UniqueArray<NoncopyableObject>) -> Void>
    ) throws(JSException)
    @JSFunction func takeMaybe(_ objects: borrowing UniqueArray<NoncopyableObject>?) throws(JSException) -> Int
    @JSFunction func makeMaybe(_ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject>?
    @JSFunction func takeRows(
        _ rows: borrowing UniqueArray<UniqueArray<NoncopyableObject>?>
    ) throws(JSException) -> Int
    @JSFunction func makeRows(_ count: Int) throws(JSException) -> UniqueArray<UniqueArray<NoncopyableObject>?>
    @JSFunction func loadMaybe(_ count: Int) async throws(JSException) -> UniqueArray<NoncopyableObject>?
    #endif
}

@JSFunction func noncopyableMakeObject(_ start: Int) throws(JSException) -> NoncopyableObject
@JSFunction func noncopyableUseObject(_ object: borrowing NoncopyableObject) throws(JSException) -> Int
@JSGetterFunction(jsName: "noncopyableSharedObject", from: .global)
func noncopyableSharedObject() throws(JSException) -> NoncopyableObject

@JSClass struct NoncopyableJSClassSupportImports {
    @JSFunction static func liveReferenceCount() throws(JSException) -> Int
    @JSFunction static func retainByRefCount() throws(JSException) -> Int
    @JSFunction static func runNoncopyableExportedPathTests() async throws(JSException)
    #if compiler(>=6.4)
    @JSFunction static func runNoncopyableUniqueArrayExportedPathTests() async throws(JSException)
    #endif
}

@JS protocol NoncopyableObjectVisitor {
    func visit(_ object: borrowing NoncopyableObject) -> Int
    #if compiler(>=6.4)
    func visitAll(_ objects: borrowing UniqueArray<NoncopyableObject>) -> Int
    func makeAll(_ count: Int) -> UniqueArray<NoncopyableObject>
    #endif
}

@JS protocol NoncopyableOptionalObjectVisitor {
    func visit(_ object: borrowing NoncopyableObject?) -> Int
}

@JS class NoncopyableObjectBox {
    @JS var object: NoncopyableObject
    @JS init(_ start: Int) { object = try! NoncopyableObject(start) }
    @JS func value() -> Int { (try? object.value()) ?? -1 }
    @JS func take(_ other: borrowing NoncopyableObject) -> Int { (try? other.value()) ?? -1 }
    @JS var made: NoncopyableObject { try! NoncopyableObject(9) }
    @JS nonisolated(unsafe) static var shared: NoncopyableObject = try! NoncopyableObject(7)
    @JS static var staticMade: NoncopyableObject { try! NoncopyableObject(8) }
    @JS var optionalObject: NoncopyableObject? = nil
    #if compiler(>=6.4)
    @JS var objects: UniqueArray<NoncopyableObject> = UniqueArray()
    @JS var maybeObjects: UniqueArray<NoncopyableObject>? = nil
    #endif
}

@JS func noncopyableTake(_ object: borrowing NoncopyableObject) -> Int {
    (try? object.value()) ?? -1
}

@JS func noncopyableConsume(_ object: consuming NoncopyableObject) -> Int {
    (try? object.value()) ?? -1
}

@JS func noncopyableMake(_ start: Int) -> NoncopyableObject {
    try! NoncopyableObject(start)
}

@JS func noncopyableLoad(_ start: Int) async -> NoncopyableObject {
    try! NoncopyableObject(start)
}

@JS func noncopyableCallWith(_ start: Int, _ body: (borrowing NoncopyableObject) -> Int) -> Int {
    let object = try! NoncopyableObject(start)
    return body(object)
}

@JS func noncopyableCallWithOptional(_ start: Int, _ body: (borrowing NoncopyableObject?) -> Int) -> Int {
    let object: NoncopyableObject? = start < 0 ? nil : try! NoncopyableObject(start)
    return body(object)
}

@JS func noncopyableTakeOptional(_ object: borrowing NoncopyableObject?) -> Int {
    switch object {
    case .some(let object): (try? object.value()) ?? -1
    case .none: -2
    }
}

@JS func copyableTakeOptional(_ copyable: CopyableObjectRoundtrip?) -> Int {
    guard let copyable else { return -2 }
    return (try? copyable.value()) ?? -1
}

@JS func noncopyableFindOptional(_ start: Int) -> NoncopyableObject? {
    start < 0 ? nil : try! NoncopyableObject(start)
}

@JS func noncopyableVisit(_ visitor: any NoncopyableObjectVisitor, _ start: Int) -> Int {
    let object = try! NoncopyableObject(start)
    return visitor.visit(object)
}

@JS func noncopyableVisitOptional(_ visitor: any NoncopyableOptionalObjectVisitor, _ start: Int) -> Int {
    let object: NoncopyableObject? = start < 0 ? nil : try! NoncopyableObject(start)
    return visitor.visit(object)
}

@JS func noncopyableMakeReader() -> JSTypedClosure<(borrowing NoncopyableObject) -> Int> {
    JSTypedClosure { object in (try? object.value()) ?? -1 }
}

@JS func copyableMakeReader() -> JSTypedClosure<(CopyableObjectRoundtrip) -> Int> {
    JSTypedClosure { copyable in (try? copyable.value()) ?? -1 }
}

@JS func makeIntReader() -> JSTypedClosure<(Int) -> Int> {
    JSTypedClosure { $0 }
}

#if compiler(>=6.4)
@JS func noncopyableTakeAll(_ objects: borrowing UniqueArray<NoncopyableObject>) -> [Int] {
    values(of: objects)
}

@JS func noncopyableMakeAll(_ count: Int) -> UniqueArray<NoncopyableObject> {
    try! makeObjects(count)
}

@JS func noncopyableLoadAll(_ count: Int) async -> UniqueArray<NoncopyableObject> {
    try! makeObjects(count)
}

@JS func noncopyablePassAll(_ objects: consuming UniqueArray<NoncopyableObject>) -> UniqueArray<NoncopyableObject> {
    objects
}

@JS func noncopyableTakeAllOptional(_ objects: borrowing UniqueArray<NoncopyableObject?>) -> [Int] {
    values(of: objects)
}

@JS func noncopyableTakeMaybe(_ objects: borrowing UniqueArray<NoncopyableObject>?) -> [Int]? {
    maybeValues(of: objects)
}

@JS func noncopyableMakeMaybe(_ count: Int) -> UniqueArray<NoncopyableObject>? {
    count < 0 ? nil : try! makeObjects(count)
}

@JS func noncopyableVisitAll(
    _ visitor: any NoncopyableObjectVisitor,
    _ objects: borrowing UniqueArray<NoncopyableObject>
) -> Int {
    visitor.visitAll(objects)
}

@JS func noncopyableVisitorMakeAll(
    _ visitor: any NoncopyableObjectVisitor,
    _ count: Int
) -> UniqueArray<NoncopyableObject> {
    visitor.makeAll(count)
}

private func makeObjects(_ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject> {
    var objects = UniqueArray<NoncopyableObject>(capacity: count)
    for i in 0..<count {
        objects.append(try NoncopyableObject(i))
    }
    return objects
}

private func values(of objects: borrowing UniqueArray<NoncopyableObject>) -> [Int] {
    objects.indices.map { (try? objects[$0].value()) ?? -1000 }
}

private func values(of objects: borrowing UniqueArray<NoncopyableObject?>) -> [Int] {
    objects.indices.map { index in
        switch objects[index] {
        case .some(let object): (try? object.value()) ?? -1000
        case .none: -2
        }
    }
}

private func maybeValues(of objects: borrowing UniqueArray<NoncopyableObject>?) -> [Int]? {
    switch objects {
    case .some(let objects): values(of: objects)
    case .none: nil
    }
}

/// The value `NoncopyableSource.takeAll` returns for objects with the values `0..<count`, which depends on the order.
private func weightedSum(_ count: Int) -> Int {
    (0..<count).reduce(0) { $0 + $1 * ($1 + 1) }
}
#endif

private func optionalObject(_ i: Int) throws(JSException) -> NoncopyableObject? {
    if i % 2 == 0 {
        return try NoncopyableObject(i)
    }
    return nil
}

/// The value `NoncopyableSource.takeOptional` returns for `optionalObject(i)`.
private func optionalValue(_ i: Int) -> Int {
    i % 2 == 0 ? i : -2
}

private final class Total {
    var value = 0
}

@Suite struct NoncopyableJSClassSupportTests {
    private func referencesKept(_ body: (Int) throws -> (Int, Int)) throws -> Int {
        let before = try NoncopyableJSClassSupportImports.liveReferenceCount()
        for i in 0..<100 {
            let (actual, expected) = try body(i)
            #expect(actual == expected)
        }
        return try NoncopyableJSClassSupportImports.liveReferenceCount() - before
    }

    private func retainsMade(_ body: (Int) throws -> (Int, Int)) throws -> Int {
        let before = try NoncopyableJSClassSupportImports.retainByRefCount()
        for i in 0..<100 {
            let (actual, expected) = try body(i)
            #expect(actual == expected)
        }
        return try NoncopyableJSClassSupportImports.retainByRefCount() - before
    }

    @Test func importedPositionsKeepNoReferences() throws {
        let roundtrip = try NoncopyableObjectRoundtrip()
        let copyable = try roundtrip.makeCopyable(3)
        let object = try roundtrip.make(1)
        var kept: [String: Int] = [:]
        kept["borrowing parameter"] = try referencesKept { _ in (try roundtrip.take(object), 1) }
        kept["return"] = try referencesKept { i in (try roundtrip.make(i).value(), i) }
        kept["global function return"] = try referencesKept { i in (try noncopyableMakeObject(i).value(), i) }
        kept["global function parameter"] = try referencesKept { _ in (try noncopyableUseObject(object), 1) }
        kept["init"] = try referencesKept { i in (try NoncopyableObject(i).value(), i) }
        kept["static method"] = try referencesKept { i in (try NoncopyableObject.create(i).value(), i) }
        kept["getter function"] = try referencesKept { _ in (try roundtrip.child().value(), 42) }
        kept["setter"] = try referencesKept { _ in
            try roundtrip.setChild(object)
            return (0, 0)
        }
        kept["consuming parameter"] = try referencesKept { i in (try roundtrip.adopt(try roundtrip.make(i)), i) }
        kept["copyable class, noncopyable parameter"] = try referencesKept { _ in (try copyable.take(object), 1) }
        kept["copyable class, noncopyable return"] = try referencesKept { i in (try copyable.make(i).value(), i) }
        kept["noncopyable class, copyable parameter"] = try referencesKept { _ in
            (try roundtrip.takeCopyable(copyable), 3)
        }
        kept["noncopyable class, copyable return"] = try referencesKept { i in
            (try roundtrip.makeCopyable(i).value(), i)
        }
        kept["global getter function"] = try referencesKept { _ in (try noncopyableSharedObject().value(), 7) }
        kept["withView"] = try referencesKept { _ in
            let value = try object.withView(as: NoncopyableObjectView.self) {
                (view: borrowing NoncopyableObjectView) throws(JSException) -> Int in try view.value()
            }
            return (value, 1)
        }
        kept["throwing call, borrowing parameter"] = try referencesKept { _ in
            do {
                return (try roundtrip.failTake(object), -1)
            } catch {
                return (0, 0)
            }
        }
        kept["throwing call, noncopyable return"] = try referencesKept { _ in
            do {
                return (try roundtrip.failMake().value(), -1)
            } catch {
                return (0, 0)
            }
        }
        #expect(kept.filter { $0.value != 0 } == [:])
    }

    @Test func importedClosureParametersKeepNoReferences() throws {
        let source = try NoncopyableSource()
        let total = Total()
        var kept: [String: Int] = [:]

        let typed = JSTypedClosure<(borrowing NoncopyableObject) -> Void> { object in
            total.value += (try? object.value()) ?? -1000
        }
        kept["typed closure parameter"] = try referencesKept { _ in
            try source.forEachObject(3, typed)
            return (0, 0)
        }
        typed.release()
        #expect(total.value == 300)

        total.value = 0
        kept["escaping closure parameter"] = try referencesKept { _ in
            try source.forEachObjectEscaping(3) { object in total.value += (try? object.value()) ?? -1000 }
            return (0, 0)
        }
        #expect(total.value == 300)

        total.value = 0
        kept["escaping closure parameter, copyable control"] = try referencesKept { _ in
            try source.forEachCopyableEscaping(3) { copyable in total.value += (try? copyable.value()) ?? -1000 }
            return (0, 0)
        }
        #expect(total.value == 300)

        #expect(kept.filter { $0.value != 0 } == [:])
    }

    /// Other tests change the global reference count while this one awaits.
    @Test func importedAsyncPositionsKeepNoReferences() async throws {
        let source = try NoncopyableSource()
        let object = try NoncopyableObject(1)
        var kept: [String: Int] = [:]

        for i in 0..<100 {
            #expect(try await source.load(i).value() == i)
        }
        kept["async return"] = try source.referencesToCreated()

        for i in 0..<100 {
            #expect(try await source.loadCopyable(i).value() == i)
        }
        kept["async return, copyable control"] = try source.referencesToCreated()

        for _ in 0..<100 {
            await #expect(throws: JSException.self) { _ = try await source.loadFail() }
        }
        kept["async return, rejected"] = try source.referencesToCreated()

        let before = try source.referencesTo(object)
        for _ in 0..<100 {
            #expect(try await source.use(object) == 1)
        }
        kept["async borrowing parameter"] = try source.referencesTo(object) - before
        kept["async borrowing parameter, resolve and reject"] = try source.referencesToCreated()

        for i in 0..<100 {
            let start = i % 2 == 0 ? i : -1
            let value: Int? =
                switch try await source.loadOptional(start) {
                case .some(let object): try object.value()
                case .none: nil
                }
            #expect(value == (start < 0 ? nil : i))
        }
        kept["async optional return"] = try source.referencesToCreated()

        #expect(kept.filter { $0.value != 0 } == [:])
    }

    @Test func importedOptionalPositionsKeepNoReferences() throws {
        let source = try NoncopyableSource()
        var kept: [String: Int] = [:]

        kept["optional parameter"] = try referencesKept { i in
            (try source.takeOptional(try optionalObject(i)), optionalValue(i))
        }
        kept["optional return"] = try referencesKept { i in
            switch try source.findOptional(i % 2 == 0 ? i : -1) {
            case .some(let object): (try object.value(), optionalValue(i))
            case .none: (-2, optionalValue(i))
            }
        }
        kept["optional return passed back"] = try referencesKept { i in
            let object = try source.findOptional(i % 2 == 0 ? i : -1)
            return (try source.takeOptional(object), optionalValue(i))
        }
        kept["optional return passed back, copyable control"] = try referencesKept { i in
            let copyable = try source.findOptionalCopyable(i % 2 == 0 ? i : -1)
            return (try source.takeOptionalCopyable(copyable), optionalValue(i))
        }

        let total = Total()
        let typed = JSTypedClosure<(borrowing NoncopyableObject?) -> Void> { object in
            switch object {
            case .some(let object): total.value += (try? object.value()) ?? -1000
            case .none: total.value += 100
            }
        }
        kept["typed closure optional parameter"] = try referencesKept { _ in
            try source.forEachOptional(3, typed)
            return (0, 0)
        }
        typed.release()
        #expect(total.value == 100 * (0 + 100 + 2))

        kept["optional property getter and setter"] = try referencesKept { i in
            try source.setOptionalChild(try optionalObject(i))
            switch try source.optionalChild() {
            case .some(let child): return (try child.value(), optionalValue(i))
            case .none: return (-2, optionalValue(i))
            }
        }

        kept["JSUniqueRef return, parameter and optional return"] = try referencesKept { i in
            let ref = try source.raw(i)
            #expect(try source.rawValue(ref) == i)
            switch try source.maybeRaw(i % 2 == 0 ? i : -1) {
            case .some(let ref): return (try source.rawValue(ref), optionalValue(i))
            case .none: return (-2, optionalValue(i))
            }
        }

        #expect(kept.filter { $0.value != 0 } == [:])
    }

    @Test func conversionsFromJSObjectKeepNoReferences() throws {
        let source = try NoncopyableSource()
        let object = try source.rawObject(5)
        var kept: [String: Int] = [:]
        kept["init(unsafelyWrapping:)"] = try referencesKept { i in
            (try NoncopyableObject(unsafelyWrapping: try source.rawObject(i)).value(), i)
        }
        kept["JSUniqueRef(retaining:) of a kept JSObject"] = try referencesKept { _ in
            (try NoncopyableObject(unsafelyAdopting: JSUniqueRef(retaining: object)).value(), 5)
        }
        #expect(kept.filter { $0.value != 0 } == [:])
    }

    @Test func conversionsTakeOverUnsharedJSObjects() throws {
        let source = try NoncopyableSource()
        let kept = try source.rawObject(5)
        var retains: [String: Int] = [:]
        retains["temporary"] = try retainsMade { i in
            (try NoncopyableObject(unsafelyWrapping: try source.rawObject(i)).value(), i)
        }
        retains["consumed local"] = try retainsMade { i in
            let object = try source.rawObject(i)
            return (try NoncopyableObject(unsafelyWrapping: consume object).value(), i)
        }
        retains["kept JSObject"] = try retainsMade { _ in
            (try NoncopyableObject(unsafelyWrapping: kept).value(), 5)
        }
        #expect(retains == ["temporary": 0, "consumed local": 0, "kept JSObject": 100])
    }

    @Test func exportedPathsKeepNoReferences() async throws {
        try await NoncopyableJSClassSupportImports.runNoncopyableExportedPathTests()
    }

    #if compiler(>=6.4)
    @Test func importedUniqueArrayPositionsKeepNoReferences() throws {
        let source = try NoncopyableSource()
        var kept: [String: Int] = [:]

        kept["parameter"] = try referencesKept { i in
            let objects = try makeObjects(i % 5)
            #expect(values(of: objects) == Array(0..<(i % 5)))
            return (try source.takeAll(objects), weightedSum(i % 5))
        }
        kept["return"] = try referencesKept { i in
            let objects = try source.makeAll(i % 5)
            #expect(values(of: objects) == Array(0..<(i % 5)))
            return (objects.count, i % 5)
        }
        kept["return passed back"] = try referencesKept { i in
            (try source.takeAll(try source.makeAll(i % 5)), weightedSum(i % 5))
        }
        kept["optional elements, return and parameter"] = try referencesKept { i in
            let objects = try source.makeAllOptional(i % 5)
            let values = values(of: objects)
            #expect(values == (0..<(i % 5)).map(optionalValue))
            return (try source.takeAllOptional(objects), values.reduce(0, +))
        }
        kept["nested return"] = try referencesKept { i in
            let grid = try source.makeGrid(i % 4)
            for row in grid.indices {
                #expect(values(of: grid[row]) == Array(0..<row))
            }
            return (grid.count, i % 4)
        }
        kept["optional array, return and parameter"] = try referencesKept { i in
            let count = i % 2 == 0 ? i % 5 : -1
            let objects = try source.makeMaybe(count)
            #expect(maybeValues(of: objects) == (count < 0 ? nil : Array(0..<count)))
            return (try source.takeMaybe(objects), count < 0 ? -2 : weightedSum(count))
        }
        kept["optional array elements, return and parameter"] = try referencesKept { i in
            let rows = try source.makeRows(i % 4)
            #expect(rows.count == i % 4)
            var expected = 0
            for row in rows.indices {
                #expect(maybeValues(of: rows[row]) == (row % 2 == 0 ? Array(0..<row) : nil))
                expected += (row % 2 == 0 ? weightedSum(row) : -2) * (row + 1)
            }
            return (try source.takeRows(rows), expected)
        }
        kept["getter function and setter"] = try referencesKept { i in
            try source.setChildren(try makeObjects(i % 5))
            return (values(of: try source.children()).count, i % 5)
        }
        try source.setChildren(UniqueArray())

        let total = Total()
        let batch = JSTypedClosure<(borrowing UniqueArray<NoncopyableObject>) -> Void> { objects in
            total.value += values(of: objects).reduce(0, +)
        }
        kept["typed closure parameter"] = try referencesKept { _ in
            try source.forEachBatch(4, batch)
            return (0, 0)
        }
        batch.release()
        #expect(total.value == 100 * (0 + 0 + 1 + 0 + 1 + 2))

        #expect(kept.filter { $0.value != 0 } == [:])
    }

    /// Other tests change the global reference count while this one awaits.
    @Test func importedAsyncUniqueArrayPositionsKeepNoReferences() async throws {
        let source = try NoncopyableSource()
        var kept: [String: Int] = [:]

        for i in 0..<100 {
            let objects = try await source.loadAll(i % 4)
            #expect(values(of: objects) == Array(0..<(i % 4)))
        }
        kept["async UniqueArray return"] = try source.referencesToCreated()

        for i in 0..<100 {
            let count = i % 2 == 0 ? i % 4 : -1
            let objects = try await source.loadMaybe(count)
            #expect(maybeValues(of: objects) == (count < 0 ? nil : Array(0..<count)))
        }
        kept["async optional UniqueArray return"] = try source.referencesToCreated()

        #expect(kept.filter { $0.value != 0 } == [:])
    }

    @Test func exportedUniqueArrayPathsKeepNoReferences() async throws {
        try await NoncopyableJSClassSupportImports.runNoncopyableUniqueArrayExportedPathTests()
    }
    #endif
}
