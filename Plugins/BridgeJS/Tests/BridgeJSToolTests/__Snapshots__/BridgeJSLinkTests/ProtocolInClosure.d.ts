// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface Renderable {
    render(): string;
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Widget extends SwiftHeapObject {
    name: string;
}
export type Exports = {
    Widget: {
        new(name: string): Widget;
    }
    processRenderable(item: Renderable, transform: (arg0: Renderable) => string): string;
    makeRenderableFactory(defaultName: string): () => Renderable;
    roundtripRenderable(callback: (arg0: Renderable) => Renderable): (arg0: Renderable) => Renderable;
    processOptionalRenderable(callback: (arg0: Renderable | null) => string): string;
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