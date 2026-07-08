// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const GenericColorValues: {
    readonly Red: 0;
    readonly Green: 1;
};
export type GenericColorTag = typeof GenericColorValues[keyof typeof GenericColorValues];

export const GenericModeValues: {
    readonly Light: "light";
    readonly Dark: "dark";
};
export type GenericModeTag = typeof GenericModeValues[keyof typeof GenericModeValues];

export const GenericTaggedValues: {
    readonly Tag: {
        readonly Number: 0;
        readonly Text: 1;
    };
};

export type GenericTaggedTag =
  { tag: typeof GenericTaggedValues.Tag.Number; value: number } | { tag: typeof GenericTaggedValues.Tag.Text; value: string }

export interface GenericPoint {
    x: number;
    y: number;
}
export type GenericColorObject = typeof GenericColorValues;

export type GenericModeObject = typeof GenericModeValues;

export type GenericTaggedObject = typeof GenericTaggedValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface GenericImportBox extends SwiftHeapObject {
    get(): number;
    value: number;
}
export interface GenericConsumer {
    accept<T>(value: T): void;
    identity<T>(value: T): T;
}
export type Exports = {
    GenericColor: GenericColorObject
    GenericMode: GenericModeObject
    GenericTagged: GenericTaggedObject
    GenericImportBox: {
        new(value: number): GenericImportBox;
    },
}
export type Imports = {
    genericRoundTrip<T>(value: T): T;
    genericParse<T>(json: string): T;
    importGenericCombine<T, U>(a: T, b: U): U;
    importGenericCaseDistinct<T, t>(a: T, b: t): T;
    importGenericArray<T>(values: T[]): T[];
    importGenericOptional<T>(value: T | null): T | null;
    importGenericDictionary<T>(values: Record<string, T>): Record<string, T>;
    GenericConsumer: {
        box<T>(value: T): T;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;