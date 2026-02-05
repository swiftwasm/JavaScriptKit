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
export interface Box extends SwiftHeapObject {
}
export type Exports = {
    Box: {
    }
    mirrorDictionary(values: Record<string, number>): Record<string, number>;
    optionalDictionary(values: Record<string, string> | null): Record<string, string> | null;
    nestedDictionary(values: Record<string, number[]>): Record<string, number[]>;
    boxDictionary(boxes: Record<string, Box>): Record<string, Box>;
    optionalBoxDictionary(boxes: Record<string, Box | null>): Record<string, Box | null>;
}
export type Imports = {
    importMirrorDictionary(values: Record<string, number>): Record<string, number>;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;