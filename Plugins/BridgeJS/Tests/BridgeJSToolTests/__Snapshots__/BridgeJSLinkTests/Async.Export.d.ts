// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type Exports = {
    asyncReturnVoid(): Promise<void>;
    asyncRoundTripInt(v: number): Promise<number>;
    asyncRoundTripString(v: string): Promise<string>;
    asyncRoundTripBool(v: boolean): Promise<boolean>;
    asyncRoundTripFloat(v: number): Promise<number>;
    asyncRoundTripDouble(v: number): Promise<number>;
    asyncRoundTripJSObject(v: any): Promise<any>;
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