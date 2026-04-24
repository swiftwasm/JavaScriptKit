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
export interface CachedModel extends SwiftHeapObject {
    name: string;
}
export interface UncachedModel extends SwiftHeapObject {
    value: number;
}
export interface ExplicitlyUncachedModel extends SwiftHeapObject {
    count: number;
}
export type Exports = {
    CachedModel: {
        new(name: string): CachedModel;
    }
    UncachedModel: {
        new(value: number): UncachedModel;
    }
    ExplicitlyUncachedModel: {
        new(count: number): ExplicitlyUncachedModel;
    }
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