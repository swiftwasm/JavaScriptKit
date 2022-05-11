import { globalVariable } from "./find-global.js";
export class SwiftRuntimeHeap {
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
  release(ref2) {
    const value = this._heapValueById.get(ref2);
    const entry = this._heapEntryByValue.get(value);
    entry.rc--;
    if (entry.rc != 0)
      return;
    this._heapEntryByValue.delete(value);
    this._heapValueById.delete(ref2);
  }
  referenceHeap(ref2) {
    const value = this._heapValueById.get(ref2);
    if (value === void 0) {
      throw new ReferenceError("Attempted to read invalid reference " + ref2);
    }
    return value;
  }
}
