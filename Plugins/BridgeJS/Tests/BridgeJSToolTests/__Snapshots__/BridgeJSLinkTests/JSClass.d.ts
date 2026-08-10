// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface Greeter {
    greet(): string;
    changeName(name: string): void;
    name: string;
    readonly age: number;
}
export interface Animatable {
    animate(keyframes: any, options: any): any;
    getAnimations(options: any): any;
}
export type Exports = {
}
export type Imports = {
    returnAnimatable(): Animatable;
    Greeter: {
        new(name: string): Greeter;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;