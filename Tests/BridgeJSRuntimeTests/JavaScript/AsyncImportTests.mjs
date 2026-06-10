// @ts-check

import assert from 'node:assert';
import { ThemeValues, DirectionValues, FileSizeValues } from '../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.js';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["AsyncImportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsAsyncRoundTripVoid: () => {
            return Promise.resolve();
        },
        jsAsyncRoundTripNumber: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripBool: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripString: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripOptionalString: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripOptionalNumber: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripBoolArray: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripIntArray: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripStringArray: (v) => {
            return Promise.resolve(v);
        },
        jsAsyncRoundTripFeatureFlag: (v) => {
            return Promise.resolve(v);
        },
    };
}

/** @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
export async function runAsyncWorksTests(exports) {
    await exports.asyncRoundTripVoid();

    const asyncPoint = { x: 7, y: 11 };
    assert.deepEqual(await exports.asyncRoundTripPublicPoint(asyncPoint), asyncPoint);
    assert.deepEqual(await exports.asyncRoundTripPublicPointThrows(asyncPoint), asyncPoint);

    const [c1, c2] = await Promise.all([
        exports.asyncRoundTripPublicPoint({ x: 1, y: 2 }),
        exports.asyncRoundTripPublicPoint({ x: 3, y: 4 }),
    ]);
    assert.deepEqual(c1, { x: 1, y: 2 });
    assert.deepEqual(c2, { x: 3, y: 4 });

    assert.deepEqual(await exports.asyncCombinePublicPoints({ x: 1, y: 2 }, { x: 10, y: 20 }), { x: 11, y: 22 });

    assert.deepEqual(await exports.asyncStructOrThrow(false), { x: 1, y: 2 });
    await assert.rejects(
        () => exports.asyncStructOrThrow(true),
        (error) => error instanceof Error && error.message === "async struct failure"
    );

    await assert.rejects(
        () => exports.zeroArgAsyncThrows(),
        (error) => error instanceof Error && error.message === "ZeroArgAsyncThrowsError"
    );

    const richContact = {
        name: "Alice",
        age: 30,
        address: { street: "123 Main St", city: "NYC", zipCode: 10001 },
        email: "alice@test.com",
        secondaryAddress: { street: "456 Oak Ave", city: "LA", zipCode: null },
    };
    assert.deepEqual(await exports.asyncRoundTripContact(richContact), richContact);

    const calc = exports.createCalculator();
    assert.deepEqual(await calc.asyncMakePoint(3, 4), { x: 3, y: 4 });
    calc.release();

    assert.equal(await exports.asyncRoundTripTheme(ThemeValues.Dark), ThemeValues.Dark);
    assert.equal(await exports.asyncRoundTripDirection(DirectionValues.East), DirectionValues.East);

    assert.deepEqual(
        await exports.asyncRoundTripPublicPointArray([{ x: 1, y: 2 }, { x: 3, y: 4 }]),
        [{ x: 1, y: 2 }, { x: 3, y: 4 }]
    );

    assert.equal(await exports.asyncRoundTripOptionalTheme(ThemeValues.Light), ThemeValues.Light);
    assert.equal(await exports.asyncRoundTripOptionalTheme(null), null);
    assert.equal(await exports.asyncRoundTripOptionalDirection(DirectionValues.South), DirectionValues.South);
    assert.equal(await exports.asyncRoundTripOptionalDirection(null), null);

    assert.deepEqual(await exports.asyncRoundTripOptionalPublicPoint({ x: 5, y: 6 }), { x: 5, y: 6 });
    assert.equal(await exports.asyncRoundTripOptionalPublicPoint(null), null);

    assert.deepEqual(
        await exports.asyncRoundTripPublicPointDict({ a: { x: 1, y: 2 }, b: { x: 3, y: 4 } }),
        { a: { x: 1, y: 2 }, b: { x: 3, y: 4 } }
    );

    assert.deepEqual(
        await exports.asyncRoundTripDirectionArray([DirectionValues.North, DirectionValues.East]),
        [DirectionValues.North, DirectionValues.East]
    );
    assert.deepEqual(
        await exports.asyncRoundTripDirectionDict({ a: DirectionValues.North, b: DirectionValues.South }),
        { a: DirectionValues.North, b: DirectionValues.South }
    );

    assert.deepEqual(
        await exports.asyncRoundTripThemeArray([ThemeValues.Light, ThemeValues.Dark]),
        [ThemeValues.Light, ThemeValues.Dark]
    );
    assert.deepEqual(
        await exports.asyncRoundTripThemeDict({ a: ThemeValues.Light, b: ThemeValues.Auto }),
        { a: ThemeValues.Light, b: ThemeValues.Auto }
    );

    assert.equal(await exports.asyncRoundTripFileSize(FileSizeValues.Large), FileSizeValues.Large);
    assert.equal(await exports.asyncRoundTripOptionalFileSize(FileSizeValues.Tiny), FileSizeValues.Tiny);
    assert.equal(await exports.asyncRoundTripOptionalFileSize(null), null);
}
