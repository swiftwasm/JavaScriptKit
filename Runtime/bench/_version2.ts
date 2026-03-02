import { globalVariable } from "../src/find-global.js";
import { ref } from "../src/types.js";

export class JSObjectSpace_v2 {
    private _entryByValue: Map<any, { id: number; rc: number }>;
    private _values: (any | undefined)[];
    private _refCounts: number[];
    private _nextRef: number;

    constructor() {
        this._values = [];
        this._values[0] = undefined;
        this._values[1] = globalVariable;

        this._entryByValue = new Map();
        this._entryByValue.set(globalVariable, { id: 1, rc: 1 });

        this._refCounts = [];
        this._refCounts[0] = 0;
        this._refCounts[1] = 1;

        // 0 is invalid, 1 is globalThis.
        this._nextRef = 2;
    }

    retain(value: any) {
        const entry = this._entryByValue.get(value);
        if (entry) {
            entry.rc++;
            this._refCounts[entry.id]++;
            return entry.id;
        }

        const id = this._nextRef++;
        this._values[id] = value;
        this._refCounts[id] = 1;
        this._entryByValue.set(value, { id, rc: 1 });
        return id;
    }

    retainByRef(ref: ref) {
        return this.retain(this.getObject(ref));
    }

    release(ref: ref) {
        const value = this._values[ref];
        const entry = this._entryByValue.get(value)!;
        entry.rc--;
        this._refCounts[ref]--;
        if (entry.rc != 0) return;

        this._entryByValue.delete(value);
        // Keep IDs monotonic; clear slot and leave possible holes.
        this._values[ref] = undefined;
        this._refCounts[ref] = 0;
    }

    getObject(ref: ref) {
        const value = this._values[ref];
        if (value === undefined) {
            throw new ReferenceError(
                "Attempted to read invalid reference " + ref,
            );
        }
        return value;
    }
}
