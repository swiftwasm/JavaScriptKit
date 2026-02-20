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
export interface Greeter extends SwiftHeapObject {
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
        }
    },
    MyModule: {
        Utils: {
            namespacedFunction(): string;
        },
    },
    Utils: {
        Converters: {
            Converter: {
                new(): Converter;
            }
        },
    },
    __Swift: {
        Foundation: {
            Greeter: {
                new(name: string): Greeter;
            }
            UUID: {
            }
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