import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

// Executes the glue generated for Inputs/MacroSwift/SpanParameters.swift.
const source = await readFile(process.argv[2], 'utf8');
const shared = process.argv[3] === 'shared';
const { createInstantiator } = await import(`data:text/javascript;base64,${Buffer.from(source).toString('base64')}`);

const PAGE_SIZE = 64 * 1024;
const HIGH_OFFSET = 0x8000_0000;
const SIGNED_POINTER = HIGH_OFFSET | 0;
const pages = HIGH_OFFSET / PAGE_SIZE + 4;
const memory = new WebAssembly.Memory({ initial: pages, maximum: pages, shared });
const heap = [undefined];
const swift = { memory: { heap, retain: (value) => heap.push(value) - 1, getObject: (id) => heap[id] } };

let handler;
const received = [];
const call = (...views) => {
    received.push(...views.filter((view) => view instanceof Uint8Array));
    return handler(...views);
};
class ByteSink {
    constructor(header) { call(header); }
    write(bytes) { return call(bytes); }
    read(bytes) { return call(bytes); }
    static checksum(bytes) { return call(bytes); }
}
const userImports = {
    readBytes: call,
    fillBytes: call,
    copyBytes: call,
    ByteSink,
};
const bridge = await createInstantiator({ getImports: () => userImports }, swift);
const importObject = {};
bridge.addImports(importObject, {});
const exception = { value: 0 };
bridge.setInstance({ exports: { memory, _swift_js_exception: exception } });
const glue = importObject.TestModule;

const bytesAt = (offset, count) => Array.from(new Uint8Array(memory.buffer, offset, count));
function place(offset, values) {
    new Uint8Array(memory.buffer, offset, values.length).set(values);
}
function expectView(view, offset, count) {
    assert.ok(view instanceof Uint8Array);
    assert.equal(view.length, count);
    if (shared) {
        assert.ok(!(view.buffer instanceof SharedArrayBuffer), 'shared builds pass a copy');
        assert.equal(view.byteOffset, 0);
    } else {
        assert.equal(view.buffer, memory.buffer, 'unshared builds pass a view of Wasm memory');
        assert.equal(view.byteOffset, offset);
    }
}
function small(value) {
    const bytes = new TextEncoder().encode(value);
    const storage = new Uint8Array(12);
    storage.set(bytes);
    storage[9] = 0xe0 | bytes.length;
    const view = new DataView(storage.buffer);
    return [0, 4, 8].map((offset) => view.getInt32(offset, true));
}
function run(body) {
    received.length = 0;
    exception.value = 0;
    return body();
}

// A Span parameter carries the bytes at its pointer, including above 2 GiB.
for (const [pointer, offset] of [[64, 64], [SIGNED_POINTER, HIGH_OFFSET]]) {
    place(offset, [1, 2, 3, 4]);
    handler = (bytes) => bytes.reduce((sum, byte) => sum + byte, 0);
    assert.equal(run(() => glue.bjs_readBytes(pointer, 4)), 10);
    expectView(received[0], offset, 4);
    assert.deepEqual(Array.from(received[0]), [1, 2, 3, 4]);
}

handler = (bytes) => bytes.length;
assert.equal(run(() => glue.bjs_readBytes(0, 0)), 0);
expectView(received[0], 0, 0);

// Writes to a Span copy are not copied back into Wasm memory.
if (shared) {
    place(64, [1, 2, 3, 4]);
    handler = (bytes) => { bytes.fill(0); return 0; };
    run(() => glue.bjs_readBytes(64, 4));
    assert.deepEqual(bytesAt(64, 4), [1, 2, 3, 4]);
}

// A MutableSpan parameter carries JavaScript's writes back into Wasm memory.
for (const [pointer, offset] of [[128, 128], [SIGNED_POINTER, HIGH_OFFSET]]) {
    place(offset, [0, 0, 0]);
    handler = (bytes) => { bytes.set([9, 8, 7]); };
    assert.equal(run(() => glue.bjs_fillBytes(pointer, 3)), undefined);
    expectView(received[0], offset, 3);
    assert.deepEqual(bytesAt(offset, 3), [9, 8, 7]);
    assert.equal(exception.value, 0);
}

// Writes made before the import throws still reach Wasm memory.
const failure = new Error('fill failed');
place(128, [0, 0, 0]);
handler = (bytes) => { bytes.set([5, 6, 7]); throw failure; };
run(() => glue.bjs_fillBytes(128, 3));
assert.deepEqual(bytesAt(128, 3), [5, 6, 7]);
assert.equal(heap[exception.value], failure);

// An out-of-bounds span is reported to Swift.
handler = () => assert.fail('the import must not run');
run(() => glue.bjs_fillBytes((HIGH_OFFSET + 4 * PAGE_SIZE) | 0, 1));
assert.ok(heap[exception.value] instanceof RangeError);

// Two spans and a String in one call.
place(256, [11, 12, 13, 14]);
place(512, [0, 0, 0, 0]);
handler = (source, label, destination) => { destination.set(source); return label.length; };
assert.equal(run(() => glue.bjs_copyBytes(256, 4, ...small('abc'), 512, 4)), 3);
expectView(received[0], 256, 4);
expectView(received[1], 512, 4);
assert.deepEqual(bytesAt(512, 4), [11, 12, 13, 14]);

// Initializers, instance methods and static methods.
place(1024, [21, 22]);
handler = () => 0;
const sinkRef = run(() => glue.bjs_ByteSink_init(1024, 2));
assert.ok(heap[sinkRef] instanceof ByteSink);
expectView(received[0], 1024, 2);
assert.deepEqual(Array.from(received[0]), [21, 22]);

handler = (bytes) => bytes[1];
assert.equal(run(() => glue.bjs_ByteSink_write(sinkRef, 1024, 2)), 22);
expectView(received[0], 1024, 2);
assert.equal(run(() => glue.bjs_ByteSink_checksum_static(1024, 2)), 22);
expectView(received[0], 1024, 2);

place(2048, [0, 0]);
handler = (bytes) => { bytes.set([31, 32]); return 2; };
assert.equal(run(() => glue.bjs_ByteSink_read(sinkRef, 2048, 2)), 2);
expectView(received[0], 2048, 2);
assert.deepEqual(bytesAt(2048, 2), [31, 32]);

console.log(`Span parameter glue passed (${shared ? 'shared' : 'unshared'} memory)`);
