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
export interface JSValueHolder extends SwiftHeapObject {
    update(value: any, optionalValue: any | null): void;
    echo(value: any): any;
    echoOptional(value: any | null): any | null;
    value: any;
    optionalValue: any | null;
}
export type Exports = {
    JSValueHolder: {
        new(value: any, optionalValue: any | null): JSValueHolder;
    }
    roundTripJSValue(value: any): any;
    roundTripOptionalJSValue(value: any | null): any | null;
}
export type Imports = {
    jsEchoJSValue(value: any): any;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;