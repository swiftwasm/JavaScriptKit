// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
/**
 * A greeter living in a namespace.
 */
export interface Greeter extends SwiftHeapObject {
    /**
     * Produces a greeting for the configured name.
     * @returns The greeting message.
     */
    greet(): string;
}
export interface Converter extends SwiftHeapObject {
    toString(value: number): string;
}
export interface UUID extends SwiftHeapObject {
    uuidString(): string;
}
export interface Container extends SwiftHeapObject {
    getItems(): Greeter[];
    addItem(item: Greeter): void;
}
export type Exports = {
    plainFunction(): string;
    Collections: {
        Container: {
            new(): Container;
        },
    },
    MyModule: {
        Utils: {
            /**
             * A namespaced free function.
             * @returns A fixed namespaced string.
             */
            namespacedFunction(): string;
        },
    },
    Utils: {
        Converters: {
            Converter: {
                new(): Converter;
            },
        },
    },
    __Swift: {
        Foundation: {
            Greeter: {
                new(name: string): Greeter;
                makeDefault(): Greeter;
                readonly defaultGreeting: string;
            },
            UUID: {
            },
        },
    },
}
export type Imports = {
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;