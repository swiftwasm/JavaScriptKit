// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const AsyncPayloadResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
        readonly Idle: 2;
    };
};

export type AsyncPayloadResultTag =
  { tag: typeof AsyncPayloadResultValues.Tag.Success; param0: string } | { tag: typeof AsyncPayloadResultValues.Tag.Failure; param0: number } | { tag: typeof AsyncPayloadResultValues.Tag.Idle }

export type AsyncPayloadResultObject = typeof AsyncPayloadResultValues;

export type Exports = {
    asyncRoundTripAssociatedValueEnum(value: AsyncPayloadResultTag): Promise<AsyncPayloadResultTag>;
    asyncRoundTripOptionalAssociatedValueEnum(value: AsyncPayloadResultTag | null): Promise<AsyncPayloadResultTag | null>;
    AsyncPayloadResult: AsyncPayloadResultObject
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