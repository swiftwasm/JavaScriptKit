import { describe, expect, test } from "vitest";
import { JSObjectSpace } from "../src/object-heap.js";

const SLOT_MASK = (1 << 24) - 1;
const MAX_REFERENCES = (1 << 23) - 1;

function invalidReference(reference: number) {
    return new ReferenceError(
        `Attempted to use invalid reference ${reference}`,
    );
}

function staleReference(reference: number) {
    return new ReferenceError(`Attempted to use stale reference ${reference}`);
}

function countOverflow(reference: number) {
    return new RangeError(
        `Reference count overflow at slot ${reference & SLOT_MASK}`,
    );
}

describe("JSObjectSpace", () => {
    test("getObject rejects reference 0 and a slot never allocated", () => {
        const space = new JSObjectSpace();
        expect(() => space.getObject(0)).toThrow(invalidReference(0));
        expect(() => space.getObject(SLOT_MASK)).toThrow(
            invalidReference(SLOT_MASK),
        );
    });

    test("reference 1 is retain's reference to globalThis and outlives a balanced release", () => {
        const space = new JSObjectSpace();
        expect(space.retain(globalThis)).toBe(1);
        space.release(1);
        expect(space.getObject(1)).toBe(globalThis);
    });

    test("retain's reference leaves the value map on its last release", () => {
        const space = new JSObjectSpace();
        const value = {};
        const reference = space.retain(value);
        space.release(reference);
        const other = {};
        const reused = space.retain(other);
        expect(reused & SLOT_MASK).toBe(reference & SLOT_MASK);
        expect(space.getObject(reused)).toBe(other);
        expect(space.getObject(space.retain(value))).toBe(value);
    });

    test("retainUnique returns a reference retain does not", () => {
        const space = new JSObjectSpace();
        const value = {};
        const unique = space.retainUnique(value);
        const shared = space.retain(value);
        expect(shared).not.toBe(unique);
        expect(space.getObject(unique)).toBe(value);
        expect(space.getObject(shared)).toBe(value);
    });

    test("releasing a unique reference keeps retain's reference", () => {
        const space = new JSObjectSpace();
        const value = {};
        const shared = space.retain(value);
        space.release(space.retainUnique(value));
        expect(space.retain(value)).toBe(shared);
    });

    test("releasing a unique reference to a reused slot keeps retain's reference", () => {
        const space = new JSObjectSpace();
        const value = {};
        const shared = space.retain(value);
        const freed = space.retainUnique({});
        space.release(freed);
        const unique = space.retainUnique(value);
        expect(unique & SLOT_MASK).toBe(freed & SLOT_MASK);
        space.release(unique);
        expect(space.retain(value)).toBe(shared);
    });

    test("getObject, shareUnique, release and retainByRef reject a stale reference", () => {
        const space = new JSObjectSpace();
        const stale = space.retainUnique({});
        space.release(stale);
        const unique = space.retainUnique({});
        expect(unique & SLOT_MASK).toBe(stale & SLOT_MASK);
        expect(() => space.getObject(stale)).toThrow(staleReference(stale));
        expect(() => space.shareUnique(stale)).toThrow(staleReference(stale));
        expect(() => space.release(stale)).toThrow(staleReference(stale));
        expect(() => space.retainByRef(stale)).toThrow(staleReference(stale));
    });

    test("shareUnique returns a reference retain returned", () => {
        const space = new JSObjectSpace();
        const value = {};
        const shared = space.retain(value);
        expect(space.shareUnique(shared)).toBe(shared);
        space.release(shared);
        expect(() => space.getObject(shared)).toThrow(invalidReference(shared));
    });

    test("shareUnique returns retain's reference and releases the unique one", () => {
        const space = new JSObjectSpace();
        const value = {};
        const shared = space.retain(value);
        const unique = space.retainUnique(value);
        expect(space.shareUnique(unique)).toBe(shared);
        expect(() => space.getObject(unique)).toThrow(invalidReference(unique));
        space.release(shared);
        expect(space.getObject(shared)).toBe(value);
    });

    test("shareUnique releases one of two references to a unique slot", () => {
        const space = new JSObjectSpace();
        const value = {};
        const shared = space.retain(value);
        const unique = space.retainByRef(space.retainUnique(value));
        expect(space.shareUnique(unique)).toBe(shared);
        expect(space.getObject(unique)).toBe(value);
        space.release(unique);
        expect(() => space.getObject(unique)).toThrow(invalidReference(unique));
    });

    test("shareUnique adds the slot of a value retain has not seen to the value map", () => {
        const space = new JSObjectSpace();
        const value = {};
        const unique = space.retainUnique(value);
        expect(space.shareUnique(unique)).toBe(unique);
        expect(space.retain(value)).toBe(unique);
    });

    test("a slot shareUnique adds leaves the value map on its last release", () => {
        const space = new JSObjectSpace();
        const value = {};
        const shared = space.shareUnique(space.retainUnique(value));
        space.release(shared);
        const other = {};
        expect(space.retain(other) & SLOT_MASK).toBe(shared & SLOT_MASK);
        expect(space.getObject(space.retain(value))).toBe(value);
    });

    test("shareUnique keeps every reference to a unique slot it adds to the value map", () => {
        const space = new JSObjectSpace();
        const value = {};
        const unique = space.retainByRef(space.retainUnique(value));
        expect(space.shareUnique(unique)).toBe(unique);
        space.release(unique);
        expect(space.getObject(unique)).toBe(value);
        expect(space.retain(value)).toBe(unique);
        space.release(unique);
        space.release(unique);
        expect(space.retain(value)).not.toBe(unique);
    });

    test("retain and retainUnique throw once every slot is allocated", () => {
        const space = new JSObjectSpace();
        (space as any)._values.length = SLOT_MASK;
        const value = {};
        const last = space.retainUnique(value);
        expect(last).toBe(SLOT_MASK);
        expect(space.getObject(last)).toBe(value);
        const overflow = new RangeError(
            `Reference slot overflow: ${SLOT_MASK + 1} exceeds ${SLOT_MASK}`,
        );
        expect(() => space.retain({})).toThrow(overflow);
        expect(() => space.retainUnique({})).toThrow(overflow);
    });

    test("a value retain returns holds at most 2^23 - 1 references", () => {
        const space = new JSObjectSpace();
        const value = {};
        const reference = space.retain(value);
        for (let i = 1; i < MAX_REFERENCES; i++) space.retainByRef(reference);
        expect(() => space.retain(value)).toThrow(countOverflow(reference));
        expect(() => space.retainByRef(reference)).toThrow(
            countOverflow(reference),
        );
        for (let i = 1; i < MAX_REFERENCES; i++) space.release(reference);
        expect(space.retain(value)).toBe(reference);
        space.release(reference);
        space.release(reference);
        expect(() => space.getObject(reference)).toThrow(
            invalidReference(reference),
        );
    });

    test("a unique slot holds at most 2^23 - 1 references", () => {
        const space = new JSObjectSpace();
        const value = {};
        const unique = space.retainUnique(value);
        for (let i = 1; i < MAX_REFERENCES; i++) space.retainByRef(unique);
        expect(() => space.retainByRef(unique)).toThrow(countOverflow(unique));
        expect(space.retain(value)).not.toBe(unique);
        for (let i = 1; i < MAX_REFERENCES; i++) space.release(unique);
        expect(space.getObject(unique)).toBe(value);
        space.release(unique);
        expect(() => space.getObject(unique)).toThrow(invalidReference(unique));
    });
});
