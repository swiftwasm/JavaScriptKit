interface ExportedMemory {
    buffer: any
}

type ref = number;
type pointer = number;

interface GlobalVariable { }
declare const window: GlobalVariable;
declare const global: GlobalVariable;

interface SwiftRuntimeExportedFunctions {
    swjs_library_version(): number;
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

type SwiftRuntimeHeapEntry = {
    id: number,
    rc: number,
}
class SwiftRuntimeHeap {
    private _heapValueById: Map<number, any>;
    private _heapEntryByValue: Map<any, SwiftRuntimeHeapEntry>;
    private _heapNextKey: number;

    constructor() {
        let _global: any;
        if (typeof window !== "undefined") {
            _global = window
        } else if (typeof global !== "undefined") {
            _global = global
        }
        this._heapValueById = new Map();
        this._heapValueById.set(0, _global);

        this._heapEntryByValue = new Map();
        this._heapEntryByValue.set(_global, { id: 0, rc: 1 });

        // Note: 0 is preserved for global
        this._heapNextKey = 1;
    }

    allocHeap(value: any) {
        const isObject = typeof value == "object";
        const entry = this._heapEntryByValue.get(value);
        if (isObject && entry) {
            entry.rc++
            return entry.id
        }
        const id = this._heapNextKey++;
        this._heapValueById.set(id, value)
        if (isObject) {
            this._heapEntryByValue.set(value, { id: id, rc: 1 })
        }
        return id
    }

    freeHeap(ref: ref) {
        const value = this._heapValueById.get(ref);
        const isObject = typeof value == "object"
        if (isObject) {
            const entry = this._heapEntryByValue.get(value)!;
            entry.rc--;
            if (entry.rc != 0) return;

            this._heapEntryByValue.delete(value);
            this._heapValueById.delete(ref)
        } else {
            this._heapValueById.delete(ref)
        }
    }

    referenceHeap(ref: ref) {
        return this._heapValueById.get(ref)
    }
}

export class SwiftRuntime {
    private instance: WebAssembly.Instance | null;
    private heap: SwiftRuntimeHeap
    private version: number = 400

    constructor() {
        this.instance = null;
        this.heap = new SwiftRuntimeHeap();
    }

    setInstance(instance: WebAssembly.Instance) {
        this.instance = instance
        const exports = this.instance.exports as any as SwiftRuntimeExportedFunctions;
        if (exports.swjs_library_version() != this.version) {
          throw new Error("The versions of JavaScriptKit are incompatible.")
        }
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
            const uint32Memory = new Uint32Array(memory().buffer, argv, args.length * 3);
            for (let index = 0; index < args.length; index++) {
                const argument = args[index];
                const offset = 12 * index;
                const dataView = new DataView(memory().buffer, argv + offset, 12);
                encodeValue(argument, dataView);
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
            const uint8Memory = new Uint8Array(memory().buffer, ptr, len);
            return textDecoder.decode(uint8Memory);
        }

        const writeString = (ptr: pointer, bytes: Uint8Array) => {
            const uint8Memory = new Uint8Array(memory().buffer, ptr);
            for (const [index, byte] of bytes.entries()) {
                uint8Memory[index] = byte
            }
        }

        const readUInt32 = (ptr: pointer) => {
            const uint32Memory = new Uint32Array(memory().buffer, ptr);
            return uint32Memory[0];
        }

        const readFloat64 = (ptr: pointer) => {
            const dataView = new DataView(memory().buffer);
            return dataView.getFloat64(ptr, true);
        }

        const writeUint32 = (ptr: pointer, value: number) => {
            const uint32Memory = new Uint32Array(memory().buffer, ptr);
            uint32Memory[0] = (value & 0xffffffff);
        }

        const writeFloat64 = (ptr: pointer, value: number) => {
            const dataView = new DataView(memory().buffer);
            dataView.setFloat64(ptr, value, true);
        }

        const decodeValue = (
              dataView: DataView
                ) => {
                const kind = dataView.getUint32(0, true)
                switch (kind) {
                        case JavaScriptValueKind.Boolean: {
                            switch (dataView.getUint32(Uint32Array.BYTES_PER_ELEMENT, true)) {
                                case 0: return false
                                case 1: return true
                            }
                        }
                        case JavaScriptValueKind.Number: {
                            return dataView.getFloat64(Uint32Array.BYTES_PER_ELEMENT, true);
                        }
                        case JavaScriptValueKind.String: {
                            return readString(dataView.getUint32(Uint32Array.BYTES_PER_ELEMENT, true),
                                              dataView.getUint32(2 * Uint32Array.BYTES_PER_ELEMENT, true))
                        }
                        case JavaScriptValueKind.Object: {
                            return this.heap.referenceHeap(dataView.getUint32(Uint32Array.BYTES_PER_ELEMENT, true))
                        }
                        case JavaScriptValueKind.Null: {
                            return null
                        }
                        case JavaScriptValueKind.Undefined: {
                            return undefined
                        }
                        case JavaScriptValueKind.Function: {
                            return this.heap.referenceHeap(dataView.getUint32(Uint32Array.BYTES_PER_ELEMENT, true))
                        }
                        default:
                            throw new Error(`Type kind "${kind}" is not supported`)
                    }
                }

        const encodeValue = (value: any, dataView: DataView) => {
            if (value === null) {
                dataView.setUint32(0, JavaScriptValueKind.Null, true);
                dataView.setUint32(Uint32Array.BYTES_PER_ELEMENT, 0, true);
                dataView.setUint32(2 * Uint32Array.BYTES_PER_ELEMENT, 0, true);
                return;
            }
            switch (typeof value) {
                case "boolean": {
                    dataView.setUint32(0, JavaScriptValueKind.Boolean, true);
                    dataView.setUint32(Uint32Array.BYTES_PER_ELEMENT, value ? 1 : 0, true);
                    dataView.setUint32(2 * Uint32Array.BYTES_PER_ELEMENT, 0, true);
                    break;
                }
                case "number": {
                    dataView.setUint32(0, JavaScriptValueKind.Number, true);
                    dataView.setFloat64(Uint32Array.BYTES_PER_ELEMENT, value, true);
                    break;
                }
                case "string": {
                    const bytes = textEncoder.encode(value);
                    dataView.setUint32(0, JavaScriptValueKind.String, true);
                    dataView.setUint32(Uint32Array.BYTES_PER_ELEMENT, this.heap.allocHeap(value), true);
                    dataView.setUint32(2 * Uint32Array.BYTES_PER_ELEMENT, bytes.length, true);
                    break;
                }
                case "undefined": {
                    dataView.setUint32(0, JavaScriptValueKind.Undefined, true);
                    dataView.setUint32(Uint32Array.BYTES_PER_ELEMENT, 0, true);
                    dataView.setUint32(2 * Uint32Array.BYTES_PER_ELEMENT, 0, true);
                    break;
                }
                case "object": {
                    dataView.setUint32(0, JavaScriptValueKind.Object, true);
                    dataView.setUint32(Uint32Array.BYTES_PER_ELEMENT, this.heap.allocHeap(value), true);
                    dataView.setUint32(2 * Uint32Array.BYTES_PER_ELEMENT, 0, true);
                    break;
                }
                case "function": {
                    dataView.setUint32(0, JavaScriptValueKind.Function, true);
                    dataView.setUint32(Uint32Array.BYTES_PER_ELEMENT, this.heap.allocHeap(value), true);
                    dataView.setUint32(2 * Uint32Array.BYTES_PER_ELEMENT, 0, true);

                    break;
                }
                default:
                    throw new Error(`Type "${typeof value}" is not supported yet`)
            }
        }

        // Note:
        // `decodeValues` assumes that the size of RawJSValue is 12
        // and the alignment of it is 8
        const decodeValues = (ptr: pointer, length: number) => {
            let result = []
            for (let index = 0; index < length; index++) {
                const offset = 12 * index;
                const dataView = new DataView(memory().buffer, ptr + offset, 12);
                result.push(decodeValue(dataView))
            }
            return result
        }

        return {
            swjs_set_prop: (
                ref: ref, name: pointer, length: number,
                rawJSValuePtr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                Reflect.set(obj, readString(name, length), decodeValue(dataView))
            },
            swjs_get_prop: (
                ref: ref, name: pointer, length: number,
                rawJSValuePtr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const result = Reflect.get(obj, readString(name, length));
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                encodeValue(result, dataView);
            },
            swjs_set_subscript: (
                ref: ref, index: number,
                rawJSValuePtr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                Reflect.set(obj, index, decodeValue(dataView))
            },
            swjs_get_subscript: (
                ref: ref, index: number,
                rawJSValuePtr: pointer
            ) => {
                const obj = this.heap.referenceHeap(ref);
                const result = Reflect.get(obj, index);
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                encodeValue(result, dataView);
            },
            swjs_load_string: (ref: ref, buffer: pointer) => {
                const bytes = this.heap.referenceHeap(ref);
                writeString(buffer, bytes);
            },
            swjs_call_function: (
                ref: ref, argv: pointer, argc: number,
                rawJSValuePtr: pointer
            ) => {
                const func = this.heap.referenceHeap(ref)
                const result = Reflect.apply(func, undefined, decodeValues(argv, argc))
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                encodeValue(result, dataView);
            },
            swjs_call_function_with_this: (
                obj_ref: ref, func_ref: ref,
                argv: pointer, argc: number,
                rawJSValuePtr: pointer
            ) => {
                const obj = this.heap.referenceHeap(obj_ref)
                const func = this.heap.referenceHeap(func_ref)
                const result = Reflect.apply(func, obj, decodeValues(argv, argc))
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                encodeValue(result, dataView);
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
            },
            swjs_instance_of: (
                ref: ref, name: pointer, length: number,
                rawJSValuePtr: pointer) => {

                const obj = this.heap.referenceHeap(ref)
                const cName = readString(name, length)
                const result = (cName in window) && (obj instanceof (window as any)[cName])
                const dataView = new DataView(memory().buffer, rawJSValuePtr, 12);
                encodeValue(result, dataView);
            },
            swjs_copy_typed_array_content: (
                ref: ref, elementsPtr: pointer, length: number) => {

                const obj = this.heap.referenceHeap(ref)
                const view = new obj.constructor(memory().buffer, elementsPtr, length);
                view.forEach(function(value: number, index: number, array: any){
                    obj[index] = value;
                });
            }
        }
    }
}
