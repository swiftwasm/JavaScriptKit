// @ts-check

import assert from 'node:assert';

export class ArrayElementObject {
    constructor(id) {
        this.id = id;
    }
}

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["ArraySupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsIntArrayLength: function (items) {
            return items.length;
        },
        jsRoundTripIntArray: function (items) {
            return items;
        },
        jsRoundTripNumberArray: function (values) {
            return values;
        },
        jsRoundTripStringArray: function (values) {
            return values;
        },
        jsRoundTripBoolArray: function (values) {
            return values;
        },
        jsRoundTripJSValueArray: (values) => {
            return values;
        },
        jsSumNumberArray: (values) => {
            return values.reduce((a, b) => a + b, 0);
        },
        jsCreateNumberArray: function () {
            return [1, 2, 3, 4, 5];
        },
        jsRoundTripJSObjectArray: (values) => {
            return values;
        },
        jsRoundTripJSClassArray: (values) => {
            return values;
        },
        jsRoundTripOptionalIntArray: (values) => {
            return values;
        },
        jsRoundTripOptionalStringArray: (values) => {
            return values;
        },
        jsRoundTripOptionalBoolArray: (values) => {
            return values;
        },
        jsRoundTripOptionalJSValueArray: (values) => {
            return values;
        },
        jsRoundTripOptionalJSObjectArray: (values) => {
            return values;
        },
        jsRoundTripOptionalJSClassArray: (values) => {
            return values;
        },
        runJsArraySupportTests: () => {
            const exports = importsContext.getExports();
            if (!exports) { throw new Error("No exports!?"); }
            runJsArraySupportTests(exports);
        },
    };
}

/**
 * Array value bridging coverage for BridgeJS runtime tests.
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} rootExports
 */
export function runJsArraySupportTests(rootExports) {
    const exports = rootExports.ArraySupportExports;
    const { Direction, Status, Theme, HttpStatus, Greeter, Utils } = rootExports;

    // Primitive arrays
    assert.deepEqual(exports.roundTripIntArray([1, 2, 3, -10, 2147483647]), [1, 2, 3, -10, 2147483647]);
    assert.deepEqual(exports.roundTripIntArray([]), []);
    assert.deepEqual(exports.roundTripStringArray(["Hello", "World", ""]), ["Hello", "World", ""]);
    const doubles = exports.roundTripDoubleArray([1.5, 0.0, -1.5, Infinity, NaN]);
    assert.equal(doubles[0], 1.5);
    assert(Number.isNaN(doubles[4]));
    assert.deepEqual(exports.roundTripBoolArray([true, false, true]), [true, false, true]);

    // UnsafePointer-family arrays
    const pointerValues = [1, 4, 1024, 65536, 2147483647];
    assert.deepEqual(exports.roundTripUnsafeRawPointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripUnsafeMutableRawPointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripOpaquePointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripUnsafePointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripUnsafeMutablePointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripUnsafeRawPointerArray([]), []);

    // JSValue arrays
    const jsValueArray = [true, 42, "ok", { nested: 1 }, null, undefined, Symbol("s"), BigInt(3)];
    assert.deepEqual(exports.roundTripJSValueArray(jsValueArray), jsValueArray);

    // JSObject arrays
    const jsObj1 = { a: 1, b: "hello" };
    const jsObj2 = { x: [1, 2, 3], y: { nested: true } };
    const jsObjResult = exports.roundTripJSObjectArray([jsObj1, jsObj2]);
    assert.equal(jsObjResult.length, 2);
    assert.equal(jsObjResult[0], jsObj1);
    assert.equal(jsObjResult[1], jsObj2);
    assert.deepEqual(exports.roundTripJSObjectArray([]), []);

    // Enum arrays
    assert.deepEqual(exports.roundTripCaseEnumArray([Direction.North, Direction.South]), [Direction.North, Direction.South]);
    assert.deepEqual(exports.roundTripIntRawValueEnumArray([HttpStatus.Ok, HttpStatus.NotFound]), [HttpStatus.Ok, HttpStatus.NotFound]);
    assert.deepEqual(exports.roundTripStringRawValueEnumArray([Theme.Light, Theme.Dark]), [Theme.Light, Theme.Dark]);

    // Struct arrays
    const points = [
        { x: 1.0, y: 2.0, label: "A", optCount: 10, optFlag: true },
        { x: 3.0, y: 4.0, label: "B", optCount: null, optFlag: null }
    ];
    const pointResult = exports.roundTripStructArray(points);
    assert.equal(pointResult[0].optCount, 10);
    assert.equal(pointResult[1].optCount, null);

    // Class arrays
    const g1 = new Greeter("Alice");
    const g2 = new Greeter("Bob");
    const gResult = exports.roundTripSwiftClassArray([g1, g2]);
    assert.equal(gResult[0].name, "Alice");
    assert.equal(gResult[1].greet(), "Hello, Bob!");
    g1.release(); g2.release();
    gResult.forEach(g => g.release());

    // Namespaced Swift class arrays
    const c1 = rootExports.createConverter();
    const c2 = rootExports.createConverter();
    const converterArray = exports.roundTripNamespacedSwiftClassArray([c1, c2]);
    assert.equal(converterArray.length, 2);
    assert.equal(converterArray[0].toString(10), "10");
    assert.equal(converterArray[1].toString(20), "20");
    c1.release();
    c2.release();
    converterArray.forEach((c) => c.release());

    // Protocol arrays
    /** @type {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').ArrayElementProtocol[]} */
    const protocolArray = [{ value: 1 }];
    const result = exports.roundTripProtocolArray(protocolArray);
    assert.equal(result.length, 1);
    assert.equal(result[0], protocolArray[0]);
    assert.equal(result[0].value, 1);

    // @JSClass struct arrays
    const foo1 = new ArrayElementObject("first");
    const foo2 = new ArrayElementObject("second");
    const jsClassResult = exports.roundTripJSClassArray([foo1, foo2]);
    assert.equal(jsClassResult.length, 2);
    assert.equal(jsClassResult[0].id, foo1.id);
    assert.equal(jsClassResult[1].id, foo2.id);

    // Arrays of optional elements
    assert.deepEqual(exports.roundTripOptionalIntArray([1, null, 3]), [1, null, 3]);
    assert.deepEqual(exports.roundTripOptionalStringArray(["a", null, "b"]), ["a", null, "b"]);
    const optJsResult = exports.roundTripOptionalJSObjectArray([jsObj1, null, jsObj2]);
    assert.equal(optJsResult.length, 3);
    assert.equal(optJsResult[0], jsObj1);
    assert.equal(optJsResult[1], null);
    assert.equal(optJsResult[2], jsObj2);
    const optPoint = { x: 1.0, y: 2.0, label: "", optCount: null, optFlag: null };
    const optPoints = exports.roundTripOptionalStructArray([optPoint, null]);
    assert.deepEqual(optPoints[0], optPoint);
    assert.equal(optPoints[1], null);
    assert.deepEqual(exports.roundTripOptionalCaseEnumArray([Direction.North, null]), [Direction.North, null]);
    assert.deepEqual(exports.roundTripOptionalIntRawValueEnumArray([HttpStatus.Ok, null]), [HttpStatus.Ok, null]);
    assert.deepEqual(exports.roundTripOptionalJSClassArray([]), []);
    const optJsClassResult = exports.roundTripOptionalJSClassArray([foo1, null, foo2]);
    assert.equal(optJsClassResult.length, 3);
    assert.equal(optJsClassResult[0]?.id, foo1.id);
    assert.equal(optJsClassResult[1], null);
    assert.equal(optJsClassResult[2]?.id, foo2.id);

    // Nested arrays
    assert.deepEqual(exports.roundTripNestedIntArray([[1, 2], [3]]), [[1, 2], [3]]);
    assert.deepEqual(exports.roundTripNestedIntArray([[1, 2], [], [3]]), [[1, 2], [], [3]]);
    assert.deepEqual(exports.roundTripNestedStringArray([["a", "b"], ["c"]]), [["a", "b"], ["c"]]);
    assert.deepEqual(exports.roundTripNestedDoubleArray([[1.5], [2.5]]), [[1.5], [2.5]]);
    assert.deepEqual(exports.roundTripNestedBoolArray([[true], [false]]), [[true], [false]]);
    const nestedPoint = { x: 1.0, y: 2.0, label: "A", optCount: null, optFlag: null };
    assert.deepEqual(exports.roundTripNestedStructArray([[nestedPoint]])[0][0], nestedPoint);
    assert.deepEqual(exports.roundTripNestedCaseEnumArray([[Direction.North], [Direction.South]]), [[Direction.North], [Direction.South]]);
    const ng1 = new Greeter("Nested1");
    const ng2 = new Greeter("Nested2");
    const nestedGreeters = exports.roundTripNestedSwiftClassArray([[ng1], [ng2]]);
    assert.equal(nestedGreeters[0][0].name, "Nested1");
    assert.equal(nestedGreeters[1][0].greet(), "Hello, Nested2!");
    ng1.release(); ng2.release();
    nestedGreeters.forEach(row => row.forEach(g => g.release()));

    // Multiple array parameters
    assert.deepEqual(exports.multiArrayFirst([1, 2, 3], ["a", "b"]), [1, 2, 3]);
    assert.deepEqual(exports.multiArraySecond([1, 2, 3], ["a", "b"]), ["a", "b"]);
    assert.deepEqual(exports.multiOptionalArrayFirst([10, 20], ["x"]), [10, 20]);
    assert.deepEqual(exports.multiOptionalArraySecond([10, 20], ["x"]), ["x"]);
    assert.equal(exports.multiOptionalArrayFirst(null, ["y"]), null);
    assert.deepEqual(exports.multiOptionalArraySecond(null, ["y"]), ["y"]);
    assert.deepEqual(exports.multiOptionalArrayFirst([5], null), [5]);
    assert.equal(exports.multiOptionalArraySecond([5], null), null);
}