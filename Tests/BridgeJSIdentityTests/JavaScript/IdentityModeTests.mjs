// @ts-check

import assert from "node:assert";

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["IdentityModeTestImports"]}
 */
export function getImports(importsContext) {
    return {
        runJsIdentityModeTests: () => {
            const exports = importsContext.getExports();
            if (!exports) {
                throw new Error("No exports!?");
            }
            runIdentityModeTests(exports);
        },
    };
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runIdentityModeTests(exports) {
    testWrapperIdentity(exports);
    testCacheInvalidationOnRelease(exports);
    testDifferentClassesDontCollide(exports);
    testRetainLeakOnCacheHit(exports);
    testArrayElementIdentity(exports);
    testArrayElementMatchesSingleGetter(exports);
    testArrayRetainLeak(exports);
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testWrapperIdentity(exports) {
    exports.resetSharedSubject();
    const a = exports.getSharedSubject();
    const b = exports.getSharedSubject();

    assert.strictEqual(
        a,
        b,
        "Same Swift object should return identical JS wrapper",
    );
    assert.equal(a.currentValue, 42);

    a.release();
    exports.resetSharedSubject();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testCacheInvalidationOnRelease(exports) {
    exports.resetSharedSubject();
    const first = exports.getSharedSubject();
    first.release();

    exports.resetSharedSubject();
    const second = exports.getSharedSubject();

    assert.notStrictEqual(
        first,
        second,
        "After release + reset, should get a different wrapper",
    );
    assert.equal(second.currentValue, 42);

    second.release();
    exports.resetSharedSubject();
}

/**
 * Verifies that repeated boundary crossings of the same Swift object don't leak
 * retain counts. Each cache hit triggers passRetained on the Swift side. Without
 * the balancing deinit(pointer) call on cache hit, each crossing leaks +1 retain
 * and the object is never deallocated.
 *
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testRetainLeakOnCacheHit(exports) {
    exports.resetRetainLeakDeinits();
    exports.resetRetainLeakSubject();

    const wrappers = [];
    for (let i = 0; i < 10; i++) {
        wrappers.push(exports.getRetainLeakSubject());
    }

    for (let i = 1; i < wrappers.length; i++) {
        assert.strictEqual(
            wrappers[0],
            wrappers[i],
            "All should be the same cached wrapper",
        );
    }

    wrappers[0].release();
    exports.resetRetainLeakSubject();

    assert.strictEqual(
        exports.getRetainLeakDeinits(),
        1,
        "Object should be deallocated after release + reset. " +
            "If deinits == 0, retain leak from unbalanced passRetained on cache hits.",
    );
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testArrayElementIdentity(exports) {
    exports.setupArrayPool(10);
    const arr1 = exports.getArrayPool();
    const arr2 = exports.getArrayPool();

    assert.equal(arr1.length, 10);
    assert.equal(arr2.length, 10);

    for (let i = 0; i < 10; i++) {
        assert.strictEqual(
            arr1[i],
            arr2[i],
            `Array element at index ${i} should be === across calls`,
        );
        assert.equal(arr1[i].tag, i);
    }

    for (const elem of arr1) {
        elem.release();
    }
    exports.clearArrayPool();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testArrayElementMatchesSingleGetter(exports) {
    exports.setupArrayPool(5);
    const arr = exports.getArrayPool();
    const single = exports.getArrayPoolElement(2);

    assert.strictEqual(
        arr[2],
        single,
        "Array element and single getter should return the same wrapper",
    );
    assert.equal(single.tag, 2);

    for (const elem of arr) {
        elem.release();
    }
    exports.clearArrayPool();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testArrayRetainLeak(exports) {
    exports.resetArrayPoolDeinits();
    exports.setupArrayPool(5);

    for (let round = 0; round < 10; round++) {
        exports.getArrayPool();
    }

    const arr = exports.getArrayPool();
    for (const elem of arr) {
        elem.release();
    }

    exports.clearArrayPool();

    assert.strictEqual(
        exports.getArrayPoolDeinits(),
        5,
        "All 5 pool objects should be deallocated after release + clear. " +
            "If deinits < 5, retain leak from unbalanced passRetained in array returns.",
    );
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function testDifferentClassesDontCollide(exports) {
    const subject1 = new exports.IdentityTestSubject(1);
    const subject2 = new exports.IdentityTestSubject(2);

    assert.notStrictEqual(
        subject1,
        subject2,
        "Different instances should not be ===",
    );
    assert.equal(subject1.currentValue, 1);
    assert.equal(subject2.currentValue, 2);

    subject1.release();
    subject2.release();
}
