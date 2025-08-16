// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export {};

declare global {
    namespace Utils {
        namespace Converters {
            class Converter {
                constructor();
                toString(value: number): string;
            }
        }
    }
    namespace __Swift {
        namespace Foundation {
            class Greeter {
                constructor(name: string);
                greet(): string;
            }
            class UUID {
                uuidString(): string;
            }
        }
    }
    namespace MyModule {
        namespace Utils {
            function namespacedFunction(): string;
        }
    }
}

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
export type Exports = {
    Greeter: {
        constructor(name: string): Greeter;
    }
    Converter: {
        constructor(): Converter;
    }
    UUID: {
    }
    plainFunction(): string;
    namespacedFunction(): string;
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