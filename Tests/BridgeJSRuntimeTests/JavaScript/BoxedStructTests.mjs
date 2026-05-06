// @ts-check
import assert from "node:assert";

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
export function runBoxedStructWorks(exports) {
    const a = exports.makeBoxedSummary([1, 2, 3], "alpha");
    assert.deepEqual(a.largeContents, [1, 2, 3]);
    assert.equal(a.label, "alpha");
    assert.equal(a.summarize(), "alpha: count=3 sum=6");

    const b = exports.roundtripBoxedSummary(a);
    assert.deepEqual(b.largeContents, [1, 2, 3]);
    assert.equal(b.label, "alpha");

    const c = exports.makeBoxedSummary([10, 20], "bravo");
    assert.equal(exports.boxedSummaryLabel(c), "bravo");
    c.release();

    const original = exports.makeBoxedSummary([1, 2, 3, 4], "copy-test");
    const copy = original.copy();
    assert.notStrictEqual(copy, original);
    assert.deepEqual(copy.largeContents, original.largeContents);
    assert.equal(copy.label, original.label);

    original.release();
    assert.equal(copy.summarize(), "copy-test: count=4 sum=10");
    copy.release();

    const seed = exports.makeBoxedSummary([7, 8, 9], "chain");
    const next = seed.appendingZero();
    assert.notStrictEqual(next, seed);
    assert.deepEqual(next.largeContents, [7, 8, 9, 0]);
    assert.deepEqual(seed.largeContents, [7, 8, 9]);
    seed.release();
    next.release();

    assert.equal(exports.optionalBoxedSummary(false), null);
    const optional = exports.optionalBoxedSummary(true);
    assert.notEqual(optional, null);
    if (optional) {
        assert.deepEqual(optional.largeContents, [1, 2, 3]);
        const echoed = exports.roundtripOptionalBoxedSummary(optional);
        if (!echoed) { throw new Error("expected echoed value"); }
        assert.deepEqual(echoed.largeContents, [1, 2, 3]);
        echoed.release();
        optional.release();
    }
    assert.equal(exports.roundtripOptionalBoxedSummary(null), null);

    const leak1 = exports.makeLeakCheckBoxed(0);
    const leak2 = leak1.incremented();
    assert.notStrictEqual(leak2, leak1);
    leak1.release();
    leak2.release();

    const consumer = new exports.BoxedStructConsumer();
    const tag = exports.makeBoxedSummary([5, 5, 5], "tagA");
    assert.equal(consumer.formatSummary(tag), "tagA:15");

    const tag2 = exports.makeBoxedSummary([1], "tagB");
    assert.equal(consumer.mergeLabels(tag, tag2), "tagA+tagB");
    consumer.release();

    const inner = new exports.BoxedConsumer("outer");
    assert.equal(inner.describe(tag2), "outer→tagB");
    inner.release();
    tag.release();
    tag2.release();

    const counter = exports.makeMutableCounter(5);
    assert.equal(counter.currentCount(), 5);
    counter.bump();
    assert.equal(counter.currentCount(), 6);
    counter.bump();
    counter.bump();
    assert.equal(counter.currentCount(), 8);
    counter.release();

    const direct = exports.makeDirectMutable(10, "tag");
    assert.equal(direct.count, 10);
    assert.equal(direct.describe(), "tag:10");
    direct.count = 42;
    assert.equal(direct.count, 42);
    assert.equal(direct.describe(), "tag:42");
    assert.equal(direct.label, "tag");
    direct.release();

    const valueOuter = exports.makeValueWithBoxedField([1, 2, 3], "inner", "outer");
    assert.equal(valueOuter.label, "outer");
    assert.equal(valueOuter.payload.label, "inner");
    assert.deepEqual(valueOuter.payload.largeContents, [1, 2, 3]);
    assert.equal(valueOuter.payload.summarize(), "inner: count=3 sum=6");

    const valueRound = exports.roundtripValueWithBoxedField(valueOuter);
    assert.equal(valueRound.label, "outer");
    assert.deepEqual(valueRound.payload.largeContents, [1, 2, 3]);
    // Round-trip allocates a fresh box for the field — distinct JS handle.
    assert.notStrictEqual(valueRound.payload, valueOuter.payload);
    valueOuter.payload.release();
    valueRound.payload.release();

    const optionalPresent = exports.makeValueWithOptionalBoxedField(true, "present");
    if (!optionalPresent.payload) { throw new Error("expected payload"); }
    assert.equal(optionalPresent.tag, "present");
    assert.deepEqual(optionalPresent.payload.largeContents, [9, 9]);
    const optionalEcho = exports.roundtripValueWithOptionalBoxedField(optionalPresent);
    if (!optionalEcho.payload) { throw new Error("expected echoed payload"); }
    assert.deepEqual(optionalEcho.payload.largeContents, [9, 9]);
    optionalPresent.payload.release();
    optionalEcho.payload.release();

    const optionalAbsent = exports.makeValueWithOptionalBoxedField(false, "absent");
    assert.equal(optionalAbsent.payload, null);
    assert.equal(optionalAbsent.tag, "absent");
    const absentEcho = exports.roundtripValueWithOptionalBoxedField(optionalAbsent);
    assert.equal(absentEcho.payload, null);
    assert.equal(absentEcho.tag, "absent");

    const inputItems = exports.makeBoxedArray(3);
    assert.equal(inputItems.length, 3);
    assert.equal(inputItems[0].label, "item0");
    assert.equal(inputItems[1].label, "item1");
    assert.deepEqual(inputItems[2].largeContents, [2]);

    const transformedItems = exports.consumeBoxedArray(inputItems);
    assert.equal(transformedItems.length, 3);
    assert.equal(transformedItems[0].label, "item0!");
    assert.deepEqual(transformedItems[0].largeContents, [0, 0]);
    assert.equal(transformedItems[2].label, "item2!");
    assert.notStrictEqual(transformedItems[0], inputItems[0]);
    inputItems.forEach((item) => item.release());
    transformedItems.forEach((item) => item.release());

    const dictInput = {
        alpha: exports.makeBoxedSummary([1, 2], "one"),
        beta: exports.makeBoxedSummary([3, 4], "two"),
    };
    const dictResult = exports.consumeBoxedDictionary(dictInput);
    assert.equal(Object.keys(dictResult).sort().join(","), "alpha,beta");
    assert.equal(dictResult.alpha.label, "alpha:one");
    assert.equal(dictResult.beta.label, "beta:two");
    assert.deepEqual(dictResult.alpha.largeContents, [1, 2]);
    Object.values(dictInput).forEach((b) => b.release());
    Object.values(dictResult).forEach((b) => b.release());

    assert.equal(exports.optionalBoxedArray(false), null);
    const optionalArr = exports.optionalBoxedArray(true);
    if (!optionalArr) { throw new Error("expected non-null array"); }
    assert.equal(optionalArr.length, 2);
    assert.equal(optionalArr[0].label, "a");
    assert.equal(optionalArr[1].label, "b");
    optionalArr.forEach((b) => b.release());

    const mixed = exports.arrayOfOptionalBoxed(true);
    assert.equal(mixed.length, 3);
    if (!mixed[0] || !mixed[2]) { throw new Error("expected entries 0 and 2 to be present"); }
    assert.equal(mixed[0].label, "x");
    assert.equal(mixed[1], null);
    assert.equal(mixed[2].label, "y");
    mixed[0].release();
    mixed[2].release();
    assert.deepEqual(exports.arrayOfOptionalBoxed(false), []);

    // Lifetime: a class held only by a boxed struct's field is deinit'd when the
    // last box referencing it is released.
    exports.resetTrackedDeinitCount();
    assert.equal(exports.getTrackedDeinitCount(), 0);

    const lifetimeBox = exports.makeBoxWithFreshTracked(42, "owned");
    assert.equal(lifetimeBox.describeTracked(), "owned:42");
    assert.equal(exports.getTrackedDeinitCount(), 0);

    const echoed = exports.roundtripBoxWithTrackedClass(lifetimeBox);
    assert.notStrictEqual(echoed, lifetimeBox);
    assert.equal(echoed.describeTracked(), "owned:42");
    assert.equal(exports.getTrackedDeinitCount(), 0);

    lifetimeBox.release();
    assert.equal(exports.getTrackedDeinitCount(), 0);
    assert.equal(echoed.describeTracked(), "owned:42");

    echoed.release();
    assert.equal(exports.getTrackedDeinitCount(), 1);

    // Lifetime: class outlives its box when JS holds a separate handle.
    exports.resetTrackedDeinitCount();
    const survivingBox = exports.makeBoxWithFreshTracked(7, "survivor");
    const tracked = survivingBox.tracked;
    assert.equal(tracked.getId(), 7);

    survivingBox.release();
    assert.equal(exports.getTrackedDeinitCount(), 0);
    assert.equal(tracked.getId(), 7);

    tracked.release();
    assert.equal(exports.getTrackedDeinitCount(), 1);
}
