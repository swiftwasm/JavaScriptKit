// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface Source {
    value(): number;
}

export interface PointSource {
    point(): Point;
    readonly origin: Point;
}

export const DirectionValues: {
    readonly North: 0;
    readonly South: 1;
};
export type DirectionTag = typeof DirectionValues[keyof typeof DirectionValues];

export const LevelValues: {
    readonly Low: "low";
    readonly High: "high";
};
export type LevelTag = typeof LevelValues[keyof typeof LevelValues];

export const ShapeValues: {
    readonly Tag: {
        readonly Circle: 0;
        readonly Square: 1;
    };
};

export type ShapeTag =
  { tag: typeof ShapeValues.Tag.Circle; param0: number } | { tag: typeof ShapeValues.Tag.Square; param0: number }

export interface Point {
    x: number;
}
export type DirectionObject = typeof DirectionValues;

export type LevelObject = typeof LevelValues;

export type ShapeObject = typeof ShapeValues;

export namespace Geometry {
    export interface Box {
        side: number;
    }
}
export namespace Library {
    export interface Shelf {
        label: string;
    }
}
/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Counter extends SwiftHeapObject {
}
export interface Library extends SwiftHeapObject {
}
export interface TagReference extends SwiftHeapObject {
}
export interface Element {
    id(): number;
}
export interface Canvas {
    element(): Element;
}
export interface NoncopyableObject {
    id(): number;
}
export type Exports = {
    mix(point: Point, body: (arg0: Point, arg1: LevelTag) => DirectionTag): number;
    loadPoint(): Promise<Point>;
    countObjects(body: (arg0: NoncopyableObject[], arg1: Point) => number): number;
    Direction: DirectionObject
    Level: LevelObject
    Shape: ShapeObject
    Counter: {
        new(): Counter;
    },
    Library: {
        new(): Library;
    },
    TagReference: {
        new(name: string): TagReference;
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