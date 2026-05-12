// @ts-check

import assert from 'node:assert';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["JSTypedArrayImports"]}
 */
export function getImports(importsContext) {
    return {
        jsCreateUint8Array: function () {
            return new Uint8Array([10, 20, 30]);
        },
        jsRoundTripUint8Array: function (arr) {
            assert.ok(arr instanceof Uint8Array, 'Expected Uint8Array');
            return arr;
        },
        jsRoundTripFloat32Array: function (arr) {
            assert.ok(arr instanceof Float32Array, 'Expected Float32Array');
            return arr;
        },
        jsRoundTripFloat64Array: function (arr) {
            assert.ok(arr instanceof Float64Array, 'Expected Float64Array');
            return arr;
        },
        jsRoundTripInt32Array: function (arr) {
            assert.ok(arr instanceof Int32Array, 'Expected Int32Array');
            return arr;
        },
        runJsTypedArrayTests: () => {
            const exports = importsContext.getExports();
            if (!exports) { throw new Error("No exports!?"); }
            runJsTypedArrayTests(exports);
        },
    };
}

/**
 * JSTypedArray bridging coverage for BridgeJS runtime tests.
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} rootExports
 */
export function runJsTypedArrayTests(rootExports) {
    const exports = rootExports.JSTypedArrayExports;

    // Uint8Array round-trip
    const u8 = new Uint8Array([1, 2, 3, 255]);
    const u8Result = exports.roundTripUint8Array(u8);
    assert.ok(u8Result instanceof Uint8Array, 'Expected Uint8Array back from Swift');
    assert.equal(u8Result.length, 4);
    assert.deepEqual(Array.from(u8Result), [1, 2, 3, 255]);

    // Float32Array round-trip
    const f32 = new Float32Array([1.0, 2.5, 3.0]);
    const f32Result = exports.roundTripFloat32Array(f32);
    assert.ok(f32Result instanceof Float32Array, 'Expected Float32Array back from Swift');
    assert.equal(f32Result.length, 3);
    assert.deepEqual(Array.from(f32Result), [1.0, 2.5, 3.0]);

    // Float64Array round-trip
    const f64 = new Float64Array([1.0, 2.5, 3.14159]);
    const f64Result = exports.roundTripFloat64Array(f64);
    assert.ok(f64Result instanceof Float64Array, 'Expected Float64Array back from Swift');
    assert.equal(f64Result.length, 3);
    assert.deepEqual(Array.from(f64Result), [1.0, 2.5, 3.14159]);

    // Int32Array round-trip
    const i32 = new Int32Array([1, -2, 2147483647]);
    const i32Result = exports.roundTripInt32Array(i32);
    assert.ok(i32Result instanceof Int32Array, 'Expected Int32Array back from Swift');
    assert.equal(i32Result.length, 3);
    assert.deepEqual(Array.from(i32Result), [1, -2, 2147483647]);

    // Empty typed array
    const emptyU8 = new Uint8Array([]);
    const emptyResult = exports.roundTripUint8Array(emptyU8);
    assert.ok(emptyResult instanceof Uint8Array, 'Expected Uint8Array for empty array');
    assert.equal(emptyResult.length, 0);
}
