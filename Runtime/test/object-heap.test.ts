import { describe, expect, test } from "vitest";
import { JSObjectSpace } from "../src/object-heap.js";

const SLOT_MASK = (1 << 24) - 1;

function invalidReference(reference: number) {
    return new ReferenceError(
        `Attempted to use invalid reference ${reference}`,
    );
}

function staleReference(reference: number) {
    return new ReferenceError(`Attempted to use stale reference ${reference}`);
}

describe("JSObjectSpace", () => {
    test("getObject rejects reference 0 and a slot never allocated", () => {
        const space = new JSObjectSpace();
        expect(() => space.getObject(0)).toThrow(invalidReference(0));
        expect(() => space.getObject(SLOT_MASK)).toThrow(
            invalidReference(SLOT_MASK),
        );
    });

    test("reference 1 is globalThis", () => {
        const space = new JSObjectSpace();
        expect(space.getObject(1)).toBe(globalThis);
    });

    test("retain returns a new reference for a value it already holds", () => {
        const space = new JSObjectSpace();
        const value = {};
        const first = space.retain(value);
        const second = space.retain(value);
        expect(second).not.toBe(first);
        space.release(first);
        expect(() => space.getObject(first)).toThrow(invalidReference(first));
        expect(space.getObject(second)).toBe(value);
    });

    test("retainByRef keeps the slot until every reference is released", () => {
        const space = new JSObjectSpace();
        const value = {};
        const reference = space.retainByRef(space.retain(value));
        space.release(reference);
        expect(space.getObject(reference)).toBe(value);
        space.release(reference);
        expect(() => space.getObject(reference)).toThrow(
            invalidReference(reference),
        );
    });

    test("getObject, release and retainByRef reject a stale reference", () => {
        const space = new JSObjectSpace();
        const stale = space.retain({});
        space.release(stale);
        const reused = space.retain({});
        expect(reused & SLOT_MASK).toBe(stale & SLOT_MASK);
        expect(() => space.getObject(stale)).toThrow(staleReference(stale));
        expect(() => space.release(stale)).toThrow(staleReference(stale));
        expect(() => space.retainByRef(stale)).toThrow(staleReference(stale));
    });

    test("retain throws once every slot is allocated", () => {
        const space = new JSObjectSpace();
        (space as any)._values.length = SLOT_MASK;
        const value = {};
        const last = space.retain(value);
        expect(last).toBe(SLOT_MASK);
        expect(space.getObject(last)).toBe(value);
        expect(() => space.retain({})).toThrow(
            new RangeError(
                `Reference slot overflow: ${SLOT_MASK + 1} exceeds ${SLOT_MASK}`,
            ),
        );
    });

    test("a slot holds at most 2^24 - 1 references", () => {
        const space = new JSObjectSpace();
        const reference = space.retain({});
        const slot = reference & SLOT_MASK;
        (space as any)._stateBySlot[slot] += SLOT_MASK - 1;
        expect(() => space.retainByRef(reference)).toThrow(
            new RangeError(`Reference count overflow at slot ${slot}`),
        );
    });
});
