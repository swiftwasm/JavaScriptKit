import { SwiftRuntimeHeap } from "./object-heap";
import { pointer } from "./types";

export class Memory {
    readonly rawMemory: WebAssembly.Memory;

    private readonly heap = new SwiftRuntimeHeap();

    constructor(exports: WebAssembly.Exports) {
        this.rawMemory = exports.memory as WebAssembly.Memory;
    }

    retain = (value: any) => this.heap.retain(value);
    getObject = (ref: number) => this.heap.referenceHeap(ref);
    release = (ref: number) => this.heap.release(ref);

    bytes = () => new Uint8Array(this.rawMemory.buffer);
    dataView = () => new DataView(this.rawMemory.buffer);

    writeBytes = (ptr: pointer, bytes: Uint8Array) =>
        this.bytes().set(bytes, ptr);

    readUint32 = (ptr: pointer) => this.dataView().getUint32(ptr, true);
    readUint64 = (ptr: pointer) => this.dataView().getBigUint64(ptr, true);
    readInt64 = (ptr: pointer) => this.dataView().getBigInt64(ptr, true);
    readFloat64 = (ptr: pointer) => this.dataView().getFloat64(ptr, true);

    writeUint32 = (ptr: pointer, value: number) =>
        this.dataView().setUint32(ptr, value, true);
    writeUint64 = (ptr: pointer, value: bigint) =>
        this.dataView().setBigUint64(ptr, value, true);
    writeInt64 = (ptr: pointer, value: bigint) =>
        this.dataView().setBigInt64(ptr, value, true);
    writeFloat64 = (ptr: pointer, value: number) =>
        this.dataView().setFloat64(ptr, value, true);
}
