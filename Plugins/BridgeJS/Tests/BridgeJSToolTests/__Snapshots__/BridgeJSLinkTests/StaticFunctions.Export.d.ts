// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const CalculatorValues: {
    readonly Scientific: 0;
    readonly Basic: 1;
};
export type CalculatorTag = typeof CalculatorValues[keyof typeof CalculatorValues];

export const APIResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
    };
};

export type APIResultTag =
  { tag: typeof APIResultValues.Tag.Success; param0: string } | { tag: typeof APIResultValues.Tag.Failure; param0: number }

export type CalculatorObject = typeof CalculatorValues & {
    square(value: number): number;
};

export type APIResultObject = typeof APIResultValues & {
    roundtrip(value: APIResultTag): APIResultTag;
};

export {};

declare global {
    namespace Utils {
        namespace String {
            uppercase(text: string): string;
        }
    }
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface MathUtils extends SwiftHeapObject {
    multiply(x: number, y: number): number;
}
export type Exports = {
    MathUtils: {
        new(): MathUtils;
        subtract(a: number, b: number): number;
        add(a: number, b: number): number;
    }
    Calculator: CalculatorObject
    APIResult: APIResultObject
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