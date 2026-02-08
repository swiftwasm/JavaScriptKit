/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["SwiftClassSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsRoundTripGreeter: (greeter) => {
            return greeter;
        },
    };
}