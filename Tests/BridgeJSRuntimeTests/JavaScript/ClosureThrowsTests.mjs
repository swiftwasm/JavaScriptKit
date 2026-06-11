import assert from "node:assert";

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["ClosureThrowsImports"]}
 */
export function getImports(importsContext) {
    return {
        runJsClosureThrowsTests: () => {
            const exports = importsContext.getExports();
            if (!exports) {
                throw new Error("No exports!?");
            }
            runJsClosureThrowsTests(exports);
        },
    };
}

/** @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
export function runJsClosureThrowsTests(exports) {
    const parser = exports.makeThrowingParser();

    assert.equal(parser("42"), 42);
    assert.equal(parser("-7"), -7);

    let caught = null;
    try {
        parser("not-a-number");
        assert.fail("Expected makeThrowingParser closure to throw for invalid input");
    } catch (error) {
        caught = error;
    }
    assert.notEqual(caught, null);
    assert.equal(caught.message, "ParseError: not-a-number");

    assert.equal(parser("100"), 100);

    assert.equal(
        exports.runValidator((value) => value === "input"),
        true,
    );
    assert.equal(
        exports.runValidator((value) => value === "something-else"),
        false,
    );

    let propagated = null;
    try {
        exports.runValidator(() => {
            throw new Error("ValidatorError");
        });
        assert.fail("Expected runValidator to propagate the JS callback error");
    } catch (error) {
        propagated = error;
    }
    assert.notEqual(propagated, null);
    assert.equal(propagated.message, "ValidatorError");
}
