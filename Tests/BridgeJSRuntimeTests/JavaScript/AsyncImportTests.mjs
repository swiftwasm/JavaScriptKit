// @ts-check

import assert from 'node:assert';

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
}
