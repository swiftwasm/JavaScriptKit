import { SwiftClosureDeallocator } from "./closure-heap.js";
import {
    LibraryFeatures,
    ExportedFunctions,
    ref,
    pointer,
    TypedArray,
    ImportedFunctions,
} from "./types.js";
import * as JSValue from "./js-value.js";
import { Memory } from "./memory.js";

export class SwiftRuntime {
    private _instance: WebAssembly.Instance | null;
    private _memory: Memory | null;
    private _closureDeallocator: SwiftClosureDeallocator | null;
    private version: number = 708;

    private textDecoder = new TextDecoder("utf-8");
    private textEncoder = new TextEncoder(); // Only support utf-8

    constructor() {
        this._instance = null;
        this._memory = null;
        this._closureDeallocator = null;
    }

    setInstance(instance: WebAssembly.Instance) {
        this._instance = instance;
        if (typeof (this.exports as any)._start === "function") {
            throw new Error(
                `JavaScriptKit supports only WASI reactor ABI.
                Please make sure you are building with:
                -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor
                `
            );
        }
        if (this.exports.swjs_library_version() != this.version) {
            throw new Error(
                `The versions of JavaScriptKit are incompatible.
                WebAssembly runtime ${this.exports.swjs_library_version()} != JS runtime ${
                    this.version
                }`
            );
        }
    }

    main() {
        const instance = this.instance;
        try {
            if (typeof instance.exports.main === "function") {
                instance.exports.main();
            } else if (
                typeof instance.exports.__main_argc_argv === "function"
            ) {
                // Swift 6.0 and later use `__main_argc_argv` instead of `main`.
                instance.exports.__main_argc_argv(0, 0);
            }
        } catch (error) {
            if (error instanceof UnsafeEventLoopYield) {
                // Ignore the error
                return;
            }
            // Rethrow other errors
            throw error;
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

    private callHostFunction(
        host_func_id: number,
        line: number,
        file: string,
        args: any[]
    ) {
        const argc = args.length;
        const argv = this.exports.swjs_prepare_host_function_call(argc);
        const memory = this.memory;
        for (let index = 0; index < args.length; index++) {
            const argument = args[index];
            const base = argv + 16 * index;
            JSValue.write(argument, base, base + 4, base + 8, false, memory);
        }
        let output: any;
        // This ref is released by the swjs_call_host_function implementation
        const callback_func_ref = memory.retain((result: any) => {
            output = result;
        });
        const alreadyReleased = this.exports.swjs_call_host_function(
            host_func_id,
            argv,
            argc,
            callback_func_ref
        );
        if (alreadyReleased) {
            throw new Error(
                `The JSClosure has been already released by Swift side. The closure is created at ${file}:${line}`
            );
        }
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
            const memory = this.memory;
            const obj = memory.getObject(ref);
            const key = memory.getObject(name);
            const value = JSValue.decode(kind, payload1, payload2, memory);
            obj[key] = value;
        },
        swjs_get_prop: (
            ref: ref,
            name: ref,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const memory = this.memory;
            const obj = memory.getObject(ref);
            const key = memory.getObject(name);
            const result = obj[key];
            return JSValue.writeAndReturnKindBits(
                result,
                payload1_ptr,
                payload2_ptr,
                false,
                memory
            );
        },

        swjs_set_subscript: (
            ref: ref,
            index: number,
            kind: JSValue.Kind,
            payload1: number,
            payload2: number
        ) => {
            const memory = this.memory;
            const obj = memory.getObject(ref);
            const value = JSValue.decode(kind, payload1, payload2, memory);
            obj[index] = value;
        },
        swjs_get_subscript: (
            ref: ref,
            index: number,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const obj = this.memory.getObject(ref);
            const result = obj[index];
            return JSValue.writeAndReturnKindBits(
                result,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },

        swjs_encode_string: (ref: ref, bytes_ptr_result: pointer) => {
            const memory = this.memory;
            const bytes = this.textEncoder.encode(memory.getObject(ref));
            const bytes_ptr = memory.retain(bytes);
            memory.writeUint32(bytes_ptr_result, bytes_ptr);
            return bytes.length;
        },
        swjs_decode_string: (bytes_ptr: pointer, length: number) => {
            const memory = this.memory;
            const bytes = memory
                .bytes()
                .subarray(bytes_ptr, bytes_ptr + length);
            const string = this.textDecoder.decode(bytes);
            return memory.retain(string);
        },
        swjs_load_string: (ref: ref, buffer: pointer) => {
            const memory = this.memory;
            const bytes = memory.getObject(ref);
            memory.writeBytes(buffer, bytes);
        },

        swjs_call_function: (
            ref: ref,
            argv: pointer,
            argc: number,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const memory = this.memory;
            const func = memory.getObject(ref);
            let result = undefined;
            try {
                const args = JSValue.decodeArray(argv, argc, memory);
                result = func(...args);
            } catch (error) {
                return JSValue.writeAndReturnKindBits(
                    error,
                    payload1_ptr,
                    payload2_ptr,
                    true,
                    this.memory
                );
            }
            return JSValue.writeAndReturnKindBits(
                result,
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
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const memory = this.memory;
            const func = memory.getObject(ref);
            const args = JSValue.decodeArray(argv, argc, memory);
            const result = func(...args);
            return JSValue.writeAndReturnKindBits(
                result,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },

        swjs_call_function_with_this: (
            obj_ref: ref,
            func_ref: ref,
            argv: pointer,
            argc: number,
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const memory = this.memory;
            const obj = memory.getObject(obj_ref);
            const func = memory.getObject(func_ref);
            let result: any;
            try {
                const args = JSValue.decodeArray(argv, argc, memory);
                result = func.apply(obj, args);
            } catch (error) {
                return JSValue.writeAndReturnKindBits(
                    error,
                    payload1_ptr,
                    payload2_ptr,
                    true,
                    this.memory
                );
            }
            return JSValue.writeAndReturnKindBits(
                result,
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
            payload1_ptr: pointer,
            payload2_ptr: pointer
        ) => {
            const memory = this.memory;
            const obj = memory.getObject(obj_ref);
            const func = memory.getObject(func_ref);
            let result = undefined;
            const args = JSValue.decodeArray(argv, argc, memory);
            result = func.apply(obj, args);
            return JSValue.writeAndReturnKindBits(
                result,
                payload1_ptr,
                payload2_ptr,
                false,
                this.memory
            );
        },

        swjs_call_new: (ref: ref, argv: pointer, argc: number) => {
            const memory = this.memory;
            const constructor = memory.getObject(ref);
            const args = JSValue.decodeArray(argv, argc, memory);
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
            let memory = this.memory;
            const constructor = memory.getObject(ref);
            let result: any;
            try {
                const args = JSValue.decodeArray(argv, argc, memory);
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
            memory = this.memory;
            JSValue.write(
                null,
                exception_kind_ptr,
                exception_payload1_ptr,
                exception_payload2_ptr,
                false,
                memory
            );
            return memory.retain(result);
        },

        swjs_instanceof: (obj_ref: ref, constructor_ref: ref) => {
            const memory = this.memory;
            const obj = memory.getObject(obj_ref);
            const constructor = memory.getObject(constructor_ref);
            return obj instanceof constructor;
        },

        swjs_create_function: (
            host_func_id: number,
            line: number,
            file: ref
        ) => {
            const fileString = this.memory.getObject(file) as string;
            const func = (...args: any[]) =>
                this.callHostFunction(host_func_id, line, fileString, args);
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
            const memory = this.memory;
            const typedArray = memory.getObject(ref);
            const bytes = new Uint8Array(typedArray.buffer);
            memory.writeBytes(buffer, bytes);
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
                if (object < BigInt(0)) {
                    return BigInt(0);
                }
                return BigInt.asIntN(64, object);
            }
        },
        swjs_i64_to_bigint_slow: (lower, upper, signed) => {
            const value =
                BigInt.asUintN(32, BigInt(lower)) +
                (BigInt.asUintN(32, BigInt(upper)) << BigInt(32));
            return this.memory.retain(
                signed ? BigInt.asIntN(64, value) : BigInt.asUintN(64, value)
            );
        },
        swjs_unsafe_event_loop_yield: () => {
            throw new UnsafeEventLoopYield();
        },
    };
}

/// This error is thrown when yielding event loop control from `swift_task_asyncMainDrainQueue`
/// to JavaScript. This is usually thrown when:
/// - The entry point of the Swift program is `func main() async`
/// - The Swift Concurrency's global executor is hooked by `JavaScriptEventLoop.installGlobalExecutor()`
/// - Calling exported `main` or `__main_argc_argv` function from JavaScript
///
/// This exception must be caught by the caller of the exported function and the caller should
/// catch this exception and just ignore it.
///
/// FAQ: Why this error is thrown?
/// This error is thrown to unwind the call stack of the Swift program and return the control to
/// the JavaScript side. Otherwise, the `swift_task_asyncMainDrainQueue` ends up with `abort()`
/// because the event loop expects `exit()` call before the end of the event loop.
class UnsafeEventLoopYield extends Error {}
