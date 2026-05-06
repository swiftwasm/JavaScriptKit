// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface ValueWithBoxedField {
    payload: Hi;
    label: string;
}
/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface LargePayload extends SwiftHeapObject {
    copy(): this;
    readonly largeContents: number[];
}
export interface Hi extends SwiftHeapObject {
    copy(): this;
    summarize(): string;
    appendingZero(): Hi;
    readonly largeContents: number[];
}
export interface Container extends SwiftHeapObject {
    copy(): this;
    readonly payload: LargePayload;
}
export interface MutableBox extends SwiftHeapObject {
    copy(): this;
    counter: number;
    readonly label: string;
}
export type Exports = {
    LargePayload: {
    }
    Hi: {
        new(largeContents: number[]): Hi;
    }
    Container: {
    }
    MutableBox: {
    }
    roundtripBoxed(p: LargePayload): LargePayload;
    mayMakeHi(flag: boolean): Hi | null;
    consumeBoxedArray(items: Hi[]): Hi[];
    consumeBoxedDictionary(items: Record<string, Hi>): Record<string, Hi>;
    optionalBoxedArray(flag: boolean): Hi[] | null;
    arrayOfOptionalBoxed(flag: boolean): (Hi | null)[];
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