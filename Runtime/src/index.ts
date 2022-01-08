import { SwiftClosureHeap } from "./closure-heap";
import { SwiftRuntimeHeap } from "./object-heap";
import {
    ExportedMemory,
    LibraryFeatures,
    SwiftRuntimeExportedFunctions,
    ref,
    pointer,
    JavaScriptValueKind,
    TypedArray,
} from "./types";

export class SwiftRuntime {
    private instance: WebAssembly.Instance | null;
    private heap: SwiftRuntimeHeap;
    private _closureHeap: SwiftClosureHeap | null;
    private version: number = 703;

    constructor() {
        this.instance = null;
        this.heap = new SwiftRuntimeHeap();
        this._closureHeap = null;
    }

    setInstance(instance: WebAssembly.Instance) {
        this.instance = instance;
        const exports = this.instance
            .exports as any as SwiftRuntimeExportedFunctions;
        if (exports.swjs_library_version() != this.version) {
            throw new Error(
                `The versions of JavaScriptKit are incompatible. ${exports.swjs_library_version()} != ${
                    this.version
                }`
            );
        }
    }

    private ensureInstance() {
        if (!this.instance)
            throw new Error("WebAssembly instance is not set yet");
        return this.instance;
    }

    get memory() {
        return this.ensureInstance().exports.memory as ExportedMemory;
    }

    get exports() {
        return this.ensureInstance()
            .exports as any as SwiftRuntimeExportedFunctions;
    }

    get closureHeap(): SwiftClosureHeap | null {
        if (this._closureHeap) return this._closureHeap;

        const features = this.exports.swjs_library_features();
        const librarySupportsWeakRef =
            (features & LibraryFeatures.WeakRefs) != 0;
        if (librarySupportsWeakRef) {
            this._closureHeap = new SwiftClosureHeap(this.exports);
        }
        return this._closureHeap;
    }

    importObjects() {
        const callHostFunction = (host_func_id: number, args: any[]) => {
            const argc = args.length;
            const argv = this.exports.swjs_prepare_host_function_call(argc);
            for (let index = 0; index < args.length; index++) {
                const argument = args[index];
                const base = argv + 16 * index;
                writeValue(argument, base, base + 4, base + 8, false);
            }
            let output: any;
            const callback_func_ref = this.heap.retain(function (result: any) {
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
        };

        const textDecoder = new TextDecoder("utf-8");
        const textEncoder = new TextEncoder(); // Only support utf-8

        const readString = (ref: ref) => {
            return this.heap.referenceHeap(ref);
        };

        const writeString = (ptr: pointer, bytes: Uint8Array) => {
            const uint8Memory = new Uint8Array(this.memory.buffer);
            uint8Memory.set(bytes, ptr);
        };

        const readUInt32 = (ptr: pointer) => {
            const uint8Memory = new Uint8Array(this.memory.buffer);
            return (
                uint8Memory[ptr + 0] +
                (uint8Memory[ptr + 1] << 8) +
                (uint8Memory[ptr + 2] << 16) +
                (uint8Memory[ptr + 3] << 24)
            );
        };

        const readFloat64 = (ptr: pointer) => {
            const dataView = new DataView(this.memory.buffer);
            return dataView.getFloat64(ptr, true);
        };

        const writeUint32 = (ptr: pointer, value: number) => {
            const uint8Memory = new Uint8Array(this.memory.buffer);
            uint8Memory[ptr + 0] = (value & 0x000000ff) >> 0;
            uint8Memory[ptr + 1] = (value & 0x0000ff00) >> 8;
            uint8Memory[ptr + 2] = (value & 0x00ff0000) >> 16;
            uint8Memory[ptr + 3] = (value & 0xff000000) >> 24;
        };

        const writeFloat64 = (ptr: pointer, value: number) => {
            const dataView = new DataView(this.memory.buffer);
            dataView.setFloat64(ptr, value, true);
        };

        const decodeValue = (
            kind: JavaScriptValueKind,
            payload1: number,
            payload2: number
        ) => {
            switch (kind) {
                case JavaScriptValueKind.Boolean: {
                    switch (payload1) {
                        case 0:
                            return false;
                        case 1:
                            return true;
                    }
                }
                case JavaScriptValueKind.Number: {
                    return payload2;
                }
                case JavaScriptValueKind.String: {
                    return readString(payload1);
                }
                case JavaScriptValueKind.Object: {
                    return this.heap.referenceHeap(payload1);
                }
                case JavaScriptValueKind.Null: {
                    return null;
                }
                case JavaScriptValueKind.Undefined: {
                    return undefined;
                }
                case JavaScriptValueKind.Function: {
                    return this.heap.referenceHeap(payload1);
                }
                default:
                    throw new Error(`Type kind "${kind}" is not supported`);
            }
        };

        const writeValue = (
            value: any,
            kind_ptr: pointer,
            payload1_ptr: pointer,
            payload2_ptr: pointer,
            is_exception: boolean
        ) => {
            const exceptionBit = (is_exception ? 1 : 0) << 31;
            if (value === null) {
                writeUint32(kind_ptr, exceptionBit | JavaScriptValueKind.Null);
                return;
            }
            switch (typeof value) {
                case "boolean": {
                    writeUint32(
                        kind_ptr,
                        exceptionBit | JavaScriptValueKind.Boolean
                    );
                    writeUint32(payload1_ptr, value ? 1 : 0);
                    break;
                }
                case "number": {
                    writeUint32(
                        kind_ptr,
                        exceptionBit | JavaScriptValueKind.Number
                    );
                    writeFloat64(payload2_ptr, value);
                    break;
                }
                case "string": {
                    writeUint32(
                        kind_ptr,
                        exceptionBit | JavaScriptValueKind.String
                    );
                    writeUint32(payload1_ptr, this.heap.retain(value));
                    break;
                }
                case "undefined": {
                    writeUint32(
                        kind_ptr,
                        exceptionBit | JavaScriptValueKind.Undefined
                    );
                    break;
                }
                case "object": {
                    writeUint32(
                        kind_ptr,
                        exceptionBit | JavaScriptValueKind.Object
                    );
                    writeUint32(payload1_ptr, this.heap.retain(value));
                    break;
                }
                case "function": {
                    writeUint32(
                        kind_ptr,
                        exceptionBit | JavaScriptValueKind.Function
                    );
                    writeUint32(payload1_ptr, this.heap.retain(value));
                    break;
                }
                default:
                    throw new Error(
                        `Type "${typeof value}" is not supported yet`
                    );
            }
        };

        // Note:
        // `decodeValues` assumes that the size of RawJSValue is 16.
        const decodeValues = (ptr: pointer, length: number) => {
            let result = [];
            for (let index = 0; index < length; index++) {
                const base = ptr + 16 * index;
                const kind = readUInt32(base);
                const payload1 = readUInt32(base + 4);
                const payload2 = readFloat64(base + 8);
                result.push(decodeValue(kind, payload1, payload2));
            }
            return result;
        };

        return {
            swjs_set_prop: (
                ref: ref,
                name: ref,
                kind: JavaScriptValueKind,
                payload1: number,
                payload2: number
            ) => {
                const obj = this.heap.referenceHeap(ref);
                Reflect.set(
                    obj,
                    readString(name),
                    decodeValue(kind, payload1, payload2)
                );
            },

            swjs_get_prop: (
                ref: ref,
                name: ref,
                kind_ptr: pointer,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const result = Reflect.get(obj, readString(name));
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr, false);
            },

            swjs_set_subscript: (
                ref: ref,
                index: number,
                kind: JavaScriptValueKind,
                payload1: number,
                payload2: number
            ) => {
                const obj = this.heap.referenceHeap(ref);
                Reflect.set(obj, index, decodeValue(kind, payload1, payload2));
            },

            swjs_get_subscript: (
                ref: ref,
                index: number,
                kind_ptr: pointer,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const result = Reflect.get(obj, index);
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr, false);
            },

            swjs_encode_string: (ref: ref, bytes_ptr_result: pointer) => {
                const bytes = textEncoder.encode(this.heap.referenceHeap(ref));
                const bytes_ptr = this.heap.retain(bytes);
                writeUint32(bytes_ptr_result, bytes_ptr);
                return bytes.length;
            },

            swjs_decode_string: (bytes_ptr: pointer, length: number) => {
                const uint8Memory = new Uint8Array(this.memory.buffer);
                const bytes = uint8Memory.subarray(
                    bytes_ptr,
                    bytes_ptr + length
                );
                const string = textDecoder.decode(bytes);
                return this.heap.retain(string);
            },

            swjs_load_string: (ref: ref, buffer: pointer) => {
                const bytes = this.heap.referenceHeap(ref);
                writeString(buffer, bytes);
            },

            swjs_call_function: (
                ref: ref,
                argv: pointer,
                argc: number,
                kind_ptr: pointer,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const func = this.heap.referenceHeap(ref);
                let result: any;
                try {
                    result = Reflect.apply(
                        func,
                        undefined,
                        decodeValues(argv, argc)
                    );
                } catch (error) {
                    writeValue(
                        error,
                        kind_ptr,
                        payload1_ptr,
                        payload2_ptr,
                        true
                    );
                    return;
                }
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr, false);
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
                const obj = this.heap.referenceHeap(obj_ref);
                const func = this.heap.referenceHeap(func_ref);
                let result: any;
                try {
                    result = Reflect.apply(func, obj, decodeValues(argv, argc));
                } catch (error) {
                    writeValue(
                        error,
                        kind_ptr,
                        payload1_ptr,
                        payload2_ptr,
                        true
                    );
                    return;
                }
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr, false);
            },
            swjs_call_new: (ref: ref, argv: pointer, argc: number) => {
                const constructor = this.heap.referenceHeap(ref);
                const instance = Reflect.construct(
                    constructor,
                    decodeValues(argv, argc)
                );
                return this.heap.retain(instance);
            },

            swjs_call_throwing_new: (
                ref: ref,
                argv: pointer,
                argc: number,
                exception_kind_ptr: pointer,
                exception_payload1_ptr: pointer,
                exception_payload2_ptr: pointer
            ) => {
                const constructor = this.heap.referenceHeap(ref);
                let result: any;
                try {
                    result = Reflect.construct(
                        constructor,
                        decodeValues(argv, argc)
                    );
                } catch (error) {
                    writeValue(
                        error,
                        exception_kind_ptr,
                        exception_payload1_ptr,
                        exception_payload2_ptr,
                        true
                    );
                    return -1;
                }
                writeValue(
                    null,
                    exception_kind_ptr,
                    exception_payload1_ptr,
                    exception_payload2_ptr,
                    false
                );
                return this.heap.retain(result);
            },

            swjs_instanceof: (obj_ref: ref, constructor_ref: ref) => {
                const obj = this.heap.referenceHeap(obj_ref);
                const constructor = this.heap.referenceHeap(constructor_ref);
                return obj instanceof constructor;
            },

            swjs_create_function: (host_func_id: number) => {
                const func = function () {
                    return callHostFunction(
                        host_func_id,
                        Array.prototype.slice.call(arguments)
                    );
                };
                const func_ref = this.heap.retain(func);
                this.closureHeap?.alloc(func, func_ref);
                return func_ref;
            },

            swjs_create_typed_array: (
                constructor_ref: ref,
                elementsPtr: pointer,
                length: number
            ) => {
                const ArrayType: TypedArray =
                    this.heap.referenceHeap(constructor_ref);
                const array = new ArrayType(
                    this.memory.buffer,
                    elementsPtr,
                    length
                );
                // Call `.slice()` to copy the memory
                return this.heap.retain(array.slice());
            },

            swjs_release: (ref: ref) => {
                this.heap.release(ref);
            },
        };
    }
}
