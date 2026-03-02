import { globalVariable } from "../src/find-global.js";
import { ref } from "../src/types.js";

export class JSObjectSpace_v3 {
    private _idByValue: Map<any, number>;
    private _valueById: Map<number, any>;
    private _refCountById: Map<number, number>;
    private _nextRef: number;

    constructor() {
        this._idByValue = new Map();
        this._idByValue.set(globalVariable, 1);
        this._valueById = new Map();
        this._refCountById = new Map();
        this._valueById.set(1, globalVariable);
        this._refCountById.set(1, 1);

        // 0 is invalid, 1 is globalThis.
        this._nextRef = 2;
    }

    retain(value: any) {
        const id = this._idByValue.get(value);
        if (id !== undefined) {
            this._refCountById.set(id, this._refCountById.get(id)! + 1);
            return id;
        }

        const newId = this._nextRef++;
        this._valueById.set(newId, value);
        this._refCountById.set(newId, 1);
        this._idByValue.set(value, newId);
        return newId;
    }

    retainByRef(ref: ref) {
        const rc = this._refCountById.get(ref);
        if (rc === undefined) {
            throw new ReferenceError(
                "Attempted to retain invalid reference " + ref,
            );
        }
        this._refCountById.set(ref, rc + 1);
        return ref;
    }

    release(ref: ref) {
        const rc = this._refCountById.get(ref);
        if (rc === undefined) {
            throw new ReferenceError(
                "Attempted to release invalid reference " + ref,
            );
        }
        const next = rc - 1;
        if (next !== 0) {
            this._refCountById.set(ref, next);
            return;
        }

        const value = this._valueById.get(ref);
        this._idByValue.delete(value);
        this._valueById.delete(ref);
        this._refCountById.delete(ref);
    }

    getObject(ref: ref) {
        const rc = this._refCountById.get(ref);
        if (rc === undefined) {
            throw new ReferenceError(
                "Attempted to read invalid reference " + ref,
            );
        }
        return this._valueById.get(ref);
    }
}
