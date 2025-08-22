// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const APIResult: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
        readonly Flag: 2;
        readonly Rate: 3;
        readonly Precise: 4;
        readonly Info: 5;
    };
};

export type APIResult =
  { tag: typeof APIResult.Tag.Success; value: string } | { tag: typeof APIResult.Tag.Failure; value: number } | { tag: typeof APIResult.Tag.Flag; value: boolean } | { tag: typeof APIResult.Tag.Rate; value: number } | { tag: typeof APIResult.Tag.Precise; value: number } | { tag: typeof APIResult.Tag.Info }

export type Exports = {
    handle(result: APIResult): void;
    getResult(): APIResult;
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