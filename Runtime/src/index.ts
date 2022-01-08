import { SwiftClosureHeap } from "./closure-heap";
import {
    LibraryFeatures,
    SwiftRuntimeExportedFunctions,
    ref,
    pointer,
    TypedArray,
} from "./types";
import {
    decodeJSValue,
    decodeJSValueArray,
    JavaScriptValueKind,
    writeJSValue,
} from "./js-value";
import { Memory } from "./memory";

export class SwiftRuntime {
    private _instance: WebAssembly.Instance | null;
    private _memory: Memory | null;
    private _closureHeap: SwiftClosureHeap | null;
    private version: number = 703;

    constructor() {
        this._instance = null;
        this._memory = null;
        this._closureHeap = null;
    }

    setInstance(instance: WebAssembly.Instance) {
        this._instance = instance;
        if (this.exports.swjs_library_version() != this.version) {
            throw new Error(
                `The versions of JavaScriptKit are incompatible. ${this.exports.swjs_library_version()} != ${
                    this.version
                }`
            );
        }
    }

    get instance() {
        if (!this._instance)
            throw new Error("WebAssembly instance is not set yet");
        return this._instance;
    }

    get exports() {
        return this.instance.exports as any as SwiftRuntimeExportedFunctions;
    }

    private get memory() {
        if (!this._memory) {
            this._memory = new Memory(this.instance.exports);
        }
        return this._memory;
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
                writeJSValue(
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
        };

        const textDecoder = new TextDecoder("utf-8");
        const textEncoder = new TextEncoder(); // Only support utf-8

        return {
            swjs_set_prop: (
                ref: ref,
                name: ref,
                kind: JavaScriptValueKind,
                payload1: number,
                payload2: number
            ) => {
                const obj = this.memory.getObject(ref);
                Reflect.set(
                    obj,
                    this.memory.getObject(name),
                    decodeJSValue(kind, payload1, payload2, this.memory)
                );
            },

            swjs_get_prop: (
                ref: ref,
                name: ref,
                kind_ptr: pointer,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const obj = this.memory.getObject(ref);
                const result = Reflect.get(obj, this.memory.getObject(name));
                writeJSValue(
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
                kind: JavaScriptValueKind,
                payload1: number,
                payload2: number
            ) => {
                const obj = this.memory.getObject(ref);
                Reflect.set(
                    obj,
                    index,
                    decodeJSValue(kind, payload1, payload2, this.memory)
                );
            },

            swjs_get_subscript: (
                ref: ref,
                index: number,
                kind_ptr: pointer,
                payload1_ptr: pointer,
                payload2_ptr: pointer
            ) => {
                const obj = this.memory.getObject(ref);
                const result = Reflect.get(obj, index);
                writeJSValue(
                    result,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },

            swjs_encode_string: (ref: ref, bytes_ptr_result: pointer) => {
                const bytes = textEncoder.encode(this.memory.getObject(ref));
                const bytes_ptr = this.memory.retain(bytes);
                this.memory.writeUint32(bytes_ptr_result, bytes_ptr);
                return bytes.length;
            },

            swjs_decode_string: (bytes_ptr: pointer, length: number) => {
                const bytes = this.memory.bytes.subarray(
                    bytes_ptr,
                    bytes_ptr + length
                );
                const string = textDecoder.decode(bytes);
                return this.memory.retain(string);
            },

            swjs_load_string: (ref: ref, buffer: pointer) => {
                const bytes = this.memory.getObject(ref);
                this.memory.writeBytes(buffer, bytes);
            },

            _swjs_call_function: (
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
                    result = Reflect.apply(
                        func,
                        undefined,
                        decodeJSValueArray(argv, argc, this.memory)
                    );
                } catch (error) {
                    writeJSValue(
                        error,
                        kind_ptr,
                        payload1_ptr,
                        payload2_ptr,
                        true,
                        this.memory
                    );
                    return;
                }
                writeJSValue(
                    result,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },
            get swjs_call_function() {
                return this._swjs_call_function;
            },
            set swjs_call_function(value) {
                this._swjs_call_function = value;
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
                    result = Reflect.apply(
                        func,
                        obj,
                        decodeJSValueArray(argv, argc, this.memory)
                    );
                } catch (error) {
                    writeJSValue(
                        error,
                        kind_ptr,
                        payload1_ptr,
                        payload2_ptr,
                        true,
                        this.memory
                    );
                    return;
                }
                writeJSValue(
                    result,
                    kind_ptr,
                    payload1_ptr,
                    payload2_ptr,
                    false,
                    this.memory
                );
            },
            swjs_call_new: (ref: ref, argv: pointer, argc: number) => {
                const constructor = this.memory.getObject(ref);
                const instance = Reflect.construct(
                    constructor,
                    decodeJSValueArray(argv, argc, this.memory)
                );
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
                    result = Reflect.construct(
                        constructor,
                        decodeJSValueArray(argv, argc, this.memory)
                    );
                } catch (error) {
                    writeJSValue(
                        error,
                        exception_kind_ptr,
                        exception_payload1_ptr,
                        exception_payload2_ptr,
                        true,
                        this.memory
                    );
                    return -1;
                }
                writeJSValue(
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
                const func = function () {
                    return callHostFunction(
                        host_func_id,
                        Array.prototype.slice.call(arguments)
                    );
                };
                const func_ref = this.memory.retain(func);
                this.closureHeap?.alloc(func, func_ref);
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

            swjs_release: (ref: ref) => {
                this.memory.release(ref);
            },
        };
    }
}
