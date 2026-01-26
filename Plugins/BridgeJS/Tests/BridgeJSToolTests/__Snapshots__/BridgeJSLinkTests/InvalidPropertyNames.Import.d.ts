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
    try(): void;
    normalProperty: string;
    "property-with-dashes": number;
    "123invalidStart": boolean;
    "property with spaces": string;
    "@specialChar": number;
    constructor: string;
    for: string;
    Any: string;
}
export interface _Weird {
    "method-with-dashes"(): void;
}
export interface _Weird {
}
export type Exports = {
}
export type Imports = {
    createArrayBuffer(): ArrayBufferLike;
    createWeirdObject(): WeirdNaming;
    createWeirdClass(): _Weird;
    _Weird: {
        new(): _Weird;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;