import { globalVariable } from "../src/find-global.js";
import { ref } from "../src/types.js";

const SLOT_BITS = 22;
const SLOT_MASK = (1 << SLOT_BITS) - 1;
const GEN_MASK = (1 << (32 - SLOT_BITS)) - 1;

export class JSObjectSpace_v4 {
    private _slotByValue: Map<any, number>;
    private _values: (any | undefined)[];
    private _refCounts: number[];
    private _generations: number[];
    private _freeSlotStack: number[];

    constructor() {
        this._values = [];
        this._values[0] = undefined;
        this._values[1] = globalVariable;

        this._slotByValue = new Map();
        this._slotByValue.set(globalVariable, 1);

        this._refCounts = [];
        this._refCounts[0] = 0;
        this._refCounts[1] = 1;

        // Generation 0 for initial slots.
        this._generations = [];
        this._generations[0] = 0;
        this._generations[1] = 0;

        this._freeSlotStack = [];
    }

    private _encodeRef(slot: number): ref {
        const generation = this._generations[slot] & GEN_MASK;
        return ((generation << SLOT_BITS) | slot) >>> 0;
    }

    private _expectValidSlot(reference: ref): number {
        const slot = reference & SLOT_MASK;
        if (slot === 0) {
            throw new ReferenceError(
                "Attempted to use invalid reference " + reference,
            );
        }
        const generation = reference >>> SLOT_BITS;
        if ((this._generations[slot]! & GEN_MASK) !== generation) {
            throw new ReferenceError(
                "Attempted to use stale reference " + reference,
            );
        }
        const rc = this._refCounts[slot];
        if (rc === undefined || rc === 0) {
            throw new ReferenceError(
                "Attempted to use invalid reference " + reference,
            );
        }
        return slot;
    }

    retain(value: any) {
        const slot = this._slotByValue.get(value);
        if (slot !== undefined) {
            this._refCounts[slot]++;
            return this._encodeRef(slot);
        }

        let newSlot: number;
        if (this._freeSlotStack.length > 0) {
            newSlot = this._freeSlotStack.pop()!;
        } else {
            newSlot = this._values.length;
            if (newSlot >= SLOT_MASK) {
                throw new RangeError(
                    `Reference slot overflow: ${newSlot} exceeds ${SLOT_MASK}`,
                );
            }

            if (this._generations[newSlot] === undefined) {
                this._generations[newSlot] = 0;
            }
        }

        this._values[newSlot] = value;
        this._refCounts[newSlot] = 1;
        this._slotByValue.set(value, newSlot);
        return this._encodeRef(newSlot);
    }

    retainByRef(reference: ref) {
        const slot = this._expectValidSlot(reference);
        this._refCounts[slot]++;
        // Return the exact incoming ref to preserve identity while live.
        return reference;
    }

    release(reference: ref) {
        const slot = this._expectValidSlot(reference);
        if (--this._refCounts[slot] !== 0) return;

        const value = this._values[slot];
        this._slotByValue.delete(value);
        this._values[slot] = undefined;

        this._generations[slot] = ((this._generations[slot]! + 1) & GEN_MASK) >>> 0;

        if (slot === this._values.length - 1) {
            // Compact trailing holes in fast arrays, but keep generations so
            // future reuse of the same slot still gets a new generation.
            this._values.length = slot;
            this._refCounts.length = slot;
        } else {
            this._freeSlotStack.push(slot);
        }
    }

    getObject(reference: ref) {
        return this._values[this._expectValidSlot(reference)];
    }
}
