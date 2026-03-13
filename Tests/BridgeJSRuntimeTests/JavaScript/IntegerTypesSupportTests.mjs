// @ts-check

import assert from 'node:assert';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["IntegerTypesSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsRoundTripInt: (v) => {
            return v;
        },
        jsRoundTripUInt: (v) => {
            return v;
        },
        jsRoundTripInt8: (v) => {
            return v;
        },
        jsRoundTripUInt8: (v) => {
            return v;
        },
        jsRoundTripInt16: (v) => {
            return v;
        },
        jsRoundTripUInt16: (v) => {
            return v;
        },
        jsRoundTripInt32: (v) => {
            return v;
        },
        jsRoundTripUInt32: (v) => {
            return v;
        },
        jsRoundTripInt64: (v) => {
            return v;
        },
        jsRoundTripUInt64: (v) => {
            return v;
        },
        runJsIntegerTypesSupportTests: () => {
            const exports = importsContext.getExports();
            if (!exports) { throw new Error("No exports!?"); }
            runJsIntegerTypesSupportTests(exports);
        },
    }
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} rootExports
 */
export function runJsIntegerTypesSupportTests(rootExports) {
    const exports = rootExports.IntegerTypesSupportExports;
    const int8Min = -(1 << 7);
    const int8Max = (1 << 7) - 1;
    const uint8Max = (1 << 8) - 1;
    const int16Min = -(1 << 15);
    const int16Max = (1 << 15) - 1;
    const uint16Max = (1 << 16) - 1;
    const int32Min = -(2 ** 31);
    const int32Max = (2 ** 31) - 1;
    const uint32Max = (2 ** 32) - 1;
    const int64Min = -(1n << 63n);
    const int64Max = (1n << 63n) - 1n;
    const uint64Max = (1n << 64n) - 1n;

    for (const v of [0, 1, -1, int32Min, int32Max]) {
        assert.equal(exports.roundTripInt(v), v);
    }
    for (const v of [0, 1, uint32Max]) {
        assert.equal(exports.roundTripUInt(v), v);
    }
    for (const [v, expected] of [
        [int32Max + 1, int32Min],
        [int32Min - 1, int32Max],
    ]) {
        assert.equal(exports.roundTripInt(v), expected);
    }
    for (const [v, expected] of [
        [-1, uint32Max],
        [uint32Max + 1, 0],
    ]) {
        assert.equal(exports.roundTripUInt(v), expected);
    }
    for (const v of [0, 1, -1, int8Min, int8Max]) {
        assert.equal(exports.roundTripInt8(v), v);
    }
    for (const v of [0, 1, uint8Max]) {
        assert.equal(exports.roundTripUInt8(v), v);
    }
    for (const v of [0, 1, -1, int16Min, int16Max]) {
        assert.equal(exports.roundTripInt16(v), v);
    }
    for (const v of [0, 1, uint16Max]) {
        assert.equal(exports.roundTripUInt16(v), v);
    }
    for (const v of [0, 1, -1, int32Min, int32Max]) {
        assert.equal(exports.roundTripInt32(v), v);
    }
    for (const v of [0, 1, uint32Max]) {
        assert.equal(exports.roundTripUInt32(v), v);
    }
    for (const [v, expected] of [
        [int8Max + 1, -128],
        [int8Min - 1, 127],
    ]) {
        assert.equal(exports.roundTripInt8(v), expected);
    }
    for (const [v, expected] of [
        [-1, 255],
        [uint8Max + 1, 0],
    ]) {
        assert.equal(exports.roundTripUInt8(v), expected);
    }
    for (const [v, expected] of [
        [int16Max + 1, -32768],
        [int16Min - 1, 32767],
    ]) {
        assert.equal(exports.roundTripInt16(v), expected);
    }
    for (const [v, expected] of [
        [-1, 65535],
        [uint16Max + 1, 0],
    ]) {
        assert.equal(exports.roundTripUInt16(v), expected);
    }
    for (const [v, expected] of [
        [int32Max + 1, int32Min],
        [int32Min - 1, int32Max],
    ]) {
        assert.equal(exports.roundTripInt32(v), expected);
    }
    for (const [v, expected] of [
        [-1, uint32Max],
        [uint32Max + 1, 0],
    ]) {
        assert.equal(exports.roundTripUInt32(v), expected);
    }
    for (const v of [
        0n, 1n, -1n,
        BigInt(Number.MIN_SAFE_INTEGER),
        BigInt(Number.MAX_SAFE_INTEGER),
        int64Min,
        int64Max,
    ]) {
        assert.equal(exports.roundTripInt64(v), v);
    }
    for (const v of [
        0n, 1n,
        BigInt(Number.MAX_SAFE_INTEGER),
        uint64Max,
    ]) {
        assert.equal(exports.roundTripUInt64(v), v);
    }
    for (const v of [
        int64Max + 1n,
        int64Min - 1n,
        uint64Max,
        uint64Max + 1n,
        -(1n << 64n),
        (1n << 127n) - 1n,
    ]) {
        assert.equal(exports.roundTripInt64(v), BigInt.asIntN(64, v));
    }
    for (const v of [
        -1n,
        -2n,
        int64Min,
        int64Max,
        uint64Max + 1n,
        -(1n << 64n),
        (1n << 127n) - 1n,
    ]) {
        assert.equal(exports.roundTripUInt64(v), BigInt.asUintN(64, v));
    }
}