/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["SwiftClassSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsRoundTripGreeter: (greeter) => {
            return greeter;
        },
        jsRoundTripUUID: (uuid) => {
            return uuid;
        },
        jsRoundTripOptionalGreeter: (greeter) => {
            return greeter;
        },
        jsConsumeLeakCheck: (value) => {
            // Explicitly release on JS side to mimic user cleanup.
            value.release();
        },
        jsConsumeOptionalLeakCheck: (value) => {
            if (value) {
                value.release();
            }
        },
    };
}
