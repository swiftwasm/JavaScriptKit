import assert from "node:assert";
import { AsyncPayloadResultValues } from '../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.js';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["ClosureAsyncImports"]}
 */
export function getImports(importsContext) {
    return {
        runJsClosureAsyncTests: async () => {
            const exports = importsContext.getExports();
            if (!exports) {
                throw new Error("No exports!?");
            }
            await runJsClosureAsyncTests(exports);
        },
    };
}

/** @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
export async function runJsClosureAsyncTests(exports) {
    assert.equal(
        await exports.awaitAsyncCallback(async (req) => {
            await Promise.resolve();
            return `js-${req}`;
        }),
        "swift-saw:js-request",
    );

    let directionAReject = null;
    try {
        await exports.awaitAsyncCallback(async () => {
            throw new Error("CallbackRejected");
        });
        assert.fail("Expected awaitAsyncCallback to reject when the JS callback rejects");
    } catch (error) {
        directionAReject = error;
    }
    assert.notEqual(directionAReject, null);
    assert.equal(directionAReject.message, "CallbackRejected");

    const parser = exports.makeAsyncParser();

    const parsed = parser("42");
    assert.ok(parsed instanceof Promise, "async closure must return a Promise");
    assert.equal(await parsed, "parsed:42");
    assert.equal(await parser("-7"), "parsed:-7");

    let directionBReject = null;
    try {
        await parser("not-a-number");
        assert.fail("Expected makeAsyncParser closure to reject for invalid input");
    } catch (error) {
        directionBReject = error;
    }
    assert.notEqual(directionBReject, null);
    assert.equal(directionBReject.message, "AsyncParseError: not-a-number");

    assert.equal(await parser("100"), "parsed:100");

    const echo = exports.makeAsyncEcho();
    const echoed = echo("hi");
    assert.ok(echoed instanceof Promise, "non-throwing async closure must return a Promise");
    assert.equal(await echoed, "echo:hi");

    const recorder = exports.makeAsyncRecorder();
    const recorded = recorder("logged-value");
    assert.ok(recorded instanceof Promise, "Void async closure must return a Promise");
    assert.equal(await recorded, undefined);
    assert.equal(exports.lastRecordedValue(), "logged-value");

    let voidReject = null;
    try {
        await recorder("boom");
        assert.fail("Expected makeAsyncRecorder closure to reject for 'boom'");
    } catch (error) {
        voidReject = error;
    }
    assert.notEqual(voidReject, null);
    assert.equal(voidReject.message, "AsyncRecorderError");

    const payloadLoader = exports.makeAsyncPayloadLoader();
    const payloadPromise = payloadLoader(true);
    assert.ok(payloadPromise instanceof Promise, "associated-value enum async closure must return a Promise");
    assert.deepEqual(await payloadPromise, { tag: AsyncPayloadResultValues.Tag.Success, param0: "loaded" });
    assert.deepEqual(await payloadLoader(false), { tag: AsyncPayloadResultValues.Tag.Failure, param0: 42 });

    assert.equal(
        await exports.awaitPayloadCallback(async (succeed) => {
            await Promise.resolve();
            return succeed
                ? { tag: AsyncPayloadResultValues.Tag.Success, param0: "js" }
                : { tag: AsyncPayloadResultValues.Tag.Idle };
        }),
        "success:js|idle",
    );

    const pointMaker = exports.makeAsyncPointMaker();
    const pointPromise = pointMaker(3);
    assert.ok(pointPromise instanceof Promise, "struct-returning async closure must return a Promise");
    const point = await pointPromise;
    assert.equal(point.x, 3);
    assert.equal(point.y, 6);
    assert.equal(point.label, "async:3.0");

    {
        const racer = exports.makeAsyncEcho();
        const inFlight = racer("race");
        if (typeof racer.release === "function") {
            racer.release();
        }
        if (typeof global !== "undefined" && typeof global.gc === "function") {
            global.gc();
        }
        assert.equal(await inFlight, "echo:race");
    }

    {
        const concurrent = exports.makeAsyncEcho();
        const promises = [];
        for (let i = 0; i < 16; i++) {
            promises.push(concurrent("c" + i));
        }
        const results = await Promise.all(promises);
        for (let i = 0; i < 16; i++) {
            assert.equal(results[i], "echo:c" + i);
        }
        if (typeof concurrent.release === "function") {
            concurrent.release();
        }
    }
}
