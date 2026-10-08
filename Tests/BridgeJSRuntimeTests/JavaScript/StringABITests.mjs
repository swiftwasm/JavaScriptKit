// @ts-check

import assert from 'node:assert';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["StringABIImports"]}
 */
export function getImports(importsContext) {
    return {
        jsEcho: (value) => value,
        jsEchoArray: (value) => value,
        jsEchoOptional: (value) => value ?? null,
        runJsStringABITests: () => {
            const exports = importsContext.getExports();
            if (!exports) { throw new Error("No exports!?"); }
            runJsStringABITests(exports);
        },
    };
}

/**
 * Swift→JS string layout coverage: small, immortal, dynamic, substring, optional.
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} rootExports
 */
export function runJsStringABITests(rootExports) {
    const exports = rootExports.StringABIExports;
    const immortal = "this is a long immortal literal string";

    assert.equal(exports.smallEmpty(), "");
    assert.equal(exports.smallASCII(), "div");
    assert.equal(exports.smallEight(), "abcdefgh");
    assert.equal(exports.smallNine(), "abcdefghi");
    assert.equal(exports.smallTen(), "abcdefghij");
    assert.equal(exports.smallUTF8(), "é");
    assert.equal(exports.largeImmortal(), immortal);
    assert.equal(exports.largeImmortalAgain(), immortal);
    assert.equal(exports.largeDynamic(), immortal);
    assert.equal(exports.immortalSubstring(), immortal.slice(10));
    assert.equal(exports.optionalNone(), null);
    assert.equal(exports.optionalSome(), immortal);
    const expected = samples.map((s) => s.startsWith("\ufeff") ? s.slice(1) : s);
    for (let i = 0; i < samples.length; i++) {
        assert.equal(exports.echo(samples[i]), expected[i]);
        assert.equal(exports.echoOptional(samples[i]), expected[i]);
    }
    assert.deepEqual(exports.echoArray(samples), expected);
}

const samples = [
    "abcdefé", "abcdefgé", "abcdefghé", "abcdefghié", "abc€", "abcdefg€",
    "abc😄", "abcdef😄", "abcdefg😄", "a\0b", "\ufeffx", "x\ufeff",
    "\ufeff\ufeffx", "\ufeffabcdefghijk", "abc\ufeffdefghijk", "\ufeff\ufeffabcdefghijk",
];
