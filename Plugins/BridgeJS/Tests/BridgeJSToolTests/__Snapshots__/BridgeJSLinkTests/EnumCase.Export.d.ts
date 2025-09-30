// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const DirectionValues: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
export type DirectionTag = typeof DirectionValues[keyof typeof DirectionValues];

export const StatusValues: {
    readonly Loading: 0;
    readonly Success: 1;
    readonly Error: 2;
};
export type StatusTag = typeof StatusValues[keyof typeof StatusValues];

export enum TSDirection {
    North = 0,
    South = 1,
    East = 2,
    West = 3,
}

export const PublicStatusValues: {
    readonly Success: 0;
};
export type PublicStatusTag = typeof PublicStatusValues[keyof typeof PublicStatusValues];

export type DirectionObject = typeof DirectionValues;

export type StatusObject = typeof StatusValues;

export type PublicStatusObject = typeof PublicStatusValues;

export type Exports = {
    setDirection(direction: DirectionTag): void;
    getDirection(): DirectionTag;
    processDirection(input: DirectionTag): StatusTag;
    roundTripOptionalDirection(input: DirectionTag | null): DirectionTag | null;
    setTSDirection(direction: TSDirectionTag): void;
    getTSDirection(): TSDirectionTag;
    roundTripOptionalTSDirection(input: TSDirectionTag | null): TSDirectionTag | null;
    Direction: DirectionObject
    Status: StatusObject
    PublicStatus: PublicStatusObject
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