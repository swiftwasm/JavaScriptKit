// @ts-check

import assert from 'node:assert';

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports}
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
        fetchWeatherData: (city) => {
            return Promise.resolve({
                temperature: city === "London" ? 15.5 : 25.0,
                description: city === "London" ? "Cloudy" : "Sunny",
                humidity: city === "London" ? 80 : 40,
            });
        },
        runAsyncWorks: async () => {
            const exports = importsContext.getExports();
            if (!exports) {
                throw new Error("No exports!?");
            }
            await runAsyncWorksTests(exports);
            return;
        },
    };
}

/** @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
async function runAsyncWorksTests(exports) {
    await exports.asyncRoundTripVoid();
}
