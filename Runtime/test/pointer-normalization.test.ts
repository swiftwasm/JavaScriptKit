import { describe, expect, test } from "vitest";
import { SwiftRuntime } from "../src/index.js";
import { decodeArray, decodeObjectRefs, Kind, write } from "../src/js-value.js";

// A Wasm pointer is an `i32`. Once the linear memory grows past 2 GiB, valid
// addresses set the high bit and the guest passes them to JavaScript as *negative*
// numbers, which must be normalized with `>>> 0` before being used as memory
// offsets. These tests use a real >2 GiB `WebAssembly.Memory` and a real
// `SwiftRuntime`, exercising the actual code paths at such an address; without the
// normalization each one throws a `RangeError` on the negative offset.
const PAGE_SIZE = 64 * 1024;
const HIGH_OFFSET = 0x8000_0000; // 2 GiB, the first address with the high bit set
const SIGNED_POINTER = HIGH_OFFSET | 0; // how the guest passes that pointer: -2_147_483_648
const MEMORY_PAGES = HIGH_OFFSET / PAGE_SIZE + 4; // a few pages past the offset

function makeRuntime(): { runtime: SwiftRuntime; memory: WebAssembly.Memory } {
    const memory = new WebAssembly.Memory({ initial: MEMORY_PAGES });
    const runtime = new SwiftRuntime();
    runtime.setInstance({
        exports: {
            memory,
            swjs_library_version: () => 708,
        },
    } as unknown as WebAssembly.Instance);
    return { runtime, memory };
}

describe("pointer normalization at >2 GiB addresses", () => {
    test("swjs_decode_string reads from a high-bit pointer", () => {
        const { runtime, memory } = makeRuntime();
        const bytes = new TextEncoder().encode("hello, 🌍");
        new Uint8Array(memory.buffer).set(bytes, HIGH_OFFSET);

        const imports = runtime.wasmImports as any;
        const ref = imports.swjs_decode_string(SIGNED_POINTER, bytes.length);

        expect((runtime as any).memory.getObject(ref)).toBe("hello, 🌍");
    });

    test("swjs_load_string writes to a high-bit pointer", () => {
        const { runtime, memory } = makeRuntime();
        const bytes = new TextEncoder().encode("world");
        const ref = (runtime as any).memory.retain(bytes);

        const imports = runtime.wasmImports as any;
        imports.swjs_load_string(ref, SIGNED_POINTER);

        const written = new Uint8Array(memory.buffer).slice(
            HIGH_OFFSET,
            HIGH_OFFSET + bytes.length,
        );
        expect(new TextDecoder().decode(written)).toBe("world");
    });

    test("swjs_create_typed_array copies from a high-bit pointer", () => {
        const { runtime, memory } = makeRuntime();
        new Uint8Array(memory.buffer).set([1, 2, 3, 4], HIGH_OFFSET);

        const space = (runtime as any).memory;
        const constructorRef = space.retain(Uint8Array);
        const imports = runtime.wasmImports as any;
        const ref = imports.swjs_create_typed_array(
            constructorRef,
            SIGNED_POINTER,
            4,
        );

        expect(Array.from(space.getObject(ref))).toEqual([1, 2, 3, 4]);
    });

    test("decodeArray reads JSValue elements from a high-bit pointer", () => {
        const { runtime, memory } = makeRuntime();
        const dataView = new DataView(memory.buffer);
        dataView.setUint32(HIGH_OFFSET, Kind.Number, true);
        dataView.setUint32(HIGH_OFFSET + 4, 0, true);
        dataView.setFloat64(HIGH_OFFSET + 8, 42.5, true);

        const values = decodeArray(
            SIGNED_POINTER,
            1,
            dataView,
            (runtime as any).memory,
        );

        expect(values).toEqual([42.5]);
    });

    test("decodeObjectRefs reads refs from a high-bit pointer", () => {
        const { memory } = makeRuntime();
        const dataView = new DataView(memory.buffer);
        dataView.setUint32(HIGH_OFFSET, 11, true);
        dataView.setUint32(HIGH_OFFSET + 4, 22, true);

        expect(decodeObjectRefs(SIGNED_POINTER, 2, dataView)).toEqual([11, 22]);
    });

    test("write stores a JSValue at high-bit pointers", () => {
        const { runtime, memory } = makeRuntime();
        const dataView = new DataView(memory.buffer);

        write(
            42.5,
            SIGNED_POINTER,
            SIGNED_POINTER + 4,
            SIGNED_POINTER + 8,
            false,
            dataView,
            (runtime as any).memory,
        );

        expect(dataView.getUint32(HIGH_OFFSET, true)).toBe(Kind.Number);
        expect(dataView.getFloat64(HIGH_OFFSET + 8, true)).toBe(42.5);
    });
});
