// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const Direction: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
export type Direction = typeof Direction[keyof typeof Direction];

export const Status: {
    readonly Loading: 0;
    readonly Success: 1;
    readonly Error: 2;
};
export type Status = typeof Status[keyof typeof Status];

export type Exports = {
    setDirection(direction: Direction): void;
    getDirection(): Direction;
    processDirection(input: Direction): Status;
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