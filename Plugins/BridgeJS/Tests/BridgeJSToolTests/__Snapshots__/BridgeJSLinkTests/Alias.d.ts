// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface HasOptionalUserId {
    readonly userId: number | null;
}

export const InnerTagValues: {
    readonly Tag: {
        readonly Payload: 0;
        readonly Empty: 1;
    };
};

export type InnerTagTag =
  { tag: typeof InnerTagValues.Tag.Payload; param0: number } | { tag: typeof InnerTagValues.Tag.Empty }

export type InnerTagObject = typeof InnerTagValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface PolygonReference extends SwiftHeapObject {
    snapshot(): PolygonReference;
    merge(other: PolygonReference): PolygonReference;
}
export interface TagReference extends SwiftHeapObject {
}
export interface Surface {
    readonly label: string;
}
export type Exports = {
    roundtripPolygon(polygon: PolygonReference): PolygonReference;
    optionalPolygon(polygon: PolygonReference | null): PolygonReference | null;
    polygonArray(polygons: PolygonReference[]): PolygonReference[];
    validatePolygon(polygon: PolygonReference): PolygonReference;
    makeTag(name: string): TagReference;
    roundtripTags(xs: (InnerTagTag | null)[]): (InnerTagTag | null)[];
    describeUser(owner: HasOptionalUserId): HasOptionalUserId;
    InnerTag: InnerTagObject
    PolygonReference: {
        new(underlying: PolygonReference): PolygonReference;
        origin(): PolygonReference;
    },
    TagReference: {
        new(underlying: TagReference): TagReference;
    },
}
export type Imports = {
    acceptTagged(tagged: string): void;
    acceptOptionalTagged(tagged: string | null): void;
    roundtripTagged(tagged: string): string;
    produceOptionalCanvas(): Surface | null;
    Surface: {
        new(): Surface;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;