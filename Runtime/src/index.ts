interface ExportedMemory {
    buffer: any;
}

type ref = number;
type pointer = number;

interface GlobalVariable {}
declare const window: GlobalVariable;
declare const global: GlobalVariable;
let globalVariable: any;
if (typeof globalThis !== "undefined") {
    globalVariable = globalThis;
} else if (typeof window !== "undefined") {
    globalVariable = window;
} else if (typeof global !== "undefined") {
    globalVariable = global;
} else if (typeof self !== "undefined") {
    globalVariable = self;
}

interface SwiftRuntimeExportedFunctions {
    swjs_library_version(): number;
    swjs_library_features(): number;
    swjs_prepare_host_function_call(size: number): pointer;
    swjs_cleanup_host_function_call(argv: pointer): void;
    swjs_call_host_function(
        host_func_id: number,
        argv: pointer,
        argc: number,
        callback_func_ref: ref
    ): void;

    swjs_free_host_function(host_func_id: number): void;
}

enum JavaScriptValueKind {
    Invalid = -1,
    Boolean = 0,
    String = 1,
    Number = 2,
    Object = 3,
    Null = 4,
    Undefined = 5,
    Function = 6,
}

enum LibraryFeatures {
    WeakRefs = 1 << 0,
}

type TypedArray =
    | Int8ArrayConstructor
    | Uint8ArrayConstructor
    | Int16ArrayConstructor
    | Uint16ArrayConstructor
    | Int32ArrayConstructor
    | Uint32ArrayConstructor
    // | BigInt64ArrayConstructor
    // | BigUint64ArrayConstructor
    | Float32ArrayConstructor
    | Float64ArrayConstructor;

type SwiftRuntimeHeapEntry = {
    id: number;
    rc: number;
};
class SwiftRuntimeHeap {
    private _heapValueById: Map<number, any>;
    private _heapEntryByValue: Map<any, SwiftRuntimeHeapEntry>;
    private _heapNextKey: number;

    constructor() {
        this._heapValueById = new Map();
        this._heapValueById.set(0, globalVariable);

        this._heapEntryByValue = new Map();
        this._heapEntryByValue.set(globalVariable, { id: 0, rc: 1 });

        // Note: 0 is preserved for global
        this._heapNextKey = 1;
    }

    retain(value: any) {
        const isObject = typeof value == "object";
        const entry = this._heapEntryByValue.get(value);
        if (isObject && entry) {
            entry.rc++;
            return entry.id;
        }
        const id = this._heapNextKey++;
        this._heapValueById.set(id, value);
        if (isObject) {
            this._heapEntryByValue.set(value, { id: id, rc: 1 });
        }
        return id;
    }

    release(ref: ref) {
        const value = this._heapValueById.get(ref);
        const isObject = typeof value == "object";
        if (isObject) {
            const entry = this._heapEntryByValue.get(value)!;
            entry.rc--;
            if (entry.rc != 0) return;

            this._heapEntryByValue.delete(value);
            this._heapValueById.delete(ref);
        } else {
            this._heapValueById.delete(ref);
        }
    }

    referenceHeap(ref: ref) {
        const value = this._heapValueById.get(ref);
        if (value === undefined) {
            throw new ReferenceError(
                "Attempted to read invalid reference " + ref
            );
        }
        return value;
    }
}

/// Memory lifetime of closures in Swift are managed by Swift side
class SwiftClosureHeap {
    private functionRegistry: FinalizationRegistry<number>;

    constructor(exports: SwiftRuntimeExportedFunctions) {
        this.functionRegistry = new FinalizationRegistry((id) => {
            exports.swjs_free_host_function(id);
        });
    }

    alloc(func: any, func_ref: number) {
        this.functionRegistry.register(func, func_ref);
    }
}

export class SwiftRuntime {
    private instance: WebAssembly.Instance | null;
    private heap: SwiftRuntimeHeap;
    private _closureHeap: SwiftClosureHeap | null;
    private version: number = 704;

    constructor() {
        this.instance = null;
        this.heap = new SwiftRuntimeHeap();
        this._closureHeap = null;
    }

    setInstance(instance: WebAssembly.Instance) {
        this.instance = instance;
        const exports = (this.instance
            .exports as any) as SwiftRuntimeExportedFunctions;
        if (exports.swjs_library_version() != this.version) {
            throw new Error(
                `The versions of JavaScriptKit are incompatible. ${exports.swjs_library_version()} != ${
                    this.version
                }`
            );
        }
    }
    get closureHeap(): SwiftClosureHeap | null {
        if (this._closureHeap) return this._closureHeap;
        if (!this.instance)
            throw new Error("WebAssembly instance is not set yet");

        const exports = (this.instance
            .exports as any) as SwiftRuntimeExportedFunctions;
        const features = exports.swjs_library_features();
        const librarySupportsWeakRef =
            (features & LibraryFeatures.WeakRefs) != 0;
        if (librarySupportsWeakRef) {
            if (typeof FinalizationRegistry !== "undefined") {
                this._closureHeap = new SwiftClosureHeap(exports);
                return this._closureHeap;
            } else {
                throw new Error(
                    "The Swift part of JavaScriptKit was configured to require the availability of JavaScript WeakRefs. Please build with `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` to disable features that use WeakRefs."
                );
            }
        }
        return null;
    }

    importObjects() {
        const memory = () => {
            if (this.instance)
                return this.instance.exports.memory as ExportedMemory;
            throw new Error("WebAssembly instance is not set yet");
        };

        const callHostFunction = (host_func_id: number, args: any[]) => {
            if (!this.instance)
                throw new Error("WebAssembly instance is not set yet");
            const exports = (this.instance
                .exports as any) as SwiftRuntimeExportedFunctions;
            const argc = args.length;
            const argv = exports.swjs_prepare_host_function_call(argc);
            for (let index = 0; index < args.length; index++) {
                const argument = args[index];
                const base = argv + 16 * index;
                writeValue(argument, base, base + 4, base + 8, false);
            }
            let output: any;
            const callback_func_ref = this.heap.retain(function (result: any) {
                output = result;
            });
            exports.swjs_call_host_function(
                host_func_id,
                argv,
                argc,
                callback_func_ref
            );
            exports.swjs_cleanup_host_function_call(argv);
            return output;
        };

        const textDecoder = new TextDecoder("utf-8");
        const textEncoder = new TextEncoder(); // Only support utf-8

        const readString = (ref: ref) => {
            return this.heap.referenceHeap(ref);
        };

        const writeBytes = (ptr: pointer, bytes: Uint8Array) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            uint8Memory.set(bytes, ptr);
        };

        const readUInt32 = (ptr: pointer) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return (
                uint8Memory[ptr + 0] +
                (uint8Memory[ptr + 1] << 8) +
                (uint8Memory[ptr + 2] << 16) +
                (uint8Memory[ptr + 3] << 24)
            );
        };

        const readFloat64 = (ptr: pointer) => {
            const dataView = new DataView(memory().buffer);
            return dataView.getFloat64(ptr, true);
        };

        const writeUint32 = (ptr: pointer, value: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            uint8Memory[ptr + 0] = (value & 0x000000ff) >> 0;
            uint8Memory[ptr + 1] = (value & 0x0000ff00) >> 8;
            uint8Memory[ptr + 2] = (value & 0x00ff0000) >> 16;
            uint8Memory[ptr + 3] = (value & 0xff000000) >> 24;
        };

        const writeFloat64 = (ptr: pointer, value: number) => {
            const dataView = new DataView(memory().buffer);
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
                const uint8Memory = new Uint8Array(memory().buffer);
                const bytes = uint8Memory.subarray(
                    bytes_ptr,
                    bytes_ptr + length
                );
                const string = textDecoder.decode(bytes);
                return this.heap.retain(string);
            },

            swjs_load_string: (ref: ref, buffer: pointer) => {
                const bytes = this.heap.referenceHeap(ref);
                writeBytes(buffer, bytes);
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
                const ArrayType: TypedArray = this.heap.referenceHeap(
                    constructor_ref
                );
                const array = new ArrayType(
                    memory().buffer,
                    elementsPtr,
                    length
                );
                // Call `.slice()` to copy the memory
                return this.heap.retain(array.slice());
            },

            swjs_load_typed_array: (ref: ref, buffer: pointer) => {
                const typedArray = this.heap.referenceHeap(ref);
                const bytes = new Uint8Array(typedArray.buffer);
                writeBytes(buffer, bytes);
            },

            swjs_release: (ref: ref) => {
                this.heap.release(ref);
            },
        };
    }
}
