// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type Exports = {
    processBytes(data: Uint8Array): Uint8Array;
    processFloats(data: Float32Array): Float32Array;
    processGenericDoubles(data: Float64Array): Float64Array;
    processGenericInts(data: Int32Array): Int32Array;
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