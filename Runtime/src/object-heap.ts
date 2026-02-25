import { globalVariable } from "./find-global.js";
import { ref } from "./types.js";

export class JSObjectSpace {
    private _valueMap: Map<any, number>;
    private _values: (any | undefined)[];
    private _rcById: number[];
    private _freeStack: number[];

    constructor() {
        this._values = [];
        this._values[0] = undefined;
        this._values[1] = globalVariable;

        this._valueMap = new Map();
        this._valueMap.set(globalVariable, 1);

        this._rcById = [];
        this._rcById[0] = 0;
        this._rcById[1] = 1;

        this._freeStack = [];
    }

    retain(value: any) {
        const id = this._valueMap.get(value);
        if (id !== undefined) {
            this._rcById[id]++;
            return id;
        }
        if (this._freeStack.length > 0) {
            const newId = this._freeStack.pop()!;
            this._values[newId] = value;
            this._rcById[newId] = 1;
            this._valueMap.set(value, newId);
            return newId;
        }
        const newId = this._values.length;
        this._values[newId] = value;
        this._rcById[newId] = 1;
        this._valueMap.set(value, newId);
        return newId;
    }

    retainByRef(ref: ref) {
        this._rcById[ref]++;
        return ref;
    }

    release(ref: ref) {
        if (--this._rcById[ref] !== 0) return;

        const value = this._values[ref];
        this._valueMap.delete(value);
        if (ref === this._values.length - 1) {
            this._values.length = ref;
            this._rcById.length = ref;
        } else {
            this._values[ref] = undefined;
            this._freeStack.push(ref);
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
