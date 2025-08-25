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
  { tag: typeof APIResult.Tag.Success; param0: string } | { tag: typeof APIResult.Tag.Failure; param0: number } | { tag: typeof APIResult.Tag.Flag; param0: boolean } | { tag: typeof APIResult.Tag.Rate; param0: number } | { tag: typeof APIResult.Tag.Precise; param0: number } | { tag: typeof APIResult.Tag.Info }

export const ComplexResult: {
    readonly Tag: {
        readonly Success: 0;
        readonly Error: 1;
        readonly Status: 2;
        readonly Info: 3;
    };
};

export type ComplexResult =
  { tag: typeof ComplexResult.Tag.Success; param0: string } | { tag: typeof ComplexResult.Tag.Error; param0: string; param1: number } | { tag: typeof ComplexResult.Tag.Status; param0: boolean; param1: string } | { tag: typeof ComplexResult.Tag.Info }

export type Exports = {
    handle(result: APIResult): void;
    getResult(): APIResult;
    handleComplex(result: ComplexResult): void;
    getComplexResult(): ComplexResult;
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