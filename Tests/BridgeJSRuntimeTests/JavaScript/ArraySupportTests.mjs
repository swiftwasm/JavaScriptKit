// @ts-check

export class ArrayElementObject {
    constructor(id) {
        this.id = id;
    }
}

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["ArraySupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsIntArrayLength: function (items) {
            return items.length;
        },
        jsRoundTripIntArray: function (items) {
            return items;
        },
        jsRoundTripNumberArray: function (values) {
            return values;
        },
        jsRoundTripStringArray: function (values) {
            return values;
        },
        jsRoundTripBoolArray: function (values) {
            return values;
        },
        jsRoundTripJSValueArray: (values) => {
            return values;
        },
        jsRoundTripOptionalJSValueArray: (values) => {
            return values ?? null;
        },
        jsSumNumberArray: (values) => {
            return values.reduce((a, b) => a + b, 0);
        },
        jsCreateNumberArray: function () {
            return [1, 2, 3, 4, 5];
        },
        jsRoundTripJSObjectArray: (values) => {
            return values;
        },
        jsRoundTripJSClassArray: (values) => {
            return values;
        },
    };
}