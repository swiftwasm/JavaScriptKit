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
export interface Greeter extends SwiftHeapObject {
    greet(): string;
    changeName(name: string): void;
    greetEnthusiastically(): string;
    name: string;
    readonly nameCount: number;
}
export interface PublicGreeter extends SwiftHeapObject {
}
export interface PackageGreeter extends SwiftHeapObject {
}
export type Exports = {
    Greeter: {
        new(name: string): Greeter;
        greetAnonymously(): string;
        readonly defaultGreeting: string;
    }
    PublicGreeter: {
    }
    PackageGreeter: {
    }
    takeGreeter(greeter: Greeter): void;
}
export type Imports = {
    jsRoundTripGreeter(greeter: Greeter): Greeter;
    jsRoundTripOptionalGreeter(greeter: Greeter | null): Greeter | null;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;