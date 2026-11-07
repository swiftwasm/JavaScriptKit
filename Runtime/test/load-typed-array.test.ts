import { describe, expect, test } from "vitest";
import { SwiftRuntime } from "../src/index.js";

// `swjs_load_typed_array` must copy only the window a TypedArray view describes,
// not its whole backing `ArrayBuffer`. The guest sizes the destination from the
// view's own `length`/`byteLength`, so copying the entire buffer both shifts the
// bytes (a view with a non-zero `byteOffset` lands offset in the guest) and
// writes past the end of the destination.
const DESTINATION = 1024;

function makeRuntime(): { runtime: SwiftRuntime; memory: WebAssembly.Memory } {
    const memory = new WebAssembly.Memory({ initial: 1 });
    const runtime = new SwiftRuntime();
    runtime.setInstance({
        exports: {
            memory,
            swjs_library_version: () => 708,
        },
    } as unknown as WebAssembly.Instance);
    return { runtime, memory };
}

describe("swjs_load_typed_array respects the view's window", () => {
    test("copies a Uint8Array view from its byteOffset", () => {
        const { runtime, memory } = makeRuntime();
        const backing = new ArrayBuffer(32);
        new Uint8Array(backing).set(
            Array.from({ length: 32 }, (_, i) => 0xa0 + i),
        );
        const view = new Uint8Array(backing, 8, 8);

        const space = (runtime as any).memory;
        const imports = runtime.wasmImports as any;
        imports.swjs_load_typed_array(space.retain(view), DESTINATION);

        const guest = new Uint8Array(memory.buffer);
        expect(
            Array.from(guest.subarray(DESTINATION, DESTINATION + 8)),
        ).toEqual(Array.from(view));
    });

    test("does not write past the end of the view", () => {
        const { runtime, memory } = makeRuntime();
        const backing = new ArrayBuffer(32);
        new Uint8Array(backing).fill(0xff);
        const view = new Uint8Array(backing, 8, 8);

        // Fill the guest memory around the destination with a sentinel so any
        // byte written beyond the view's `byteLength` is visible.
        const guest = new Uint8Array(memory.buffer);
        guest.fill(0x5a, DESTINATION, DESTINATION + 64);

        const space = (runtime as any).memory;
        const imports = runtime.wasmImports as any;
        imports.swjs_load_typed_array(space.retain(view), DESTINATION);

        expect(
            Array.from(guest.subarray(DESTINATION + 8, DESTINATION + 64)),
        ).toEqual(new Array(56).fill(0x5a));
    });

    test("copies a multi-byte element view from its byteOffset", () => {
        const { runtime, memory } = makeRuntime();
        const backing = new ArrayBuffer(32);
        new Int32Array(backing).set([1, 2, 3, 4, 5, 6, 7, 8]);
        const view = new Int32Array(backing, 8, 4);

        const space = (runtime as any).memory;
        const imports = runtime.wasmImports as any;
        imports.swjs_load_typed_array(space.retain(view), DESTINATION);

        const guest = new Int32Array(memory.buffer, DESTINATION, 4);
        expect(Array.from(guest)).toEqual([3, 4, 5, 6]);
    });

    test("copies a DataView from its byteOffset", () => {
        const { runtime, memory } = makeRuntime();
        const backing = new ArrayBuffer(32);
        new Uint8Array(backing).set(
            Array.from({ length: 32 }, (_, i) => 0xa0 + i),
        );
        const view = new DataView(backing, 8, 8);

        const space = (runtime as any).memory;
        const imports = runtime.wasmImports as any;
        imports.swjs_load_typed_array(space.retain(view), DESTINATION);

        const guest = new Uint8Array(memory.buffer);
        expect(
            Array.from(guest.subarray(DESTINATION, DESTINATION + 8)),
        ).toEqual(Array.from(new Uint8Array(backing, 8, 8)));
    });

    test("still copies a whole-buffer view unchanged", () => {
        const { runtime, memory } = makeRuntime();
        const view = new Uint8Array([1, 2, 3, 4, 5]);

        const space = (runtime as any).memory;
        const imports = runtime.wasmImports as any;
        imports.swjs_load_typed_array(space.retain(view), DESTINATION);

        const guest = new Uint8Array(memory.buffer);
        expect(
            Array.from(guest.subarray(DESTINATION, DESTINATION + 5)),
        ).toEqual([1, 2, 3, 4, 5]);
    });
});
