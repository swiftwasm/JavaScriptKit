// @ts-check

import assert from "node:assert";

/**
 * Sums the reference counts of every slot in the runtime's `JSObjectSpace`, `globalThis` included.
 * Other Swift tests change it while a test awaits, so compare two counts only within a synchronous loop.
 * @param {any} swift The `SwiftRuntime` instance.
 */
function liveReferenceCount(swift) {
    let count = 0;
    for (const state of swift.memory._stateBySlot) {
        count += (state ?? 0) & 0xffffff;
    }
    return count;
}

/**
 * @param {any} swift The `SwiftRuntime` instance.
 * @param {any[]} values
 */
function referenceCountOf(swift, values) {
    let count = 0;
    for (const value of values) {
        const slot = swift.memory._slotByValue.get(value);
        if (slot !== undefined) count += swift.memory._stateBySlot[slot] & 0xffffff;
    }
    return count;
}

class NoncopyableObject {
    /** @param {number} start */
    constructor(start) {
        this.start = start;
    }
    /** @param {number} start */
    static create(start) {
        return new NoncopyableObject(start);
    }
    value() {
        return this.start;
    }
}

/** @param {number} start */
const makeCopyableObjectRoundtrip = (start) => ({
    value: () => start,
    take: (object) => object.value(),
    make: (value) => new NoncopyableObject(value),
});

class NoncopyableObjectRoundtrip {
    constructor() {
        this.stored = null;
    }
    take(object) {
        return object.value();
    }
    make(start) {
        return new NoncopyableObject(start);
    }
    get child() {
        return new NoncopyableObject(42);
    }
    set child(object) {
        this.stored = object;
    }
    adopt(object) {
        return object.value();
    }
    takeCopyable(copyable) {
        return copyable.value();
    }
    makeCopyable(start) {
        return makeCopyableObjectRoundtrip(start);
    }
    failTake(_object) {
        throw new Error("failTake");
    }
    failMake() {
        throw new Error("failMake");
    }
}

/** @param {() => any} getSwift */
function makeSourceClass(getSwift) {
    return class NoncopyableSource {
        created = [];
        optionalChild = null;
        children = [];

        forEachObject(count, body) {
            for (let i = 0; i < count; i++) body(new NoncopyableObject(i));
        }
        forEachObjectEscaping(count, body) {
            for (let i = 0; i < count; i++) body(new NoncopyableObject(i));
        }
        forEachCopyableEscaping(count, body) {
            for (let i = 0; i < count; i++) body(makeCopyableObjectRoundtrip(i));
        }
        /** @param {Promise<any>} promise */
        recordSettlers(promise) {
            const then = promise.then.bind(promise);
            promise.then = (resolve, reject) => {
                this.created.push(resolve, reject);
                return then(resolve, reject);
            };
            return promise;
        }
        load(start) {
            const object = new NoncopyableObject(start);
            this.created.push(object);
            return this.recordSettlers(Promise.resolve(object));
        }
        loadCopyable(start) {
            const copyable = makeCopyableObjectRoundtrip(start);
            this.created.push(copyable);
            return this.recordSettlers(Promise.resolve(copyable));
        }
        loadFail() {
            const error = new Error("loadFail");
            this.created.push(error);
            return this.recordSettlers(Promise.reject(error));
        }
        use(object) {
            return this.recordSettlers(Promise.resolve(object.value()));
        }
        referencesToCreated() {
            const count = referenceCountOf(getSwift(), this.created);
            this.created = [];
            return count;
        }
        referencesTo(object) {
            return referenceCountOf(getSwift(), [object]);
        }
        takeOptional(object) {
            return object == null ? -2 : object.value();
        }
        takeOptionalCopyable(copyable) {
            return copyable == null ? -2 : copyable.value();
        }
        findOptional(start) {
            return start < 0 ? null : new NoncopyableObject(start);
        }
        findOptionalCopyable(start) {
            return start < 0 ? null : makeCopyableObjectRoundtrip(start);
        }
        forEachOptional(count, body) {
            for (let i = 0; i < count; i++) body(i % 2 === 0 ? new NoncopyableObject(i) : null);
        }
        loadOptional(start) {
            if (start >= 0) return this.load(start);
            return this.recordSettlers(Promise.resolve(null));
        }
        raw(start) {
            return new NoncopyableObject(start);
        }
        rawValue(ref) {
            return ref.value();
        }
        maybeRaw(start) {
            return this.findOptional(start);
        }
        rawObject(start) {
            return new NoncopyableObject(start);
        }
        takeAll(objects) {
            return objects.reduce((sum, object, index) => sum + object.value() * (index + 1), 0);
        }
        makeAll(count) {
            return Array.from({ length: count }, (_, i) => new NoncopyableObject(i));
        }
        takeAllOptional(objects) {
            return objects.reduce((sum, object) => sum + (object == null ? -2 : object.value()), 0);
        }
        makeAllOptional(count) {
            return Array.from({ length: count }, (_, i) => (i % 2 === 0 ? new NoncopyableObject(i) : null));
        }
        makeGrid(count) {
            return Array.from({ length: count }, (_, row) => this.makeAll(row));
        }
        loadAll(count) {
            const objects = this.makeAll(count);
            this.created.push(...objects);
            return this.recordSettlers(Promise.resolve(objects));
        }
        forEachBatch(count, body) {
            for (let i = 0; i < count; i++) body(this.makeAll(i));
        }
        takeMaybe(objects) {
            return objects == null ? -2 : this.takeAll(objects);
        }
        makeMaybe(count) {
            return count < 0 ? null : this.makeAll(count);
        }
        takeRows(rows) {
            return rows.reduce((sum, row, index) => sum + (row == null ? -2 : this.takeAll(row)) * (index + 1), 0);
        }
        makeRows(count) {
            return Array.from({ length: count }, (_, row) => (row % 2 === 0 ? this.makeAll(row) : null));
        }
        loadMaybe(count) {
            const objects = this.makeMaybe(count);
            if (objects !== null) this.created.push(...objects);
            return this.recordSettlers(Promise.resolve(objects));
        }
    };
}

/** @param {number} i */
const optionalObject = (i) => (i % 2 === 0 ? new NoncopyableObject(i) : null);
/** @param {number} i */
const optionalValue = (i) => (i % 2 === 0 ? i : -2);
/** @param {number} count */
const makeObjects = (count) => Array.from({ length: count }, (_, j) => new NoncopyableObject(j));
/** @param {number} count */
const range = (count) => Array.from({ length: count }, (_, j) => j);

/**
 * @param {any} swift The `SwiftRuntime` instance.
 * @param {Record<string, (i: number) => void>} paths
 */
function referencesKept(swift, paths) {
    /** @type {Record<string, number>} */
    const kept = {};
    for (const [name, body] of Object.entries(paths)) {
        const before = liveReferenceCount(swift);
        for (let i = 0; i < 100; i++) body(i);
        kept[name] = liveReferenceCount(swift) - before;
    }
    return kept;
}

/** @param {string[]} names */
const zeros = (names) => Object.fromEntries(names.map((name) => [name, 0]));

/**
 * @param {any} exports
 * @param {any} swift The `SwiftRuntime` instance.
 */
async function runExportedPathTests(exports, swift) {
    const Box = exports.NoncopyableObjectBox;
    const paths = {
        "exported function, borrowing parameter": (i) =>
            assert.equal(exports.noncopyableTake(new NoncopyableObject(i)), i),
        "exported function, consuming parameter": (i) =>
            assert.equal(exports.noncopyableConsume(new NoncopyableObject(i)), i),
        "exported function, return": (i) => assert.equal(exports.noncopyableMake(i).value(), i),
        "exported function, return passed back": (i) =>
            assert.equal(exports.noncopyableTake(exports.noncopyableMake(i)), i),
        "exported function, closure parameter": (i) =>
            assert.equal(
                exports.noncopyableCallWith(i, (object) => object.value()),
                i,
            ),
        "exported function, optional parameter": (i) =>
            assert.equal(exports.noncopyableTakeOptional(optionalObject(i)), optionalValue(i)),
        "exported function, optional parameter, copyable control": (i) =>
            assert.equal(exports.copyableTakeOptional(optionalObject(i)), optionalValue(i)),
        "exported function, optional return": (i) => {
            const object = exports.noncopyableFindOptional(i % 2 === 0 ? i : -1);
            assert.equal(object === null ? -2 : object.value(), optionalValue(i));
        },
        "exported function, optional return passed back": (i) =>
            assert.equal(
                exports.noncopyableTakeOptional(exports.noncopyableFindOptional(i % 2 === 0 ? i : -1)),
                optionalValue(i),
            ),
        "exported function, optional closure parameter": (i) =>
            assert.equal(
                exports.noncopyableCallWithOptional(i % 2 === 0 ? i : -1, (object) =>
                    object === null ? -2 : object.value(),
                ),
                optionalValue(i),
            ),
        "exported protocol, borrowing parameter": (i) =>
            assert.equal(exports.noncopyableVisit({ visit: (object) => object.value() }, i), i),
        "exported protocol, optional parameter": (i) =>
            assert.equal(
                exports.noncopyableVisitOptional(
                    { visit: (object) => (object === null ? -2 : object.value()) },
                    i % 2 === 0 ? i : -1,
                ),
                optionalValue(i),
            ),
        "exported closure return, called with a wrapper": (i) =>
            assert.equal(exports.noncopyableMakeReader()(new NoncopyableObject(i)), i),
        "exported closure return, called with a wrapper, copyable control": (i) =>
            assert.equal(exports.copyableMakeReader()(new NoncopyableObject(i)), i),
        "exported closure return, called with an Int, control": (i) =>
            assert.equal(exports.makeIntReader()(i), i),
        "exported class, init and method": (i) => {
            const box = new Box(i);
            assert.equal(box.value(), i);
            box.release();
        },
        "exported class, property getter": (i) => {
            const box = new Box(i);
            assert.equal(box.object.value(), i);
            box.release();
        },
        "exported class, property setter": (i) => {
            const box = new Box(0);
            box.object = new NoncopyableObject(i);
            assert.equal(box.value(), i);
            box.release();
        },
        "exported class, method parameter": (i) => {
            const box = new Box(0);
            assert.equal(box.take(new NoncopyableObject(i)), i);
            box.release();
        },
        "exported class, computed property getter": () => {
            const box = new Box(0);
            assert.equal(box.made.value(), 9);
            box.release();
        },
        "exported class, optional property getter and setter": (i) => {
            const box = new Box(0);
            box.optionalObject = optionalObject(i);
            const object = box.optionalObject;
            assert.equal(object === null ? -2 : object.value(), optionalValue(i));
            box.release();
        },
        "exported class, static property getter": () => assert.equal(Box.shared.value(), 7),
        "exported class, static property setter": (i) => {
            Box.shared = new NoncopyableObject(i);
            assert.equal(Box.shared.value(), i);
        },
        "exported class, computed static property getter": () => assert.equal(Box.staticMade.value(), 8),
    };
    // Swift creates the stored static on the first read and keeps it.
    assert.equal(Box.shared.value(), 7);
    const kept = referencesKept(swift, paths);
    // A closure returned from an export keeps one reference per call whatever its parameter type.
    const closureReturn = "exported closure return, called with a wrapper";
    assert.equal(kept[closureReturn], kept["exported closure return, called with an Int, control"]);
    assert.equal(kept[`${closureReturn}, copyable control`], kept[closureReturn]);
    const others = Object.keys(paths).filter((name) => !name.startsWith("exported closure return"));
    assert.deepEqual(Object.fromEntries(others.map((name) => [name, kept[name]])), zeros(others));

    const loaded = [];
    for (let i = 0; i < 100; i++) {
        const promise = exports.noncopyableLoad(i);
        const object = await promise;
        assert.equal(object.value(), i);
        loaded.push(promise, object);
    }
    assert.equal(referenceCountOf(swift, loaded), 0);
}

/**
 * @param {any} exports
 * @param {any} swift The `SwiftRuntime` instance.
 */
async function runUniqueArrayExportedPathTests(exports, swift) {
    const Box = exports.NoncopyableObjectBox;
    const paths = {
        "exported function, UniqueArray parameter": (i) =>
            assert.deepEqual(exports.noncopyableTakeAll(makeObjects(i % 5)), range(i % 5)),
        "exported function, UniqueArray return": (i) =>
            assert.deepEqual(
                exports.noncopyableMakeAll(i % 5).map((object) => object.value()),
                range(i % 5),
            ),
        "exported function, UniqueArray passed through": (i) =>
            assert.deepEqual(
                exports.noncopyablePassAll(makeObjects(i % 5)).map((object) => object.value()),
                range(i % 5),
            ),
        "exported function, UniqueArray optional elements": (i) => {
            const objects = Array.from({ length: i % 5 }, (_, j) => optionalObject(j));
            assert.deepEqual(exports.noncopyableTakeAllOptional(objects), objects.map((_, j) => optionalValue(j)));
        },
        "exported function, optional UniqueArray parameter": (i) =>
            assert.deepEqual(
                exports.noncopyableTakeMaybe(i % 2 === 0 ? makeObjects(i % 5) : null),
                i % 2 === 0 ? range(i % 5) : null,
            ),
        "exported function, optional UniqueArray return": (i) => {
            const objects = exports.noncopyableMakeMaybe(i % 2 === 0 ? i % 5 : -1);
            assert.deepEqual(
                objects === null ? null : objects.map((object) => object.value()),
                i % 2 === 0 ? range(i % 5) : null,
            );
        },
        "exported protocol, UniqueArray parameter": (i) => {
            const visitor = {
                visit: (object) => object.value(),
                visitAll: (objects) => objects.reduce((sum, object, index) => sum + object.value() * (index + 1), 0),
                makeAll: makeObjects,
            };
            const weightedSum = range(i % 5).reduce((sum, j) => sum + j * (j + 1), 0);
            assert.equal(exports.noncopyableVisitAll(visitor, makeObjects(i % 5)), weightedSum);
        },
        "exported protocol, UniqueArray return": (i) => {
            const visitor = { visit: (object) => object.value(), visitAll: () => -1, makeAll: makeObjects };
            assert.deepEqual(
                exports.noncopyableVisitorMakeAll(visitor, i % 5).map((object) => object.value()),
                range(i % 5),
            );
        },
        "exported class, UniqueArray property getter and setter": (i) => {
            const box = new Box(0);
            box.objects = makeObjects(i % 5);
            assert.deepEqual(
                box.objects.map((object) => object.value()),
                range(i % 5),
            );
            box.release();
        },
        "exported class, optional UniqueArray property getter and setter": (i) => {
            const box = new Box(0);
            box.maybeObjects = i % 2 === 0 ? makeObjects(i % 5) : null;
            const objects = box.maybeObjects;
            assert.deepEqual(
                objects === null ? null : objects.map((object) => object.value()),
                i % 2 === 0 ? range(i % 5) : null,
            );
            box.release();
        },
    };
    assert.deepEqual(referencesKept(swift, paths), zeros(Object.keys(paths)));

    const loaded = [];
    for (let i = 0; i < 100; i++) {
        const promise = exports.noncopyableLoadAll(i % 4);
        const objects = await promise;
        assert.deepEqual(
            objects.map((object) => object.value()),
            range(i % 4),
        );
        loaded.push(promise, ...objects);
    }
    assert.equal(referenceCountOf(swift, loaded), 0);
}

export function getImports(importsContext) {
    globalThis.noncopyableSharedObject = new NoncopyableObject(7);
    const getSwift = () => importsContext._swift;
    const getExports = () => {
        const exports = importsContext.getExports();
        if (!exports) {
            throw new Error("No exports!?");
        }
        return exports;
    };
    const retainByRef = { calls: 0, counting: false };
    return {
        NoncopyableObject,
        NoncopyableObjectRoundtrip,
        NoncopyableSource: makeSourceClass(getSwift),
        noncopyableMakeObject: (start) => new NoncopyableObject(start),
        noncopyableUseObject: (object) => object.value(),
        NoncopyableJSClassSupportImports: {
            liveReferenceCount: () => liveReferenceCount(getSwift()),
            retainByRefCount: () => {
                if (!retainByRef.counting) {
                    const memory = getSwift().memory;
                    const original = memory.retainByRef.bind(memory);
                    memory.retainByRef = (reference) => {
                        retainByRef.calls++;
                        return original(reference);
                    };
                    retainByRef.counting = true;
                }
                return retainByRef.calls;
            },
            runNoncopyableExportedPathTests: () => runExportedPathTests(getExports(), getSwift()),
            runNoncopyableUniqueArrayExportedPathTests: () => runUniqueArrayExportedPathTests(getExports(), getSwift()),
        },
    };
}
