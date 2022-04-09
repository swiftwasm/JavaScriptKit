import { SwiftClosureDeallocator } from "./closure-heap";
import {
    LibraryFeatures,
    ExportedFunctions,
    ref,
    pointer,
    TypedArray,
    ImportedFunctions,
} from "./types";
import * as JSValue from "./js-value";
import { Memory } from "./memory";

export class SwiftRuntime {
    private _instance: WebAssembly.Instance | null;
    private _memory: Memory | null;
    private _closureDeallocator: SwiftClosureDeallocator | null;
    private version: number = 706;

    private textDecoder = new TextDecoder("utf-8");
    private textEncoder = new TextEncoder(); // Only support utf-8

    constructor() {
        this._instance = null;
        this._memory = null;
        this._closureDeallocator = null;
    }

    setInstance(instance: WebAssembly.Instance) {
        this._instance = instance;
        if (this.exports.swjs_library_version() != this.version) {
            throw new Error(
                `The versions of JavaScriptKit are incompatible.
                WebAssembly runtime ${this.exports.swjs_library_version()} != JS runtime ${
                    this.version
                }`
            );
        }
    }

    private get instance() {
        if (!this._instance)
            throw new Error("WebAssembly instance is not set yet");
        return this._instance;
    }

    private get exports() {
        return this.instance.exports as any as ExportedFunctions;
    }

    private get memory() {
        if (!this._memory) {
            this._memory = new Memory(this.instance.exports);
        }
        return this._memory;
    }

    private get closureDeallocator(): SwiftClosureDeallocator | null {
        if (this._closureDeallocator) return this._closureDeallocator;

        const features = this.exports.swjs_library_features();
        const librarySupportsWeakRef =
            (features & LibraryFeatures.WeakRefs) != 0;
        if (librarySupportsWeakRef) {
            this._closureDeallocator = new SwiftClosureDeallocator(
                this.exports
            );
        }
        return this._closureDeallocator;
    }

    private callHostFunction(host_func_id: number, args: any[]) {
        const argc = args.length;
        const argv = this.exports.swjs_prepare_host_function_call(argc);
        for (let index = 0; index < args.length; index++) {
            const argument = args[index];
            const base = argv + 16 * index;
            JSValue.write(
                argument,
                base,
                base + 4,
                base + 8,
                false,
                this.memory
            );
        }
        let output: any;
        // This ref is released by the swjs_call_host_function implementation
        const callback_func_ref = this.memory.retain((result: any) => {
            output = result;
        });
        this.exports.swjs_call_host_function(
            host_func_id,
            argv,
            argc,
            callback_func_ref
        );
        this.exports.swjs_cleanup_host_function_call(argv);
        return output;
    }

    /** @deprecated Use `wasmImports` instead */
    importObjects = () => this.wasmImports;

    readonly wasmImports: ImportedFunctions = {
        swjs_set_prop: (
            ref: ref,
            name: ref,
            kind: JSValue.Kind,
            payload1: number,
            payload2: number
        ) => {
            const obj = this.memory.getObject(ref);
            const key = this.memory.getObject(name);
            const value = JSValue.decode(kind, payload1, payload2, this.memory);
            obj[key] = value;
        },

        swjs_get_prop: (
            ref: ref,
            name: ref,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const obj = this.memory.getObject(ref);
            const key = this.memory.getObject(name);
            const result = obj[key];
            JSValue.write(
                result,
                kind_ptr,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },

        swjs_set_subscript: (
            ref: ref,
            index: number,
            kind: JSValue.Kind,
            payload1: number,
            payload2: number
        ) => {
            const obj = this.memory.getObject(ref);
            const value = JSValue.decode(kind, payload1, payload2, this.memory);
            obj[index] = value;
        },

        swjs_get_subscript: (
            ref: ref,
            index: number,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const obj = this.memory.getObject(ref);
            const result = obj[index];
            JSValue.write(
                result,
                kind_ptr,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },

        swjs_encode_string: (ref: ref, bytes_ptr_result: pointer) => {
            const bytes = this.textEncoder.encode(this.memory.getObject(ref));
            const bytes_ptr = this.memory.retain(bytes);
            this.memory.writeUint32(bytes_ptr_result, bytes_ptr);
            return bytes.length;
        },

        swjs_decode_string: (bytes_ptr: pointer, length: number) => {
            const bytes = this.memory
                .bytes()
                .subarray(bytes_ptr, bytes_ptr + length);
            const string = this.textDecoder.decode(bytes);
            return this.memory.retain(string);
        },

        swjs_load_string: (ref: ref, buffer: pointer) => {
            const bytes = this.memory.getObject(ref);
            this.memory.writeBytes(buffer, bytes);
        },

        swjs_call_function: (
            ref: ref,
            argv: pointer,
            argc: number,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const func = this.memory.getObject(ref);
            let result: any;
            try {
                const args = JSValue.decodeArray(argv, argc, this.memory);
                result = func(...args);
            } catch (error) {
                JSValue.write(
                    error,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    true,
                    this.memory
                );
                return;
            }
            JSValue.write(
                result,
                kind_ptr,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },
        swjs_call_function_no_catch: (
            ref: ref,
            argv: pointer,
            argc: number,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const func = this.memory.getObject(ref);
            let isException = true;
            try {
                const args = JSValue.decodeArray(argv, argc, this.memory);
                const result = func(...args);
                JSValue.write(
                    result,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
                isException = false;
            } finally {
                if (isException) {
                    JSValue.write(
                        undefined,
                        kind_ptr,
                        payload1_ptr,
                        payload2_ptr,
                        true,
                        this.memory
                    );
                }
            }
        },

        swjs_call_function_with_this: (
            obj_ref: ref,
            func_ref: ref,
            argv: pointer,
            argc: number,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const obj = this.memory.getObject(obj_ref);
            const func = this.memory.getObject(func_ref);
            let result: any;
            try {
                const args = JSValue.decodeArray(argv, argc, this.memory);
                result = func.apply(obj, args);
            } catch (error) {
                JSValue.write(
                    error,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    true,
                    this.memory
                );
                return;
            }
            JSValue.write(
                result,
                kind_ptr,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },

        swjs_call_function_with_this_no_catch: (
            obj_ref: ref,
            func_ref: ref,
            argv: pointer,
            argc: number,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const obj = this.memory.getObject(obj_ref);
            const func = this.memory.getObject(func_ref);
            let isException = true;
            try {
                const args = JSValue.decodeArray(argv, argc, this.memory);
                const result = func.apply(obj, args);
                JSValue.write(
                    result,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
                isException = false;
            } finally {
                if (isException) {
                    JSValue.write(
                        undefined,
                        kind_ptr,
                        payload1_ptr,
                        payload2_ptr,
                        true,
                        this.memory
                    );
                }
            }
        },
        swjs_call_new: (ref: ref, argv: pointer, argc: number) => {
            const constructor = this.memory.getObject(ref);
            const args = JSValue.decodeArray(argv, argc, this.memory);
            const instance = new constructor(...args);
            return this.memory.retain(instance);
        },

        swjs_call_throwing_new: (
            ref: ref,
            argv: pointer,
            argc: number,
            exception_kind_ptr: pointer,
            exception_payload1_ptr: pointer,
            exception_payload2_ptr: pointer
        ) => {
            const constructor = this.memory.getObject(ref);
            let result: any;
            try {
                const args = JSValue.decodeArray(argv, argc, this.memory);
                result = new constructor(...args);
            } catch (error) {
                JSValue.write(
                    error,
                    exception_kind_ptr,
                    exception_payload1_ptr,
                    exception_payload2_ptr,
                    true,
                    this.memory
                );
                return -1;
            }
            JSValue.write(
                null,
                exception_kind_ptr,
                exception_payload1_ptr,
                exception_payload2_ptr,
                false,
                this.memory
            );
            return this.memory.retain(result);
        },

        swjs_instanceof: (obj_ref: ref, constructor_ref: ref) => {
            const obj = this.memory.getObject(obj_ref);
            const constructor = this.memory.getObject(constructor_ref);
            return obj instanceof constructor;
        },

        swjs_create_function: (host_func_id: number) => {
            const func = (...args: any[]) =>
                this.callHostFunction(host_func_id, args);
            const func_ref = this.memory.retain(func);
            this.closureDeallocator?.track(func, func_ref);
            return func_ref;
        },

        swjs_create_typed_array: (
            constructor_ref: ref,
            elementsPtr: pointer,
            length: number
        ) => {
            const ArrayType: TypedArray =
                this.memory.getObject(constructor_ref);
            const array = new ArrayType(
                this.memory.rawMemory.buffer,
                elementsPtr,
                length
            );
            // Call `.slice()` to copy the memory
            return this.memory.retain(array.slice());
        },

        swjs_load_typed_array: (ref: ref, buffer: pointer) => {
            const typedArray = this.memory.getObject(ref);
            const bytes = new Uint8Array(typedArray.buffer);
            this.memory.writeBytes(buffer, bytes);
        },

        swjs_release: (ref: ref) => {
            this.memory.release(ref);
        },

        swjs_i64_to_bigint: (value: bigint, signed: number) => {
            return this.memory.retain(
                signed ? value : BigInt.asUintN(64, value)
            );
        },
        swjs_bigint_to_i64: (ref: ref, signed: number) => {
            const object = this.memory.getObject(ref);
            if (typeof object !== "bigint") {
                throw new Error(`Expected a BigInt, but got ${typeof object}`);
            }
            if (signed) {
                return object;
            } else {
                if (object < 0n) {
                    return 0n;
                }
                return BigInt.asIntN(64, object);
            }
        },
    };
}
