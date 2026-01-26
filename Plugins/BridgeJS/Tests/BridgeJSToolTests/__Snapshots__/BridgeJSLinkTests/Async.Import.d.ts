// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type Exports = {
}
export type Imports = {
    asyncReturnVoid(): JSPromise;
    asyncRoundTripInt(v: number): JSPromise;
    asyncRoundTripString(v: string): JSPromise;
    asyncRoundTripBool(v: boolean): JSPromise;
    asyncRoundTripFloat(v: number): JSPromise;
    asyncRoundTripDouble(v: number): JSPromise;
    asyncRoundTripJSObject(v: any): JSPromise;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;