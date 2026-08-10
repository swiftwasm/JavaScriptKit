// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type Exports = {
    roundTripInt8(v: number): number;
    roundTripUInt8(v: number): number;
    roundTripInt16(v: number): number;
    roundTripUInt16(v: number): number;
    roundTripInt32(v: number): number;
    roundTripUInt32(v: number): number;
    roundTripInt64(v: bigint): bigint;
    roundTripUInt64(v: bigint): bigint;
}
export type Imports = {
    roundTripInt8(v: number): number;
    roundTripUInt8(v: number): number;
    roundTripInt16(v: number): number;
    roundTripUInt16(v: number): number;
    roundTripInt32(v: number): number;
    roundTripUInt32(v: number): number;
    roundTripInt64(v: bigint): bigint;
    roundTripUInt64(v: bigint): bigint;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;