// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface ReservedWordDelegate {
    handle(_in: number, _for: string, _default: boolean): void;
}

export interface BacktickedLabelDelegate {
    handle(_in: number): void;
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface ReservedWordBox extends SwiftHeapObject {
    run(_for: number): void;
}
export type Exports = {
    check(extension: number, _break: number, _function: boolean, _in: string): void;
    checkEscaped(_in: string): void;
    checkEscapedCollision(_in: number, _in1: number): void;
    checkGlueNameCollision(instance: number, swift: string): void;
    ReservedWordBox: {
        new(_in: number): ReservedWordBox;
        make(_default: number): number;
    },
}
export type Imports = {
    importedCheck(_in: number, _for: string, _default: boolean): void;
    importedSelfClosure(self: () => void): void;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;