
/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["DictionarySupportImports"]}
 */
export function getImports(importsContext) {
    return {
        "jsRoundTripDictionaryInt": (dict) => {
            return { ...dict };
        },
        "jsRoundTripDictionaryBool": (dict) => {
            return { ...dict };
        },
        "jsRoundTripDictionaryDouble": (dict) => {
            return { ...dict };
        },
        "jsRoundTripDictionaryJSObject": (dict) => {
            return dict;
        },
        "jsRoundTripDictionaryJSValue": (dict) => {
            return dict;
        },
        "jsRoundTripDictionaryDoubleArray": (dict) => {
            return Object.fromEntries(Object.entries(dict).map(([k, v]) => [k, [...v]]));
        },
    }
}