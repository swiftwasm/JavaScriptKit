// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const StatusValues: {
    readonly Active: 0;
    readonly Inactive: 1;
    readonly Pending: 2;
};
export type StatusTag = typeof StatusValues[keyof typeof StatusValues];

export type StatusObject = typeof StatusValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface DefaultGreeter extends SwiftHeapObject {
    name: string;
}
export interface EmptyGreeter extends SwiftHeapObject {
}
export type Exports = {
    DefaultGreeter: {
        new(name: string): DefaultGreeter;
    }
    EmptyGreeter: {
        new(): EmptyGreeter;
    }
    /**
     * @param message - Optional parameter (default: "Hello World")
     */
    testStringDefault(message?: string): string;
    /**
     * @param count - Optional parameter (default: 42)
     */
    testIntDefault(count?: number): number;
    /**
     * @param flag - Optional parameter (default: true)
     */
    testBoolDefault(flag?: boolean): boolean;
    /**
     * @param value - Optional parameter (default: 3.14)
     */
    testFloatDefault(value?: number): number;
    /**
     * @param precision - Optional parameter (default: 2.718)
     */
    testDoubleDefault(precision?: number): number;
    /**
     * @param name - Optional parameter (default: null)
     */
    testOptionalDefault(name?: string | null): string | null;
    /**
     * @param greeting - Optional parameter (default: "Hi")
     */
    testOptionalStringDefault(greeting?: string | null): string | null;
    /**
     * @param title - Optional parameter (default: "Default Title")
     * @param count - Optional parameter (default: 10)
     * @param enabled - Optional parameter (default: false)
     */
    testMultipleDefaults(title?: string, count?: number, enabled?: boolean): string;
    /**
     * @param status - Optional parameter (default: Status.Active)
     */
    testEnumDefault(status?: StatusTag): StatusTag;
    /**
     * @param greeter - Optional parameter (default: new DefaultGreeter("DefaultUser"))
     */
    testComplexInit(greeter?: DefaultGreeter): DefaultGreeter;
    /**
     * @param greeter - Optional parameter (default: new EmptyGreeter())
     */
    testEmptyInit(greeter?: EmptyGreeter): EmptyGreeter;
    Status: StatusObject
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