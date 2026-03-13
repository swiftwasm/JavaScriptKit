import { globalVariable } from "./find-global.js";
import { ref } from "./types.js";

const SLOT_BITS = 22;
const SLOT_MASK = (1 << SLOT_BITS) - 1;
const GEN_MASK = (1 << (32 - SLOT_BITS)) - 1;

export class JSObjectSpace {
    private _slotByValue: Map<any, number>;
    private _values: (any | undefined)[];
    private _stateBySlot: number[];
    private _freeSlotStack: number[];

    constructor() {
        this._slotByValue = new Map();
        this._values = [];
        this._stateBySlot = [];
        this._freeSlotStack = [];

        this._values[0] = undefined;
        this._values[1] = globalVariable;
        this._slotByValue.set(globalVariable, 1);
        this._stateBySlot[1] = 1; // gen=0, rc=1
    }

    retain(value: any) {
        const slot = this._slotByValue.get(value);
        if (slot !== undefined) {
            const state = this._stateBySlot[slot]!;
            const nextState = (state + 1) >>> 0;
            if ((nextState & SLOT_MASK) === 0) {
                throw new RangeError(
                    `Reference count overflow at slot ${slot}`,
                );
            }
            this._stateBySlot[slot] = nextState;
            return ((nextState & ~SLOT_MASK) | slot) >>> 0;
        }

        let newSlot: number;
        let state: number;
        if (this._freeSlotStack.length > 0) {
            newSlot = this._freeSlotStack.pop()!;
            const gen = this._stateBySlot[newSlot]! >>> SLOT_BITS;
            state = ((gen << SLOT_BITS) | 1) >>> 0;
        } else {
            newSlot = this._values.length;
            if (newSlot > SLOT_MASK) {
                throw new RangeError(
                    `Reference slot overflow: ${newSlot} exceeds ${SLOT_MASK}`,
                );
            }
            state = 1;
        }

        this._stateBySlot[newSlot] = state;
        this._values[newSlot] = value;
        this._slotByValue.set(value, newSlot);
        return ((state & ~SLOT_MASK) | newSlot) >>> 0;
    }

    retainByRef(reference: ref) {
        const state = this._getValidatedSlotState(reference);
        const slot = reference & SLOT_MASK;
        const nextState = (state + 1) >>> 0;
        if ((nextState & SLOT_MASK) === 0) {
            throw new RangeError(`Reference count overflow at slot ${slot}`);
        }
        this._stateBySlot[slot] = nextState;
        return reference;
    }

    release(reference: ref) {
        const state = this._getValidatedSlotState(reference);
        const slot = reference & SLOT_MASK;
        if ((state & SLOT_MASK) > 1) {
            this._stateBySlot[slot] = (state - 1) >>> 0;
            return;
        }

        this._slotByValue.delete(this._values[slot]);
        this._values[slot] = undefined;
        const nextGen = ((state >>> SLOT_BITS) + 1) & GEN_MASK;
        this._stateBySlot[slot] = (nextGen << SLOT_BITS) >>> 0;
        this._freeSlotStack.push(slot);
    }

    getObject(reference: ref) {
        this._getValidatedSlotState(reference);
        return this._values[reference & SLOT_MASK];
    }

    // Returns the packed state for the slot, after validating the reference.
    private _getValidatedSlotState(reference: ref): number {
        const slot = reference & SLOT_MASK;
        if (slot === 0)
            throw new ReferenceError(
                "Attempted to use invalid reference " + reference,
            );
        const state = this._stateBySlot[slot];
        if (state === undefined || (state & SLOT_MASK) === 0) {
            throw new ReferenceError(
                "Attempted to use invalid reference " + reference,
            );
        }
        if (state >>> SLOT_BITS !== reference >>> SLOT_BITS) {
            throw new ReferenceError(
                "Attempted to use stale reference " + reference,
            );
        }
        return state;
    }
}
