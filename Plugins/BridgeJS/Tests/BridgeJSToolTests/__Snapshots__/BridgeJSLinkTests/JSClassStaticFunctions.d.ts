// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface StaticBox {
}
export interface StaticBox {
    value(): number;
}
export interface WithCtor {
}
export type Exports = {
}
export type Imports = {
    StaticBox: {
        makeDefault(): StaticBox;
        "with-dashes"(): StaticBox;
    }
    StaticBox: {
        create(value: number): StaticBox;
        value(): number;
    }
    WithCtor: {
        new(value: number): WithCtor;
        create(value: number): WithCtor;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;