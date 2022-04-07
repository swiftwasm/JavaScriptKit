import { globalVariable } from "./find-global";
import { ref } from "./types";

type SwiftRuntimeHeapEntry = {
    id: number;
    rc: number;
};
export class SwiftRuntimeHeap {
    private _heapValueById: Map<number, any>;
    private _heapEntryByValue: Map<any, SwiftRuntimeHeapEntry>;
    private _heapNextKey: number;

    constructor() {
        this._heapValueById = new Map();
        this._heapValueById.set(0, globalVariable);

        this._heapEntryByValue = new Map();
        this._heapEntryByValue.set(globalVariable, { id: 0, rc: 1 });

        // Note: 0 is preserved for global
        this._heapNextKey = 1;
    }

    retain(value: any) {
        const isObject = typeof value == "object";
        const entry = this._heapEntryByValue.get(value);
        if (isObject && entry) {
            entry.rc++;
            return entry.id;
        }
        const id = this._heapNextKey++;
        this._heapValueById.set(id, value);
        if (isObject) {
            this._heapEntryByValue.set(value, { id: id, rc: 1 });
        }
        return id;
    }

    release(ref: ref) {
        const value = this._heapValueById.get(ref);
        const isObject = typeof value == "object";
        if (isObject) {
            const entry = this._heapEntryByValue.get(value)!;
            entry.rc--;
            if (entry.rc != 0) return;

            this._heapEntryByValue.delete(value);
            this._heapValueById.delete(ref);
        } else {
            this._heapValueById.delete(ref);
        }
    }

    referenceHeap(ref: ref) {
        const value = this._heapValueById.get(ref);
        if (value === undefined) {
            throw new ReferenceError(
                "Attempted to read invalid reference " + ref
            );
        }
        return value;
    }
}
