// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const SignalValues: {
    readonly Ready: "ready";
};
export type SignalTag = typeof SignalValues[keyof typeof SignalValues];

export interface Meta {
    note: string;
}
export type SignalObject = typeof SignalValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Mallet extends SwiftHeapObject {
}
export interface Hammer extends SwiftHeapObject {
}
export type Exports = {
    Signal: SignalObject
    Meta: {
        init(note: string): Meta;
    },
    app: {
        Toolbox: {
            Hammer: {
                new(): Hammer;
            },
            Mallet: {
                new(): Mallet;
            },
        },
    },
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