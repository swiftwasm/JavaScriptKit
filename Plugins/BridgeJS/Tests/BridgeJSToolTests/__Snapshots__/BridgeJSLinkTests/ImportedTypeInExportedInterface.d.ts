// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface FooContainer {
    foo: Foo;
    optionalFoo: Foo | null;
}
export interface Foo {
}
export type Exports = {
    makeFoo(): Foo;
    processFooArray(foos: Foo[]): Foo[];
    processOptionalFooArray(foos: (Foo | null)[]): (Foo | null)[];
    roundtripFooContainer(container: FooContainer): FooContainer;
}
export type Imports = {
    Foo: {
        new(): Foo;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;