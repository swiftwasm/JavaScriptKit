export class JSClassWithArrayMembers {
    constructor(numbers, labels) {
        this.numbers = numbers;
        this.labels = labels;
    }
    concatNumbers(values) {
        return [...this.numbers, ...values];
    }
    concatLabels(values) {
        return [...this.labels, ...values];
    }
    firstLabel(values) {
        const merged = [...values, ...this.labels];
        return merged.length > 0 ? merged[0] : "";
    }
};

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["JSClassSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        makeJSClassWithArrayMembers: (numbers, labels) => {
            return new JSClassWithArrayMembers(numbers, labels);
        },
    };
}