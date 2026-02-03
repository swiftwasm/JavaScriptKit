// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface PointerFields {
    raw: number;
    mutRaw: number;
    opaque: number;
    ptr: number;
    mutPtr: number;
}
export type Exports = {
    takeUnsafeRawPointer(p: number): void;
    takeUnsafeMutableRawPointer(p: number): void;
    takeOpaquePointer(p: number): void;
    takeUnsafePointer(p: number): void;
    takeUnsafeMutablePointer(p: number): void;
    returnUnsafeRawPointer(): number;
    returnUnsafeMutableRawPointer(): number;
    returnOpaquePointer(): number;
    returnUnsafePointer(): number;
    returnUnsafeMutablePointer(): number;
    roundTripPointerFields(value: PointerFields): PointerFields;
    PointerFields: {
        init(raw: number, mutRaw: number, opaque: number, ptr: number, mutPtr: number): PointerFields;
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