// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface TestClass {
    methodWithOptional(value: any): void;
    methodReturningOptional(): any;
    optionalProperty: any;
}
export type Exports = {
}
export type Imports = {
    testOptionalNumber(value: any): void;
    testOptionalString(value: any): void;
    testOptionalBool(value: any): void;
    testOptionalReturn(): any;
    testOptionalNumberReturn(): any;
    testMixedOptionals(required: string, optional: any): any;
    TestClass: {
        new(param: any): TestClass;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;