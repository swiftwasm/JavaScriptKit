// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface PropertyHolder extends SwiftHeapObject {
    getAllValues(): string;
    intValue: number;
    floatValue: number;
    doubleValue: number;
    boolValue: boolean;
    stringValue: string;
    readonly readonlyInt: number;
    readonly readonlyFloat: number;
    readonly readonlyDouble: number;
    readonly readonlyBool: boolean;
    readonly readonlyString: string;
    jsObject: any;
    sibling: PropertyHolder;
    lazyValue: string;
    readonly computedReadonly: number;
    computedReadWrite: string;
    observedProperty: number;
}
export type Exports = {
    PropertyHolder: {
        new(intValue: number, floatValue: number, doubleValue: number, boolValue: boolean, stringValue: string, jsObject: any): PropertyHolder;
    }
    createPropertyHolder(intValue: number, floatValue: number, doubleValue: number, boolValue: boolean, stringValue: string, jsObject: any): PropertyHolder;
    testPropertyHolder(holder: PropertyHolder): string;
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