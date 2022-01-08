import { SwiftRuntimeExportedFunctions } from "./types";

/// Memory lifetime of closures in Swift are managed by Swift side
export class SwiftClosureHeap {
    private functionRegistry: FinalizationRegistry<number>;

    constructor(exports: SwiftRuntimeExportedFunctions) {
        this.functionRegistry = new FinalizationRegistry((id) => {
            exports.swjs_free_host_function(id);
        });
    }

    alloc(func: any, func_ref: number) {
        this.functionRegistry.register(func, func_ref);
    }
}
