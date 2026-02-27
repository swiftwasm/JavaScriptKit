// @ts-check

import assert from 'node:assert';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["DefaultArgumentImports"]}
 */
export function getImports(importsContext) {
    return {
        runJsDefaultArgumentTests: () => {
            const exports = importsContext.getExports();
            if (!exports) { throw new Error("No exports!?"); }
            runJsDefaultArgumentTests(exports);
        },
    };
}

/**
 * Default argument bridging coverage for BridgeJS runtime tests.
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} rootExports
 */
export function runJsDefaultArgumentTests(rootExports) {
    const exports = rootExports.DefaultArgumentExports;
    const { Status, Direction, Theme } = rootExports;

    assert.equal(exports.testStringDefault(), "Hello World");
    assert.equal(exports.testStringDefault("Custom Message"), "Custom Message");

    assert.equal(exports.testIntDefault(), 42);
    assert.equal(exports.testIntDefault(100), 100);

    assert.equal(exports.testBoolDefault(), true);
    assert.equal(exports.testBoolDefault(false), false);

    assert.equal(exports.testOptionalDefault(), null);
    assert.equal(exports.testOptionalDefault("Test"), "Test");

    assert.equal(exports.testMultipleDefaults(), "Default Title: -10 (false)");
    assert.equal(exports.testMultipleDefaults("Custom"), "Custom: -10 (false)");
    assert.equal(exports.testMultipleDefaults("Custom", 5), "Custom: 5 (false)");
    assert.equal(exports.testMultipleDefaults("Custom", undefined, true), "Custom: -10 (true)");
    assert.equal(exports.testMultipleDefaults("Custom", 5, true), "Custom: 5 (true)");

    assert.equal(exports.testSimpleEnumDefault(), Status.Success);
    assert.equal(exports.testSimpleEnumDefault(Status.Loading), Status.Loading);

    assert.equal(exports.testDirectionDefault(), Direction.North);
    assert.equal(exports.testDirectionDefault(Direction.South), Direction.South);

    assert.equal(exports.testRawStringEnumDefault(), Theme.Light);
    assert.equal(exports.testRawStringEnumDefault(Theme.Dark), Theme.Dark);

    const holder = exports.testEmptyInit();
    assert.notEqual(holder, null);
    holder.release();

    const customHolder = new rootExports.StaticPropertyHolder();
    assert.deepEqual(exports.testEmptyInit(customHolder), customHolder);
    customHolder.release();

    assert.equal(exports.testComplexInit(), "Hello, DefaultGreeter!");
    const customGreeter = new rootExports.Greeter("CustomName");
    assert.equal(exports.testComplexInit(customGreeter), "Hello, CustomName!");
    customGreeter.release();

    const cd1 = exports.createConstructorDefaults();
    assert.equal(exports.describeConstructorDefaults(cd1), "Default:42:true:success:nil");
    cd1.release();

    const cd2 = exports.createConstructorDefaults("Custom");
    assert.equal(exports.describeConstructorDefaults(cd2), "Custom:42:true:success:nil");
    cd2.release();

    const cd3 = exports.createConstructorDefaults("Custom", 100);
    assert.equal(exports.describeConstructorDefaults(cd3), "Custom:100:true:success:nil");
    cd3.release();

    const cd4 = exports.createConstructorDefaults("Custom", undefined, false);
    assert.equal(exports.describeConstructorDefaults(cd4), "Custom:42:false:success:nil");
    cd4.release();

    const cd5 = exports.createConstructorDefaults("Test", 99, false, Status.Loading);
    assert.equal(exports.describeConstructorDefaults(cd5), "Test:99:false:loading:nil");
    cd5.release();

    assert.equal(exports.arrayWithDefault(), 6);
    assert.equal(exports.arrayWithDefault([10, 20]), 30);
    assert.equal(exports.arrayWithOptionalDefault(), -1);
    assert.equal(exports.arrayWithOptionalDefault(null), -1);
    assert.equal(exports.arrayWithOptionalDefault([5, 5]), 10);
    assert.equal(exports.arrayMixedDefaults(), "Sum: 30!");
    assert.equal(exports.arrayMixedDefaults("Total"), "Total: 30!");
    assert.equal(exports.arrayMixedDefaults("Total", [1, 2, 3]), "Total: 6!");
    assert.equal(exports.arrayMixedDefaults("Val", [100], "?"), "Val: 100?");
    assert.equal(exports.arrayMixedDefaults(undefined, [5, 5]), "Sum: 10!");
    assert.equal(exports.arrayMixedDefaults(undefined, undefined, "?"), "Sum: 30?");
}
