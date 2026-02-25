import { globalVariable } from "../src/find-global.js";
import { ref } from "../src/types.js";

type SwiftRuntimeHeapEntry = {
    id: number;
    rc: number;
};

/** Original implementation kept for benchmark comparison. Same API as JSObjectSpace. */
export class JSObjectSpaceOriginal {
    private _heapValueById: Map<number, any>;
    private _heapEntryByValue: Map<any, SwiftRuntimeHeapEntry>;
    private _heapNextKey: number;

    constructor() {
        this._heapValueById = new Map();
        this._heapValueById.set(1, globalVariable);

        this._heapEntryByValue = new Map();
        this._heapEntryByValue.set(globalVariable, { id: 1, rc: 1 });

        // Note: 0 is preserved for invalid references, 1 is preserved for globalThis
        this._heapNextKey = 2;
    }

    retain(value: any) {
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

    retainByRef(ref: ref) {
        return this.retain(this.getObject(ref));
    }

    release(ref: ref) {
        const value = this._heapValueById.get(ref);
        const entry = this._heapEntryByValue.get(value)!;
        entry.rc--;
        if (entry.rc != 0) return;

        this._heapEntryByValue.delete(value);
        this._heapValueById.delete(ref);
    }

    getObject(ref: ref) {
        const value = this._heapValueById.get(ref);
        if (value === undefined) {
            throw new ReferenceError(
                "Attempted to read invalid reference " + ref,
            );
        }
        return value;
    }
}
