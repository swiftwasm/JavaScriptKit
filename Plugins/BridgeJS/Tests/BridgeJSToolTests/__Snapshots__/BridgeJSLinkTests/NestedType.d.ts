// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export namespace Player {
    export interface Stats {
        level: number;
        rating: string;
    }
}
export namespace User {
    export interface Stats {
        health: number;
        score: number;
    }
}
/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface User extends SwiftHeapObject {
    getName(): string;
}
export interface Player extends SwiftHeapObject {
    getTag(): string;
}
export type Exports = {
    User: {
    }
    Player: {
    }
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