/** @type {import('./../.build/plugins/PackageToJS/outputs/PackageTests/test.d.ts').Prelude["setupOptions"]} */
export function setupOptions(options, context) {
    return {
        ...options,
        addToCoreImports(importObject) {
            options.addToCoreImports?.(importObject);
            importObject["JavaScriptEventLoopTestSupportTests"] = {
                "isMainThread": () => context.isMainThread,
            }
        }
    }
}
