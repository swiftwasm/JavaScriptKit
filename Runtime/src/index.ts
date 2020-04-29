interface ExportedMemory {
    buffer: any
}

type ref = number;
type pointer = number;

interface GlobalVariable { }
declare const window: GlobalVariable;
declare const global: GlobalVariable;

interface SwiftRuntimeExportedFunctions {
    swjs_prepare_host_function_call(size: number): pointer;
    swjs_cleanup_host_function_call(argv: pointer): void;
    swjs_call_host_function(
        host_func_id: number,
        argv: pointer, argc: number,
        callback_func_ref: ref
    ): void;
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

class SwiftRuntimeHeap {
    private _heapValues: Map<number, any>;
    private _heapNextKey: number;

    constructor() {
        let _global: any;
        if (typeof window !== "undefined") {
            _global = window
        } else if (typeof global !== "undefined") {
            _global = global
        }
        this._heapValues = new Map();
        this._heapValues.set(0, _global);
        // Note: 0 is preserved for global
        this._heapNextKey = 1;
    }

    allocHeap(value: any) {
        const isObject = typeof value == "object"
        if (isObject && value.swjs_heap_id) {
            return value.swjs_heap_id
        }
        const id = this._heapNextKey++;
        this._heapValues.set(id, value)
        if (isObject)
            Reflect.set(value, "swjs_heap_id", id);
        return id
    }

    freeHeap(ref: ref) {
        const value = this._heapValues.get(ref);
        const isObject = typeof value == "object"
        if (isObject && value.swjs_heap_id) {
            delete value.swjs_heap_id;
        }
        this._heapValues.delete(ref)
    }

    referenceHeap(ref: ref) {
        return this._heapValues.get(ref)
    }
}

export class SwiftRuntime {
    private instance: WebAssembly.Instance | null;
    private heap: SwiftRuntimeHeap

    constructor() {
        this.instance = null;
        this.heap = new SwiftRuntimeHeap();
    }

    setInsance(instance: WebAssembly.Instance) {
        this.instance = instance
    }

    importObjects() {
        const memory = () => {
            if (this.instance)
                return this.instance.exports.memory as ExportedMemory;
            throw new Error("WebAssembly instance is not set yet");
        }


        const callHostFunction = (host_func_id: number, args: any[]) => {
            if (!this.instance)
                throw new Error("WebAssembly instance is not set yet");
            const exports = this.instance.exports as any as SwiftRuntimeExportedFunctions;
            const argc = args.length
            const argv = exports.swjs_prepare_host_function_call(argc)
            for (let index = 0; index < args.length; index++) {
                const argument = args[index]
                const base = argv + 16 * index
                writeValue(argument, base, base + 4, base + 12)
            }
            let output: any;
            const callback_func_ref = this.heap.allocHeap(function (result: any) {
                output = result
            })
            exports.swjs_call_host_function(host_func_id, argv, argc, callback_func_ref)
            exports.swjs_cleanup_host_function_call(argv)
            return output
        }

        const textDecoder = new TextDecoder('utf-8');
        const textEncoder = new TextEncoder(); // Only support utf-8

        const readString = (ptr: pointer, len: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return textDecoder.decode(uint8Memory.subarray(ptr, ptr + len));
        }

        const writeString = (ptr: pointer, value: string) => {
            const bytes = textEncoder.encode(value);
            const uint8Memory = new Uint8Array(memory().buffer);
            for (const [index, byte] of bytes.entries()) {
                uint8Memory[ptr + index] = byte
            }
            uint8Memory[ptr]
        }

        const readUInt32 = (ptr: pointer) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return uint8Memory[ptr + 0]
                + (uint8Memory[ptr + 1] << 8)
                + (uint8Memory[ptr + 2] << 16)
                + (uint8Memory[ptr + 3] << 24)
        }

        const readFloat64 = (ptr: pointer) => {
            const dataView = new DataView(memory().buffer);
            return dataView.getFloat64(ptr, true);
        }

        const writeUint32 = (ptr: pointer, value: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            uint8Memory[ptr + 0] = (value & 0x000000ff) >> 0
            uint8Memory[ptr + 1] = (value & 0x0000ff00) >> 8
            uint8Memory[ptr + 2] = (value & 0x00ff0000) >> 16
            uint8Memory[ptr + 3] = (value & 0xff000000) >> 24
        }

        const writeFloat64 = (ptr: pointer, value: number) => {
            const dataView = new DataView(memory().buffer);
            dataView.setFloat64(ptr, value, true);
        }

        const decodeValue = (
            kind: JavaScriptValueKind,
            payload1_ptr: pointer, payload2_ptr: pointer
        ) => {
            switch (kind) {
                case JavaScriptValueKind.Boolean: {
                    switch (readUInt32(payload1_ptr)) {
                        case 0: return false
                        case 1: return true
                    }
                }
                case JavaScriptValueKind.Number: {
                    return readFloat64(payload1_ptr);
                }
                case JavaScriptValueKind.String: {
                    return readString(readUInt32(payload1_ptr), readUInt32(payload2_ptr))
                }
                case JavaScriptValueKind.Object: {
                    return this.heap.referenceHeap(readUInt32(payload1_ptr))
                }
                case JavaScriptValueKind.Null: {
                    return null
                }
                case JavaScriptValueKind.Undefined: {
                    return undefined
                }
                case JavaScriptValueKind.Function: {
                    return this.heap.referenceHeap(readUInt32(payload1_ptr))
                }
                default:
                    throw new Error(`Type kind "${kind}" is not supported`)
            }
        }

        const writeValue = (
            value: any, kind_ptr: pointer,
            payload1_ptr: pointer, payload2_ptr: pointer
        ) => {
            if (value === null) {
                writeUint32(kind_ptr, JavaScriptValueKind.Null);
                writeUint32(payload1_ptr, 0);
                writeUint32(payload2_ptr, 0);
            }
            switch (typeof value) {
                case "boolean": {
                    writeUint32(kind_ptr, JavaScriptValueKind.Boolean);
                    writeUint32(payload1_ptr, value ? 1 : 0);
                    writeUint32(payload2_ptr, 0);
                    break;
                }
                case "number": {
                    writeUint32(kind_ptr, JavaScriptValueKind.Number);
                    writeFloat64(payload1_ptr, value);
                    writeUint32(payload2_ptr, 0);
                    break;
                }
                case "string": {
                    // FIXME: currently encode twice
                    const bytes = textEncoder.encode(value);
                    writeUint32(kind_ptr, JavaScriptValueKind.String);
                    writeUint32(payload1_ptr, this.heap.allocHeap(value));
                    writeUint32(payload2_ptr, bytes.length);
                    break;
                }
                case "undefined": {
                    writeUint32(kind_ptr, JavaScriptValueKind.Undefined);
                    writeUint32(payload1_ptr, 0);
                    writeUint32(payload2_ptr, 0);
                    break;
                }
                case "object": {
                    writeUint32(kind_ptr, JavaScriptValueKind.Object);
                    writeUint32(payload1_ptr, this.heap.allocHeap(value));
                    writeUint32(payload2_ptr, 0);
                    break;
                }
                case "function": {
                    writeUint32(kind_ptr, JavaScriptValueKind.Function);
                    writeUint32(payload1_ptr, this.heap.allocHeap(value));
                    writeUint32(payload2_ptr, 0);
                    break;
                }
                default:
                    throw new Error(`Type "${typeof value}" is not supported yet`)
            }
        }

        // Note:
        // `decodeValues` assumes that the size of RawJSValue is 16
        // and the alignment of it is 4
        const decodeValues = (ptr: pointer, length: number) => {
            let result = []
            for (let index = 0; index < length; index++) {
                const base = ptr + 16 * index
                const kind = readUInt32(base)
                const payload1 = readFloat64(base + 4)
                const payload2 = readUInt32(base + 12)
                result.push(decodeValue(kind, payload1, payload2))
            }
            return result
        }

        return {
            swjs_set_prop: (
                ref: ref, name: pointer, length: number,
                kind: JavaScriptValueKind,
                payload1: number, payload2: number
            ) => {
                const obj = this.heap.referenceHeap(ref);
                Reflect.set(obj, readString(name, length), decodeValue(kind, payload1, payload2))
            },
            swjs_get_prop: (
                ref: ref, name: pointer, length: number,
                kind_ptr: pointer,
                payload1_ptr: pointer, payload2_ptr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const result = Reflect.get(obj, readString(name, length));
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr);
            },
            swjs_set_subscript: (
                ref: ref, index: number,
                kind: JavaScriptValueKind,
                payload1: number, payload2: number
            ) => {
                const obj = this.heap.referenceHeap(ref);
                Reflect.set(obj, index, decodeValue(kind, payload1, payload2))
            },
            swjs_get_subscript: (
                ref: ref, index: number,
                kind_ptr: pointer,
                payload1_ptr: pointer, payload2_ptr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const result = Reflect.get(obj, index);
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr);
            },
            swjs_load_string: (ref: ref, buffer: pointer) => {
                const string = this.heap.referenceHeap(ref);
                writeString(buffer, string);
            },
            swjs_call_function: (
                ref: ref, argv: pointer, argc: number,
                kind_ptr: pointer,
                payload1_ptr: pointer, payload2_ptr: pointer
            ) => {
                const func = this.heap.referenceHeap(ref)
                const result = Reflect.apply(func, undefined, decodeValues(argv, argc))
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr);
            },
            swjs_call_function_with_this: (
                obj_ref: ref, func_ref: ref,
                argv: pointer, argc: number,
                kind_ptr: pointer,
                payload1_ptr: pointer, payload2_ptr: pointer
            ) => {
                const obj = this.heap.referenceHeap(obj_ref)
                const func = this.heap.referenceHeap(func_ref)
                const result = Reflect.apply(func, obj, decodeValues(argv, argc))
                writeValue(result, kind_ptr, payload1_ptr, payload2_ptr);
            },
            swjs_create_function: (
                host_func_id: number,
                func_ref_ptr: pointer,
            ) => {
                const func_ref = this.heap.allocHeap(function () {
                    return callHostFunction(host_func_id, Array.prototype.slice.call(arguments))
                })
                writeUint32(func_ref_ptr, func_ref)
            },
            swjs_call_new: (
                ref: ref, argv: pointer, argc: number,
                result_obj: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref)
                const result = Reflect.construct(obj, decodeValues(argv, argc))
                if (typeof result != "object")
                    throw Error(`Invalid result type of object constructor of "${obj}": "${result}"`)
                writeUint32(result_obj, this.heap.allocHeap(result));
            },
            swjs_destroy_ref: (ref: ref) => {
                this.heap.freeHeap(ref)
            }
        }
    }
}