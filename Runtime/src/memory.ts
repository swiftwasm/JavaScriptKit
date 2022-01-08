import { SwiftRuntimeHeap } from "./object-heap";
import { pointer } from "./types";

export class Memory {
    readonly rawMemory: WebAssembly.Memory;
    readonly bytes: Uint8Array;
    readonly dataView: DataView;

    private readonly heap = new SwiftRuntimeHeap();

    constructor(exports: WebAssembly.Exports) {
        this.rawMemory = exports.memory as WebAssembly.Memory;
        this.bytes = new Uint8Array(this.rawMemory.buffer);
        this.dataView = new DataView(this.rawMemory.buffer);
    }

    retain = (value: any) => this.heap.retain(value);
    getObject = (ref: number) => this.heap.referenceHeap(ref);
    release = (ref: number) => this.heap.release(ref);

    writeBytes = (ptr: pointer, bytes: Uint8Array) =>
        this.bytes.set(bytes, ptr);

    readUint32 = (ptr: pointer) => this.dataView.getUint32(ptr, true);
    readFloat64 = (ptr: pointer) => this.dataView.getFloat64(ptr, true);

    writeUint32 = (ptr: pointer, value: number) =>
        this.dataView.setUint32(ptr, value, true);
    writeFloat64 = (ptr: pointer, value: number) =>
        this.dataView.setFloat64(ptr, value);
}
