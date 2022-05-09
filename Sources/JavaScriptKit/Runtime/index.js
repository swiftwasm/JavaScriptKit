import { SwiftClosureDeallocator } from "./closure-heap";
import {
  LibraryFeatures
} from "./types";
import * as JSValue from "./js-value";
import { Memory } from "./memory";
export class SwiftRuntime {
  constructor() {
    this.version = 707;
    this.textDecoder = new TextDecoder("utf-8");
    this.textEncoder = new TextEncoder();
    this.importObjects = () => this.wasmImports;
    this.wasmImports = {
      swjs_set_prop: (ref2, name, kind, payload1, payload2) => {
        const obj = this.memory.getObject(ref2);
        const key = this.memory.getObject(name);
        const value = JSValue.decode(kind, payload1, payload2, this.memory);
        obj[key] = value;
      },
      swjs_get_prop: (ref2, name, kind_ptr, payload1_ptr, payload2_ptr) => {
        const obj = this.memory.getObject(ref2);
        const key = this.memory.getObject(name);
        const result = obj[key];
        JSValue.write(result, kind_ptr, payload1_ptr, payload2_ptr, false, this.memory);
      },
      swjs_set_subscript: (ref2, index, kind, payload1, payload2) => {
        const obj = this.memory.getObject(ref2);
        const value = JSValue.decode(kind, payload1, payload2, this.memory);
        obj[index] = value;
      },
      swjs_get_subscript: (ref2, index, kind_ptr, payload1_ptr, payload2_ptr) => {
        const obj = this.memory.getObject(ref2);
        const result = obj[index];
        JSValue.write(result, kind_ptr, payload1_ptr, payload2_ptr, false, this.memory);
      },
      swjs_encode_string: (ref2, bytes_ptr_result) => {
        const bytes = this.textEncoder.encode(this.memory.getObject(ref2));
        const bytes_ptr = this.memory.retain(bytes);
        this.memory.writeUint32(bytes_ptr_result, bytes_ptr);
        return bytes.length;
      },
      swjs_decode_string: (bytes_ptr, length) => {
        const bytes = this.memory.bytes().subarray(bytes_ptr, bytes_ptr + length);
        const string = this.textDecoder.decode(bytes);
        return this.memory.retain(string);
      },
      swjs_load_string: (ref2, buffer) => {
        const bytes = this.memory.getObject(ref2);
        this.memory.writeBytes(buffer, bytes);
      },
      swjs_call_function: (ref2, argv, argc, kind_ptr, payload1_ptr, payload2_ptr) => {
        const func = this.memory.getObject(ref2);
        let result;
        try {
          const args = JSValue.decodeArray(argv, argc, this.memory);
          result = func(...args);
        } catch (error) {
          JSValue.write(error, kind_ptr, payload1_ptr, payload2_ptr, true, this.memory);
          return;
        }
        JSValue.write(result, kind_ptr, payload1_ptr, payload2_ptr, false, this.memory);
      },
      swjs_call_function_no_catch: (ref2, argv, argc, kind_ptr, payload1_ptr, payload2_ptr) => {
        const func = this.memory.getObject(ref2);
        let isException = true;
        try {
          const args = JSValue.decodeArray(argv, argc, this.memory);
          const result = func(...args);
          JSValue.write(result, kind_ptr, payload1_ptr, payload2_ptr, false, this.memory);
          isException = false;
        } finally {
          if (isException) {
            JSValue.write(void 0, kind_ptr, payload1_ptr, payload2_ptr, true, this.memory);
          }
        }
      },
      swjs_call_function_with_this: (obj_ref, func_ref, argv, argc, kind_ptr, payload1_ptr, payload2_ptr) => {
        const obj = this.memory.getObject(obj_ref);
        const func = this.memory.getObject(func_ref);
        let result;
        try {
          const args = JSValue.decodeArray(argv, argc, this.memory);
          result = func.apply(obj, args);
        } catch (error) {
          JSValue.write(error, kind_ptr, payload1_ptr, payload2_ptr, true, this.memory);
          return;
        }
        JSValue.write(result, kind_ptr, payload1_ptr, payload2_ptr, false, this.memory);
      },
      swjs_call_function_with_this_no_catch: (obj_ref, func_ref, argv, argc, kind_ptr, payload1_ptr, payload2_ptr) => {
        const obj = this.memory.getObject(obj_ref);
        const func = this.memory.getObject(func_ref);
        let isException = true;
        try {
          const args = JSValue.decodeArray(argv, argc, this.memory);
          const result = func.apply(obj, args);
          JSValue.write(result, kind_ptr, payload1_ptr, payload2_ptr, false, this.memory);
          isException = false;
        } finally {
          if (isException) {
            JSValue.write(void 0, kind_ptr, payload1_ptr, payload2_ptr, true, this.memory);
          }
        }
      },
      swjs_call_new: (ref2, argv, argc) => {
        const constructor = this.memory.getObject(ref2);
        const args = JSValue.decodeArray(argv, argc, this.memory);
        const instance = new constructor(...args);
        return this.memory.retain(instance);
      },
      swjs_call_throwing_new: (ref2, argv, argc, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr) => {
        const constructor = this.memory.getObject(ref2);
        let result;
        try {
          const args = JSValue.decodeArray(argv, argc, this.memory);
          result = new constructor(...args);
        } catch (error) {
          JSValue.write(error, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr, true, this.memory);
          return -1;
        }
        JSValue.write(null, exception_kind_ptr, exception_payload1_ptr, exception_payload2_ptr, false, this.memory);
        return this.memory.retain(result);
      },
      swjs_instanceof: (obj_ref, constructor_ref) => {
        const obj = this.memory.getObject(obj_ref);
        const constructor = this.memory.getObject(constructor_ref);
        return obj instanceof constructor;
      },
      swjs_create_function: (host_func_id) => {
        var _a;
        const func = (...args) => this.callHostFunction(host_func_id, args);
        const func_ref = this.memory.retain(func);
        (_a = this.closureDeallocator) == null ? void 0 : _a.track(func, func_ref);
        return func_ref;
      },
      swjs_create_typed_array: (constructor_ref, elementsPtr, length) => {
        const ArrayType = this.memory.getObject(constructor_ref);
        const array = new ArrayType(this.memory.rawMemory.buffer, elementsPtr, length);
        return this.memory.retain(array.slice());
      },
      swjs_load_typed_array: (ref2, buffer) => {
        const typedArray = this.memory.getObject(ref2);
        const bytes = new Uint8Array(typedArray.buffer);
        this.memory.writeBytes(buffer, bytes);
      },
      swjs_release: (ref2) => {
        this.memory.release(ref2);
      },
      swjs_i64_to_bigint: (value, signed) => {
        return this.memory.retain(signed ? value : BigInt.asUintN(64, value));
      },
      swjs_bigint_to_i64: (ref2, signed) => {
        const object = this.memory.getObject(ref2);
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
      }
    };
    this._instance = null;
    this._memory = null;
    this._closureDeallocator = null;
  }
  setInstance(instance) {
    this._instance = instance;
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
    const librarySupportsWeakRef = (features & LibraryFeatures.WeakRefs) != 0;
    if (librarySupportsWeakRef) {
      this._closureDeallocator = new SwiftClosureDeallocator(this.exports);
    }
    return this._closureDeallocator;
  }
  callHostFunction(host_func_id, args) {
    const argc = args.length;
    const argv = this.exports.swjs_prepare_host_function_call(argc);
    for (let index = 0; index < args.length; index++) {
      const argument = args[index];
      const base = argv + 16 * index;
      JSValue.write(argument, base, base + 4, base + 8, false, this.memory);
    }
    let output;
    const callback_func_ref = this.memory.retain((result) => {
      output = result;
    });
    this.exports.swjs_call_host_function(host_func_id, argv, argc, callback_func_ref);
    this.exports.swjs_cleanup_host_function_call(argv);
    return output;
  }
}
