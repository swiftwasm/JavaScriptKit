/// Memory lifetime of closures in Swift are managed by Swift side
class SwiftClosureDeallocator {
    constructor(exports) {
        if (typeof FinalizationRegistry === "undefined") {
            throw new Error("The Swift part of JavaScriptKit was configured to require " +
                "the availability of JavaScript WeakRefs. Please build " +
                "with `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` to " +
                "disable features that use WeakRefs.");
        }
        this.functionRegistry = new FinalizationRegistry((id) => {
            exports.swjs_free_host_function(id);
        });
    }
    track(func, func_ref) {
        this.functionRegistry.register(func, func_ref);
    }
}

function assertNever(x, message) {
    throw new Error(message);
}

const decode = (kind, payload1, payload2, memory) => {
    switch (kind) {
        case 0 /* Boolean */:
            switch (payload1) {
                case 0:
                    return false;
                case 1:
                    return true;
            }
        case 2 /* Number */:
            return payload2;
        case 1 /* String */:
        case 3 /* Object */:
        case 6 /* Function */:
        case 7 /* Symbol */:
        case 8 /* BigInt */:
            return memory.getObject(payload1);
        case 4 /* Null */:
            return null;
        case 5 /* Undefined */:
            return undefined;
        default:
            assertNever(kind, `JSValue Type kind "${kind}" is not supported`);
    }
};
// Note:
// `decodeValues` assumes that the size of RawJSValue is 16.
const decodeArray = (ptr, length, memory) => {
    // fast path for empty array
    if (length === 0) {
        return [];
    }
    let result = [];
    // It's safe to hold DataView here because WebAssembly.Memory.buffer won't
    // change within this function.
    const view = memory.dataView();
    for (let index = 0; index < length; index++) {
        const base = ptr + 16 * index;
        const kind = view.getUint32(base, true);
        const payload1 = view.getUint32(base + 4, true);
        const payload2 = view.getFloat64(base + 8, true);
        result.push(decode(kind, payload1, payload2, memory));
    }
    return result;
};
// A helper function to encode a RawJSValue into a pointers.
// Please prefer to use `writeAndReturnKindBits` to avoid unnecessary
// memory stores.
// This function should be used only when kind flag is stored in memory.
const write = (value, kind_ptr, payload1_ptr, payload2_ptr, is_exception, memory) => {
    const kind = writeAndReturnKindBits(value, payload1_ptr, payload2_ptr, is_exception, memory);
    memory.writeUint32(kind_ptr, kind);
};
const writeAndReturnKindBits = (value, payload1_ptr, payload2_ptr, is_exception, memory) => {
    const exceptionBit = (is_exception ? 1 : 0) << 31;
    if (value === null) {
        return exceptionBit | 4 /* Null */;
    }
    const writeRef = (kind) => {
        memory.writeUint32(payload1_ptr, memory.retain(value));
        return exceptionBit | kind;
    };
    const type = typeof value;
    switch (type) {
        case "boolean": {
            memory.writeUint32(payload1_ptr, value ? 1 : 0);
            return exceptionBit | 0 /* Boolean */;
        }
        case "number": {
            memory.writeFloat64(payload2_ptr, value);
            return exceptionBit | 2 /* Number */;
        }
        case "string": {
            return writeRef(1 /* String */);
        }
        case "undefined": {
            return exceptionBit | 5 /* Undefined */;
        }
        case "object": {
            return writeRef(3 /* Object */);
        }
        case "function": {
            return writeRef(6 /* Function */);
        }
        case "symbol": {
            return writeRef(7 /* Symbol */);
        }
        case "bigint": {
            return writeRef(8 /* BigInt */);
        }
        default:
            assertNever(type, `Type "${type}" is not supported yet`);
    }
    throw new Error("Unreachable");
};

let globalVariable;
if (typeof globalThis !== "undefined") {
    globalVariable = globalThis;
}
else if (typeof window !== "undefined") {
    globalVariable = window;
}
else if (typeof global !== "undefined") {
    globalVariable = global;
}
else if (typeof self !== "undefined") {
    globalVariable = self;
}

class SwiftRuntimeHeap {
    constructor() {
        this._heapValueById = new Map();
        this._heapValueById.set(0, globalVariable);
        this._heapEntryByValue = new Map();
        this._heapEntryByValue.set(globalVariable, { id: 0, rc: 1 });
        // Note: 0 is preserved for global
        this._heapNextKey = 1;
    }
    retain(value) {
        const entry = this._heapEntryByValue.get(value);
        if (entry) {
            entry.rc++;
            return entry.id;
        }
        const id = this._heapNextKey++;
        this._heapValueById.set(id, value);
        this._heapEntryByValue.set(value, { id: id, rc: 1 });
        return id;
    }
    release(ref) {
        const value = this._heapValueById.get(ref);
        const entry = this._heapEntryByValue.get(value);
        entry.rc--;
        if (entry.rc != 0)
            return;
        this._heapEntryByValue.delete(value);
        this._heapValueById.delete(ref);
    }
    referenceHeap(ref) {
        const value = this._heapValueById.get(ref);
        if (value === undefined) {
            throw new ReferenceError("Attempted to read invalid reference " + ref);
        }
        return value;
    }
}

class Memory {
    constructor(exports) {
        this.heap = new SwiftRuntimeHeap();
        this.retain = (value) => this.heap.retain(value);
        this.getObject = (ref) => this.heap.referenceHeap(ref);
        this.release = (ref) => this.heap.release(ref);
        this.bytes = () => new Uint8Array(this.rawMemory.buffer);
        this.dataView = () => new DataView(this.rawMemory.buffer);
        this.writeBytes = (ptr, bytes) => this.bytes().set(bytes, ptr);
        this.readUint32 = (ptr) => this.dataView().getUint32(ptr, true);
        this.readUint64 = (ptr) => this.dataView().getBigUint64(ptr, true);
        this.readInt64 = (ptr) => this.dataView().getBigInt64(ptr, true);
        this.readFloat64 = (ptr) => this.dataView().getFloat64(ptr, true);
        this.writeUint32 = (ptr, value) => this.dataView().setUint32(ptr, value, true);
        this.writeUint64 = (ptr, value) => this.dataView().setBigUint64(ptr, value, true);
        this.writeInt64 = (ptr, value) => this.dataView().setBigInt64(ptr, value, true);
        this.writeFloat64 = (ptr, value) => this.dataView().setFloat64(ptr, value, true);
        this.rawMemory = exports.memory;
    }
}

class SwiftRuntime {
    constructor() {
        this.version = 708;
        this.textDecoder = new TextDecoder("utf-8");
        this.textEncoder = new TextEncoder(); // Only support utf-8
        /** @deprecated Use `wasmImports` instead */
        this.importObjects = () => this.wasmImports;
        this.wasmImports = {
            swjs_set_prop: (ref, name, kind, payload1, payload2) => {
                const memory = this.memory;
                const obj = memory.getObject(ref);
                const key = memory.getObject(name);
                const value = decode(kind, payload1, payload2, memory);
                obj[key] = value;
            },
            swjs_get_prop: (ref, name, payload1_ptr, payload2_ptr) => {
                const memory = this.memory;
                const obj = memory.getObject(ref);
                const key = memory.getObject(name);
                const result = obj[key];
                return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, memory);
            },
            swjs_set_subscript: (ref, index, kind, payload1, payload2) => {
                const memory = this.memory;
                const obj = memory.getObject(ref);
                const value = decode(kind, payload1, payload2, memory);
                obj[index] = value;
            },
            swjs_get_subscript: (ref, index, payload1_ptr, payload2_ptr) => {
                const obj = this.memory.getObject(ref);
                const result = obj[index];
                return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
            },
            swjs_encode_string: (ref, bytes_ptr_result) => {
                const memory = this.memory;
                const bytes = this.textEncoder.encode(memory.getObject(ref));
                const bytes_ptr = memory.retain(bytes);
                memory.writeUint32(bytes_ptr_result, bytes_ptr);
                return bytes.length;
            },
            swjs_decode_string: (bytes_ptr, length) => {
                const memory = this.memory;
                const bytes = memory
                    .bytes()
                    .subarray(bytes_ptr, bytes_ptr + length);
                const string = this.textDecoder.decode(bytes);
                return memory.retain(string);
            },
            swjs_load_string: (ref, buffer) => {
                const memory = this.memory;
                const bytes = memory.getObject(ref);
                memory.writeBytes(buffer, bytes);
            },
            swjs_call_function: (ref, argv, argc, payload1_ptr, payload2_ptr) => {
                const memory = this.memory;
                const func = memory.getObject(ref);
                let result = undefined;
                try {
                    const args = decodeArray(argv, argc, memory);
                    result = func(...args);
                }
                catch (error) {
                    return writeAndReturnKindBits(error, payload1_ptr, payload2_ptr, true, this.memory);
                }
                return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
            },
            swjs_call_function_no_catch: (ref, argv, argc, payload1_ptr, payload2_ptr) => {
                const memory = this.memory;
                const func = memory.getObject(ref);
                const args = decodeArray(argv, argc, memory);
                const result = func(...args);
                return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
            },
            swjs_call_function_with_this: (obj_ref, func_ref, argv, argc, payload1_ptr, payload2_ptr) => {
                const memory = this.memory;
                const obj = memory.getObject(obj_ref);
                const func = memory.getObject(func_ref);
                let result;
                try {
                    const args = decodeArray(argv, argc, memory);
                    result = func.apply(obj, args);
                }
                catch (error) {
                    return writeAndReturnKindBits(error, payload1_ptr, payload2_ptr, true, this.memory);
                }
                return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
            },
            swjs_call_function_with_this_no_catch: (obj_ref, func_ref, argv, argc, payload1_ptr, payload2_ptr) => {
                const memory = this.memory;
                const obj = memory.getObject(obj_ref);
                const func = memory.getObject(func_ref);
                let result = undefined;
                const args = decodeArray(argv, argc, memory);
                result = func.apply(obj, args);
                return writeAndReturnKindBits(result, payload1_ptr, payload2_ptr, false, this.memory);
            },
            swjs_call_new: (ref, argv, argc) => {
                const memory = this.memory;
                const constructor = memory.getObject(ref);
                const args = decodeArray(argv, argc, memory);
                const instance = new constructor(...args);
                return this.memory.retain(instance);
            },
            swjs_call_throwing_new: (ref, argv, argc, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr) => {
                let memory = this.memory;
                const constructor = memory.getObject(ref);
                let result;
                try {
                    const args = decodeArray(argv, argc, memory);
                    result = new constructor(...args);
                }
                catch (error) {
                    write(error, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr, true, this.memory);
                    return -1;
                }
                memory = this.memory;
                write(null, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr, false, memory);
                return memory.retain(result);
            },
            swjs_instanceof: (obj_ref, constructor_ref) => {
                const memory = this.memory;
                const obj = memory.getObject(obj_ref);
                const constructor = memory.getObject(constructor_ref);
                return obj instanceof constructor;
            },
            swjs_create_function: (host_func_id, line, file) => {
                var _a;
                const fileString = this.memory.getObject(file);
                const func = (...args) => this.callHostFunction(host_func_id, line, fileString, args);
                const func_ref = this.memory.retain(func);
                (_a = this.closureDeallocator) === null || _a === void 0 ? void 0 : _a.track(func, func_ref);
                return func_ref;
            },
            swjs_create_typed_array: (constructor_ref, elementsPtr, length) => {
                const ArrayType = this.memory.getObject(constructor_ref);
                const array = new ArrayType(this.memory.rawMemory.buffer, elementsPtr, length);
                // Call `.slice()` to copy the memory
                return this.memory.retain(array.slice());
            },
            swjs_load_typed_array: (ref, buffer) => {
                const memory = this.memory;
                const typedArray = memory.getObject(ref);
                const bytes = new Uint8Array(typedArray.buffer);
                memory.writeBytes(buffer, bytes);
            },
            swjs_release: (ref) => {
                this.memory.release(ref);
            },
            swjs_i64_to_bigint: (value, signed) => {
                return this.memory.retain(signed ? value : BigInt.asUintN(64, value));
            },
            swjs_bigint_to_i64: (ref, signed) => {
                const object = this.memory.getObject(ref);
                if (typeof object !== "bigint") {
                    throw new Error(`Expected a BigInt, but got ${typeof object}`);
                }
                if (signed) {
                    return object;
                }
                else {
                    if (object < BigInt(0)) {
                        return BigInt(0);
                    }
                    return BigInt.asIntN(64, object);
                }
            },
            swjs_i64_to_bigint_slow: (lower, upper, signed) => {
                const value = BigInt.asUintN(32, BigInt(lower)) +
                    (BigInt.asUintN(32, BigInt(upper)) << BigInt(32));
                return this.memory.retain(signed ? BigInt.asIntN(64, value) : BigInt.asUintN(64, value));
            },
        };
        this._instance = null;
        this._memory = null;
        this._closureDeallocator = null;
    }
    setInstance(instance) {
        this._instance = instance;
        if (typeof this.exports._start === "function") {
            throw new Error(`JavaScriptKit supports only WASI reactor ABI.
                Please make sure you are building with:
                -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor
                `);
        }
        if (this.exports.swjs_library_version() != this.version) {
            throw new Error(`The versions of JavaScriptKit are incompatible.
                WebAssembly runtime ${this.exports.swjs_library_version()} != JS runtime ${this.version}`);
        }
    }
    get instance() {
        if (!this._instance)
            throw new Error("WebAssembly instance is not set yet");
        return this._instance;
    }
    get exports() {
        return this.instance.exports;
    }
    get memory() {
        if (!this._memory) {
            this._memory = new Memory(this.instance.exports);
        }
        return this._memory;
    }
    get closureDeallocator() {
        if (this._closureDeallocator)
            return this._closureDeallocator;
        const features = this.exports.swjs_library_features();
        const librarySupportsWeakRef = (features & 1 /* WeakRefs */) != 0;
        if (librarySupportsWeakRef) {
            this._closureDeallocator = new SwiftClosureDeallocator(this.exports);
        }
        return this._closureDeallocator;
    }
    callHostFunction(host_func_id, line, file, args) {
        const argc = args.length;
        const argv = this.exports.swjs_prepare_host_function_call(argc);
        const memory = this.memory;
        for (let index = 0; index < args.length; index++) {
            const argument = args[index];
            const base = argv + 16 * index;
            write(argument, base, base + 4, base + 8, false, memory);
        }
        let output;
        // This ref is released by the swjs_call_host_function implementation
        const callback_func_ref = memory.retain((result) => {
            output = result;
        });
        const alreadyReleased = this.exports.swjs_call_host_function(host_func_id, argv, argc, callback_func_ref);
        if (alreadyReleased) {
            throw new Error(`The JSClosure has been already released by Swift side. The closure is created at ${file}:${line}`);
        }
        this.exports.swjs_cleanup_host_function_call(argv);
        return output;
    }
}

export { SwiftRuntime };
