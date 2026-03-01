import { globalVariable } from "./find-global.js";
import { ref } from "./types.js";

export class JSObjectSpace {
    private _valueRefMap: Map<any, number>;
    private _values: (any | undefined)[];
    private _refCounts: number[];
    private _freeSlotStack: number[];

    constructor() {
        this._values = [];
        this._values[0] = undefined;
        this._values[1] = globalVariable;

        this._valueRefMap = new Map();
        this._valueRefMap.set(globalVariable, 1);

        this._refCounts = [];
        this._refCounts[0] = 0;
        this._refCounts[1] = 1;

        this._freeSlotStack = [];
    }

    retain(value: any) {
        const id = this._valueRefMap.get(value);
        if (id !== undefined) {
            this._refCounts[id]++;
            return id;
        }

        const newId =
            this._freeSlotStack.length > 0
                ? this._freeSlotStack.pop()!
                : this._values.length;
        this._values[newId] = value;
        this._refCounts[newId] = 1;
        this._valueRefMap.set(value, newId);
        return newId;
    }

    retainByRef(ref: ref) {
        this._refCounts[ref]++;
        return ref;
    }

    release(ref: ref) {
        if (--this._refCounts[ref] !== 0) return;

        const value = this._values[ref];
        this._valueRefMap.delete(value);
        if (ref === this._values.length - 1) {
            this._values.length = ref;
            this._refCounts.length = ref;
        } else {
            this._values[ref] = undefined;
            this._freeSlotStack.push(ref);
        }
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
