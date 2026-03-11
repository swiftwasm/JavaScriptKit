// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type Exports = {
    checkJSString(a: string): void;
    getJSString(): string;
    roundTripJSString(value: string): string;
    checkOptionalJSString(a: string | null): void;
    getOptionalJSString(): string | null;
    roundTripOptionalJSString(value: string | null): string | null;
    checkUndefinedOrJSString(a: string | undefined): void;
    getUndefinedOrJSString(): string | undefined;
    roundTripUndefinedOrJSString(value: string | undefined): string | undefined;
}
export type Imports = {
    jsCheckJSString(a: string): void;
    jsGetJSString(): string;
    jsCheckOptionalJSString(a: string | null): void;
    jsGetOptionalJSString(): string | null;
    jsCheckUndefinedOrJSString(a: string | undefined): void;
    jsGetUndefinedOrJSString(): string | undefined;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;