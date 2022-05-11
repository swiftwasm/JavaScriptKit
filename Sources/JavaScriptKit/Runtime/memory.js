import { SwiftRuntimeHeap } from "./object-heap.js";
export class Memory {
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
