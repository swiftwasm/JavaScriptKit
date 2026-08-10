// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface JSPublicEvent {
}
export interface JSPackageEvent {
}
export interface JSInternalEvent {
}
export interface JSPublicTarget {
    addPublicListener(handler: (arg0: JSPublicEvent) => void): void;
    addInternalListener(handler: (arg0: JSPublicEvent) => void): void;
}
export interface JSPackageTarget {
    addPackageListener(handler: (arg0: JSPackageEvent) => void): void;
}
export interface JSInternalTarget {
    addInternalListener(handler: (arg0: JSInternalEvent) => void): void;
}
export type Exports = {
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