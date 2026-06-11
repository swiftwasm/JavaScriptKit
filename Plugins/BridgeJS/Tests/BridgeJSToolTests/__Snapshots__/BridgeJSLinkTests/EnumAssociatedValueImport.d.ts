// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const PayloadSignalValues: {
    readonly Tag: {
        readonly Start: 0;
        readonly Stop: 1;
        readonly Idle: 2;
    };
};

export type PayloadSignalTag =
  { tag: typeof PayloadSignalValues.Tag.Start; param0: string } | { tag: typeof PayloadSignalValues.Tag.Stop; param0: number } | { tag: typeof PayloadSignalValues.Tag.Idle }

export type PayloadSignalObject = typeof PayloadSignalValues;

export interface PayloadSignalControls {
    send(signal: PayloadSignalTag): void;
    current(): PayloadSignalTag;
    roundTripOptional(signal: PayloadSignalTag | null): PayloadSignalTag | null;
}
export type Exports = {
    PayloadSignal: PayloadSignalObject
}
export type Imports = {
    PayloadSignalControls: {
        roundTrip(signal: PayloadSignalTag): PayloadSignalTag;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;