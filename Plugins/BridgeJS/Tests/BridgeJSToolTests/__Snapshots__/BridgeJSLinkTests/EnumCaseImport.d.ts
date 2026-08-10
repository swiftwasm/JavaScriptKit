// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const SignalValues: {
    readonly Start: 0;
    readonly Stop: 1;
};
export type SignalTag = typeof SignalValues[keyof typeof SignalValues];

export type SignalObject = typeof SignalValues;

export interface SignalControls {
    send(signal: SignalTag): void;
    current(): SignalTag;
}
export type Exports = {
    Signal: SignalObject
}
export type Imports = {
    SignalControls: {
        roundTrip(signal: SignalTag): SignalTag;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;