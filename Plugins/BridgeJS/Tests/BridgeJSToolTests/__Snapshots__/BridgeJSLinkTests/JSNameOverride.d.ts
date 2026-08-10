// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const RenamedEnumMembersValues: {
    readonly Active: 0;
    readonly Inactive: 1;
};
export type RenamedEnumMembersTag = typeof RenamedEnumMembersValues[keyof typeof RenamedEnumMembersValues];

export interface RenamedVector {
    dx: number;
    dy: number;
    magnitude(): number;
}
export type RenamedEnumMembersObject = typeof RenamedEnumMembersValues & {
    describeCase(): string;
    currentDefault: string;
};

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface RenamedMembers extends SwiftHeapObject {
    makeGreeting(): string;
    label: string;
    readonly total: number;
}
export type Exports = {
    makeGreeting(name: string): string;
    greetName(name: string): string;
    greetCount(count: number): string;
    RenamedEnumMembers: RenamedEnumMembersObject
    RenamedMembers: {
        new(title: string, count: number): RenamedMembers;
        makeDefault(): RenamedMembers;
        sharedTotal: number;
        readonly readOnlyLimit: number;
    },
    RenamedNamespaceMembers: {
        theAnswer: number;
        plus(a: number, b: number): number;
    },
    RenamedVector: {
        readonly originVector: RenamedVector;
        fromPolar(radius: number, angle: number): RenamedVector;
    },
    Utils: {
        Text: {
            namespacedRenamed(): number;
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
    afterInitialize?: () => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;