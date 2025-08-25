// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface ArrayBufferLike {
    slice(begin: number, end: number): ArrayBufferLike;
    readonly byteLength: number;
}
export interface WeirdNaming {
    as(): void;
    normalProperty: string;
    for: string;
    Any: string;
}
export type Exports = {
}
export type Imports = {
    createArrayBuffer(): ArrayBufferLike;
    createWeirdObject(): WeirdNaming;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;