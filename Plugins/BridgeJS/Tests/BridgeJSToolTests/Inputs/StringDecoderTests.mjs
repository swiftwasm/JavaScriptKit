import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

// Execute generated glue rather than a duplicate of the decoder implementation.
const source = await readFile(process.argv[2] ?? new URL('../__Snapshots__/BridgeJSLinkTests/StringReturn.js', import.meta.url), 'utf8');
const shared = process.argv[3] === 'shared';
const { createInstantiator } = await import(`data:text/javascript;base64,${Buffer.from(source).toString('base64')}`);
const encoder = new TextEncoder();
const swift = { memory: { heap: [], retain: (value) => value } };
const bridge = await createInstantiator({ getImports: () => ({}) }, swift);
const imports = {};
bridge.addImports(imports, {});
let words;
function instance(memory) {
    return { exports: { memory, bjs_checkString: () => imports.bjs.swift_js_return_string(...words) } };
}
let memory = new WebAssembly.Memory({ initial: 40, maximum: 41, shared });
let wasm = instance(memory);
bridge.setInstance(wasm);
let exports = bridge.createExports(wasm);
function small(value) {
    const bytes = encoder.encode(value);
    assert.ok(bytes.length <= 8);
    const storage = new Uint8Array(12);
    storage.set(bytes.subarray(0, 8));
    storage[9] = (bytes.every((b) => b < 128) ? 0xe0 : 0xa0) | bytes.length;
    const view = new DataView(storage.buffer);
    return [0, 4, 8].map((offset) => view.getInt32(offset, true));
}
function large(value, immortal = false, ptr = 64) {
    const bytes = encoder.encode(value);
    new Uint8Array(memory.buffer, ptr, bytes.length).set(bytes);
    return [bytes.length, ptr - 20, immortal ? 0x8000 : 0];
}
const values = ['', 'div', 'abcdefgh', 'abcdefghi', 'abcdefghij', 'abcdefé', 'abcdefgé',
    'abcdefghé', 'abcdefghié', 'abc€', 'abcdefg€', 'abc😄', 'abcdef😄', 'abcdefg😄',
    '😄😄', 'éééé', 'a\0b', '\ufeff', '\ufeffx', '\ufeffabcde', '\ufeffabcdef',
    'x\ufeff', '\ufeff\ufeffx', '\ufeffabcdefghijk',
    'abc\ufeffdefghijk', '\ufeff\ufeffabcdefghijk',
    // UTF-8 widths, the surrogate gap, and supplementary-plane boundaries.
    '\u0080', '\u07ff', '\u0800', '\ud7ff', '\ue000', '\uffff', '\u{10000}', '\u{10ffff}'];
for (const [index, value] of values.entries()) {
    if (encoder.encode(value).length <= 8) {
        words = small(value);
        assert.equal(exports.checkString(), value);
    }
    for (const immortal of [false, true]) {
        // Distinct locations keep immortal cache entries faithful to Swift literals.
        words = large(value, immortal, 64 + index * 64);
        assert.equal(exports.checkString(), value);
        assert.equal(exports.checkString(), value);
    }
}
// Alternate full and short inputs: bytes outside count must never leak into the result.
for (const value of ['abcd😄', 'é', 'abcde€', '\ufeff', 'abcdefgh', '', 'x\0', '€', '\ufeff\ufeff']) {
    words = small(value);
    assert.equal(exports.checkString(), value);
}
// Every ASCII byte, including NUL, at every small-string length.
for (let byte = 0; byte < 128; byte++) {
    for (let count = 0; count <= 8; count++) {
        const value = String.fromCharCode(byte).repeat(count);
        words = small(value);
        assert.equal(exports.checkString(), value);
    }
}
// Unexpected inline lengths must fail for both ASCII and Unicode discriminators.
for (const count of [9, 10]) {
    for (const discriminator of [0xe0, 0xa0]) {
        words = [0, 0, (discriminator | count) << 8];
        assert.throws(() => exports.checkString(), {
            name: 'Error',
            message: `Unsupported Swift inline String length: ${count} UTF-8 bytes (maximum 8). The Swift String layout may have changed; update JavaScriptKit and regenerate BridgeJS glue.`,
        });
    }
}
words = large('first literal', true);
assert.equal(exports.checkString(), 'first literal');
// A new instance using the same memory must preserve valid cache entries.
wasm = instance(memory);
bridge.setInstance(wasm);
exports = bridge.createExports(wasm);
assert.equal(exports.checkString(), 'first literal');
// A different memory may reuse the same pointer/length for different contents.
memory = new WebAssembly.Memory({ initial: 40, maximum: 41, shared });
wasm = instance(memory);
bridge.setInstance(wasm);
exports = bridge.createExports(wasm);
words = large('other literal', true);
assert.equal(exports.checkString(), 'other literal');
// Same pointer with a different length must have a distinct key.
words = large('other', true);
assert.equal(exports.checkString(), 'other');
// Values at the numeric-key cutoff bypass the cache.
const huge = 'x'.repeat(2 ** 21);
words = large(huge, true);
assert.equal(exports.checkString(), huge);
new Uint8Array(memory.buffer)[64] = 121;
assert.equal(exports.checkString(), 'y' + huge.slice(1));
memory.grow(1);
words = large('after memory growth');
assert.equal(exports.checkString(), 'after memory growth');
console.log('String decoder regressions passed');
