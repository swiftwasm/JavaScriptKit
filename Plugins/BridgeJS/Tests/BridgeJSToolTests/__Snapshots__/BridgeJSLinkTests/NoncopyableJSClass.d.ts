// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface NoncopyableObjectSource {
    name(): string;
    makeAll(count: number): NoncopyableObject[];
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface NoncopyableObjectBox extends SwiftHeapObject {
    object: NoncopyableObject;
}
export interface NoncopyableObject {
    value(): number;
    readonly name: string;
}
export interface NoncopyableObjectRoundtrip {
    take(object: NoncopyableObject): number;
    adopt(object: NoncopyableObject): number;
    make(start: number): NoncopyableObject;
    find(start: number): NoncopyableObject | null;
    takeOptional(object: NoncopyableObject | null): number;
    forEach(body: (arg0: NoncopyableObject) => void): void;
    load(start: number): Promise<NoncopyableObject>;
    takeAll(objects: NoncopyableObject[]): number;
    makeAll(count: number): NoncopyableObject[];
    makeMaybe(count: number): NoncopyableObject[] | null;
    raw(start: number): any;
    child: NoncopyableObject;
}
export type Exports = {
    useNoncopyableObject(object: NoncopyableObject): number;
    makeNoncopyableObjectInSwift(start: number): NoncopyableObject;
    findNoncopyableObjectInSwift(start: number): NoncopyableObject | null;
    countNoncopyableObjects(objects: NoncopyableObject[]): number;
    countNoncopyableObjectsWith(body: (arg0: NoncopyableObject[]) => number): number;
    loadNoncopyableObject(start: number): Promise<NoncopyableObject>;
    loadNoncopyableObjects(count: number): Promise<NoncopyableObject[]>;
    NoncopyableObjectBox: {
        new(start: number): NoncopyableObjectBox;
    },
}
export type Imports = {
    makeNoncopyableObject(start: number): NoncopyableObject;
    NoncopyableObject: {
        new(start: number): NoncopyableObject;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;