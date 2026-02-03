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
    readonly Pending: 0;
    readonly Active: 1;
    readonly Completed: 2;
};
export type StatusTag = typeof StatusValues[keyof typeof StatusValues];

export interface Point {
    x: number;
    y: number;
}
export type DirectionObject = typeof DirectionValues;

export type StatusObject = typeof StatusValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Item extends SwiftHeapObject {
}
export type Exports = {
    Item: {
    }
    processIntArray(values: number[]): number[];
    processStringArray(values: string[]): string[];
    processDoubleArray(values: number[]): number[];
    processBoolArray(values: boolean[]): boolean[];
    processPointArray(points: Point[]): Point[];
    processDirectionArray(directions: DirectionTag[]): DirectionTag[];
    processStatusArray(statuses: StatusTag[]): StatusTag[];
    sumIntArray(values: number[]): number;
    findFirstPoint(points: Point[], matching: string): Point;
    processUnsafeRawPointerArray(values: number[]): number[];
    processUnsafeMutableRawPointerArray(values: number[]): number[];
    processOpaquePointerArray(values: number[]): number[];
    processOptionalIntArray(values: (number | null)[]): (number | null)[];
    processOptionalStringArray(values: (string | null)[]): (string | null)[];
    processOptionalArray(values: number[] | null): number[] | null;
    processOptionalPointArray(points: (Point | null)[]): (Point | null)[];
    processOptionalDirectionArray(directions: (DirectionTag | null)[]): (DirectionTag | null)[];
    processOptionalStatusArray(statuses: (StatusTag | null)[]): (StatusTag | null)[];
    processNestedIntArray(values: number[][]): number[][];
    processNestedStringArray(values: string[][]): string[][];
    processNestedPointArray(points: Point[][]): Point[][];
    processItemArray(items: Item[]): Item[];
    processNestedItemArray(items: Item[][]): Item[][];
    Direction: DirectionObject
    Status: StatusObject
}
export type Imports = {
    checkArray(a: any): void;
    checkArrayWithLength(a: any, b: number): void;
    checkArray(a: any): void;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;