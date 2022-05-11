var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// src/memory.ts
var memory_exports = {};
__export(memory_exports, {
  Memory: () => Memory
});
module.exports = __toCommonJS(memory_exports);

// src/find-global.ts
var globalVariable;
if (typeof globalThis !== "undefined") {
  globalVariable = globalThis;
} else if (typeof window !== "undefined") {
  globalVariable = window;
} else if (typeof global !== "undefined") {
  globalVariable = global;
} else if (typeof self !== "undefined") {
  globalVariable = self;
}

// src/object-heap.ts
var SwiftRuntimeHeap = class {
  constructor() {
    this._heapValueById = /* @__PURE__ */ new Map();
    this._heapValueById.set(0, globalVariable);
    this._heapEntryByValue = /* @__PURE__ */ new Map();
    this._heapEntryByValue.set(globalVariable, { id: 0, rc: 1 });
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
    this._heapEntryByValue.set(value, { id, rc: 1 });
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
    if (value === void 0) {
      throw new ReferenceError("Attempted to read invalid reference " + ref);
    }
    return value;
  }
};

// src/memory.ts
var Memory = class {
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
};
