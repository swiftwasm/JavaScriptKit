import { globalVariable } from "./find-global.js";
import { ref } from "./types.js";

type SwiftRuntimeHeapEntry = {
    id: number;
    rc: number;
    released: boolean;
};
export class SwiftRuntimeHeap {
    private _heapValueById: Map<number, any>;
    private _heapEntryByValue: Map<any, SwiftRuntimeHeapEntry>;
    private _heapNextKey: number;

    constructor() {
        this._heapValueById = new Map();
        this._heapValueById.set(0, globalVariable);

        this._heapEntryByValue = new Map();
        this._heapEntryByValue.set(globalVariable, {
            id: 0,
            rc: 1,
            released: false,
        });

        // Note: 0 is preserved for global
        this._heapNextKey = 1;
    }

    retain(value: any) {
        const entry = this._heapEntryByValue.get(value);
        if (entry) {
            entry.rc++;
            return entry.id;
        }
        const id = this._heapNextKey++;
        this._heapValueById.set(id, value);
        this._heapEntryByValue.set(value, { id: id, rc: 1, released: false });
        return id;
    }

    release(ref: ref) {
        const value = this._heapValueById.get(ref);
        const entry = this._heapEntryByValue.get(value)!;
        if (entry.released) {
            console.error(
                "Double release detected for reference " + ref,
                entry
            );
            throw new ReferenceError(
                "Double release detected for reference " + ref
            );
        }
        entry.rc--;
        if (entry.rc != 0) return;

        this._heapEntryByValue.delete(value);
        this._heapValueById.delete(ref);
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
