// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const PropertyEnumValues: {
    readonly Value1: 0;
    readonly Value2: 1;
};
export type PropertyEnumTag = typeof PropertyEnumValues[keyof typeof PropertyEnumValues];

export type PropertyEnumObject = typeof PropertyEnumValues & {
    enumProperty: string;
    readonly enumConstant: number;
    computedEnum: string;
};

export {};

declare global {
    namespace PropertyNamespace {
        var namespaceConstant: string;
        let namespaceProperty: string;
        namespace Nested {
            var nestedConstant: string;
            let nestedDouble: number;
            let nestedProperty: number;
        }
    }
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface PropertyClass extends SwiftHeapObject {
}
export type Exports = {
    PropertyClass: {
        new(): PropertyClass;
        readonly staticConstant: string;
        staticVariable: number;
        jsObjectProperty: any;
        classVariable: string;
        computedProperty: string;
        readonly readOnlyComputed: number;
        optionalProperty: string | null;
    }
    PropertyEnum: PropertyEnumObject
    PropertyNamespace: {
        readonly namespaceConstant: string;
        namespaceProperty: string;
        Nested: {
            readonly nestedConstant: string;
            nestedDouble: number;
            nestedProperty: number;
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
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;