import { ExportedFunctions } from "./types.js";

/// Memory lifetime of closures in Swift are managed by Swift side
export class SwiftClosureDeallocator {
    private functionRegistry: FinalizationRegistry<number>;

    constructor(exports: ExportedFunctions) {
        if (typeof FinalizationRegistry === "undefined") {
            throw new Error(
                "The Swift part of JavaScriptKit was configured to require " +
                    "the availability of JavaScript WeakRefs. Please build " +
                    "with `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` to " +
                    "disable features that use WeakRefs.",
            );
        }

        this.functionRegistry = new FinalizationRegistry((id) => {
            exports.swjs_free_host_function(id);
        });
    }

    track(func: Function, func_ref: number) {
        this.functionRegistry.register(func, func_ref);
    }
}
