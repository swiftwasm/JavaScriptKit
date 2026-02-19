/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["SwiftClassSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsRoundTripGreeter: (greeter) => {
            return greeter;
        },
        jsRoundTripOptionalGreeter: (greeter) => {
            return greeter;
        },
        jsSabotageAndReleaseGreeter: (greeter) => {
            greeter.__swiftHeapObjectState.deinit = () => {
                throw new WebAssembly.RuntimeError("simulated Wasm teardown");
            };
            greeter.release();
        },
    };
}
