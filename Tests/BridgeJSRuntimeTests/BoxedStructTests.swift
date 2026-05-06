import XCTest
import JavaScriptKit

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "runBoxedStructWorks")
@_extern(c)
func runBoxedStructWorks() -> Void

@JS(structStyle: .reference) struct BoxedSummary {
    @JS let largeContents: [Int]
    @JS let label: String

    @JS init(largeContents: [Int], label: String) {
        self.largeContents = largeContents
        self.label = label
    }

    @JS func summarize() -> String {
        "\(label): count=\(largeContents.count) sum=\(largeContents.reduce(0, +))"
    }

    @JS func appendingZero() -> BoxedSummary {
        BoxedSummary(largeContents: largeContents + [0], label: label)
    }
}

@JS(structStyle: .reference) struct LeakCheckBoxed {
    let id: Int

    @JS init(id: Int) { self.id = id }

    @JS func incremented() -> LeakCheckBoxed {
        LeakCheckBoxed(id: id + 1)
    }
}

@JS func makeBoxedSummary(_ values: [Int], _ label: String) -> BoxedSummary {
    BoxedSummary(largeContents: values, label: label)
}

@JS struct ValueWithBoxedField {
    let payload: BoxedSummary
    let label: String

    @JS init(payload: BoxedSummary, label: String) {
        self.payload = payload
        self.label = label
    }
}

@JS func makeValueWithBoxedField(_ values: [Int], _ payloadLabel: String, _ outerLabel: String) -> ValueWithBoxedField {
    ValueWithBoxedField(
        payload: BoxedSummary(largeContents: values, label: payloadLabel),
        label: outerLabel
    )
}

@JS func roundtripValueWithBoxedField(_ value: ValueWithBoxedField) -> ValueWithBoxedField { value }

@JS struct ValueWithOptionalBoxedField {
    let payload: BoxedSummary?
    let tag: String

    @JS init(payload: BoxedSummary?, tag: String) {
        self.payload = payload
        self.tag = tag
    }
}

@JS func makeValueWithOptionalBoxedField(_ flag: Bool, _ tag: String) -> ValueWithOptionalBoxedField {
    ValueWithOptionalBoxedField(
        payload: flag ? BoxedSummary(largeContents: [9, 9], label: "inner") : nil,
        tag: tag
    )
}

@JS func roundtripValueWithOptionalBoxedField(
    _ value: ValueWithOptionalBoxedField
) -> ValueWithOptionalBoxedField { value }

@JS func consumeBoxedArray(_ items: [BoxedSummary]) -> [BoxedSummary] {
    items.map { BoxedSummary(largeContents: $0.largeContents + [0], label: $0.label + "!") }
}

@JS func makeBoxedArray(_ count: Int) -> [BoxedSummary] {
    (0..<count).map { BoxedSummary(largeContents: [$0], label: "item\($0)") }
}

@JS func consumeBoxedDictionary(_ items: [String: BoxedSummary]) -> [String: BoxedSummary] {
    var result: [String: BoxedSummary] = [:]
    for (key, value) in items {
        result[key] = BoxedSummary(largeContents: value.largeContents, label: key + ":" + value.label)
    }
    return result
}

@JS func optionalBoxedArray(_ flag: Bool) -> [BoxedSummary]? {
    flag ? [BoxedSummary(largeContents: [1], label: "a"), BoxedSummary(largeContents: [2], label: "b")] : nil
}

@JS func arrayOfOptionalBoxed(_ flag: Bool) -> [BoxedSummary?] {
    flag
        ? [BoxedSummary(largeContents: [1], label: "x"), nil, BoxedSummary(largeContents: [2], label: "y")]
        : []
}

@JS func roundtripBoxedSummary(_ value: BoxedSummary) -> BoxedSummary { value }

@JS func boxedSummaryLabel(_ value: BoxedSummary) -> String { value.label }

@JS func optionalBoxedSummary(_ flag: Bool) -> BoxedSummary? {
    flag ? BoxedSummary(largeContents: [1, 2, 3], label: "present") : nil
}

@JS func roundtripOptionalBoxedSummary(_ value: BoxedSummary?) -> BoxedSummary? {
    value
}

@JS func makeLeakCheckBoxed(_ id: Int) -> LeakCheckBoxed { LeakCheckBoxed(id: id) }

@JS(structStyle: .reference) struct MutableCounter {
    let count: Int

    @JS init(count: Int) { self.count = count }

    @JS mutating func bump() {
        self = MutableCounter(count: count + 1)
    }

    @JS func currentCount() -> Int { count }
}

@JS func makeMutableCounter(_ initial: Int) -> MutableCounter {
    MutableCounter(count: initial)
}

@JS(structStyle: .reference) struct DirectMutable {
    @JS var count: Int
    @JS let label: String

    @JS init(count: Int, label: String) {
        self.count = count
        self.label = label
    }

    @JS func describe() -> String {
        "\(label):\(count)"
    }
}

@JS func makeDirectMutable(_ count: Int, _ label: String) -> DirectMutable {
    DirectMutable(count: count, label: label)
}

@JS class BoxedStructConsumer {
    @JS init() {}

    @JS func formatSummary(_ value: BoxedSummary) -> String {
        "\(value.label):\(value.largeContents.reduce(0, +))"
    }

    @JS func mergeLabels(_ a: BoxedSummary, _ b: BoxedSummary) -> String {
        "\(a.label)+\(b.label)"
    }
}

@JS(structStyle: .reference) struct BoxedConsumer {
    let tag: String

    @JS init(tag: String) { self.tag = tag }

    @JS func describe(_ other: BoxedSummary) -> String {
        "\(tag)→\(other.label)"
    }
}

@JS class TrackedThing {
    nonisolated(unsafe) static var deinitCount = 0
    let id: Int

    @JS init(id: Int) {
        self.id = id
    }

    @JS func getId() -> Int { id }

    deinit {
        TrackedThing.deinitCount += 1
    }
}

@JS func getTrackedDeinitCount() -> Int { TrackedThing.deinitCount }

@JS func resetTrackedDeinitCount() { TrackedThing.deinitCount = 0 }

@JS(structStyle: .reference) struct BoxWithTrackedClass {
    @JS let tracked: TrackedThing
    let label: String

    @JS init(tracked: TrackedThing, label: String) {
        self.tracked = tracked
        self.label = label
    }

    @JS func describeTracked() -> String {
        "\(label):\(tracked.getId())"
    }
}

@JS func makeBoxWithFreshTracked(_ id: Int, _ label: String) -> BoxWithTrackedClass {
    BoxWithTrackedClass(tracked: TrackedThing(id: id), label: label)
}

@JS func roundtripBoxWithTrackedClass(_ box: BoxWithTrackedClass) -> BoxWithTrackedClass { box }

final class BoxedStructTests: XCTestCase {
    func testBoxedStructEndToEnd() {
        runBoxedStructWorks()
    }
}
