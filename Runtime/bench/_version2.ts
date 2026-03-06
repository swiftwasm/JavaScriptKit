import { globalVariable } from "../src/find-global.js";
import { ref } from "../src/types.js";

export class JSObjectSpace_v2 {
    private _idByValue: Map<any, number>;
    private _valueById: Record<number, any>;
    private _refCountById: Record<number, number | undefined>;
    private _nextRef: number;

    constructor() {
        this._idByValue = new Map();
        this._idByValue.set(globalVariable, 1);
        this._valueById = Object.create(null);
        this._refCountById = Object.create(null);
        this._valueById[1] = globalVariable;
        this._refCountById[1] = 1;

        // 0 is invalid, 1 is globalThis.
        this._nextRef = 2;
    }

    retain(value: any) {
        const id = this._idByValue.get(value);
        if (id !== undefined) {
            this._refCountById[id]!++;
            return id;
        }

        const newId = this._nextRef++;
        this._valueById[newId] = value;
        this._refCountById[newId] = 1;
        this._idByValue.set(value, newId);
        return newId;
    }

    retainByRef(ref: ref) {
        const rc = this._refCountById[ref];
        if (rc === undefined) {
            throw new ReferenceError(
                "Attempted to retain invalid reference " + ref,
            );
        }
        this._refCountById[ref] = rc + 1;
        return ref;
    }

    release(ref: ref) {
        const rc = this._refCountById[ref];
        if (rc === undefined) {
            throw new ReferenceError(
                "Attempted to release invalid reference " + ref,
            );
        }
        const next = rc - 1;
        if (next !== 0) {
            this._refCountById[ref] = next;
            return;
        }

        const value = this._valueById[ref];
        this._idByValue.delete(value);
        delete this._valueById[ref];
        delete this._refCountById[ref];
    }

    getObject(ref: ref) {
        const rc = this._refCountById[ref];
        if (rc === undefined) {
            throw new ReferenceError(
                "Attempted to read invalid reference " + ref,
            );
        }
        return this._valueById[ref];
    }
}
