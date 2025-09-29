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
export type DirectionTag = typeof Direction[keyof typeof Direction];

export const Status: {
    readonly Loading: 0;
    readonly Success: 1;
    readonly Error: 2;
};
export type StatusTag = typeof Status[keyof typeof Status];

export enum TSDirection {
    North = 0,
    South = 1,
    East = 2,
    West = 3,
}

export const PublicStatus: {
    readonly Success: 0;
};
export type PublicStatusTag = typeof PublicStatus[keyof typeof PublicStatus];

export type Exports = {
    setDirection(direction: Direction): void;
    getDirection(): Direction;
    processDirection(input: Direction): Status;
    roundTripOptionalDirection(input: Direction | null): Direction | null;
    setTSDirection(direction: TSDirection): void;
    getTSDirection(): TSDirection;
    roundTripOptionalTSDirection(input: TSDirection | null): TSDirection | null;
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