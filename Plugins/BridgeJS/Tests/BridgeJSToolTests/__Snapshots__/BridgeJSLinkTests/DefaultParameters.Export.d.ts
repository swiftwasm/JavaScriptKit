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

export interface Config {
    name: string;
    value: number;
    enabled: boolean;
}
export interface MathOperations {
    baseValue: number;
    /**
     * @param b - Optional parameter (default: 10.0)
     */
    add(a: number, b?: number): number;
    multiply(a: number, b: number): number;
}
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
export interface ConstructorDefaults extends SwiftHeapObject {
    name: string;
    count: number;
    enabled: boolean;
    status: StatusTag;
    tag: string | null;
}
export type Exports = {
    DefaultGreeter: {
        new(name: string): DefaultGreeter;
    }
    EmptyGreeter: {
        new(): EmptyGreeter;
    }
    ConstructorDefaults: {
        /**
         * @param name - Optional parameter (default: "Default")
         * @param count - Optional parameter (default: 42)
         * @param enabled - Optional parameter (default: true)
         * @param status - Optional parameter (default: Status.Active)
         * @param tag - Optional parameter (default: null)
         */
        new(name?: string, count?: number, enabled?: boolean, status?: StatusTag, tag?: string | null): ConstructorDefaults;
    }
    /**
     * @param message - Optional parameter (default: "Hello World")
     */
    testStringDefault(message?: string): string;
    /**
     * @param value - Optional parameter (default: -42)
     */
    testNegativeIntDefault(value?: number): number;
    /**
     * @param flag - Optional parameter (default: true)
     */
    testBoolDefault(flag?: boolean): boolean;
    /**
     * @param temp - Optional parameter (default: -273.15)
     */
    testNegativeFloatDefault(temp?: number): number;
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
    /**
     * @param point - Optional parameter (default: null)
     */
    testOptionalStructDefault(point?: Config | null): Config | null;
    /**
     * @param point - Optional parameter (default: { name: "default", value: 42, enabled: true })
     */
    testOptionalStructWithValueDefault(point?: Config | null): Config | null;
    Status: StatusObject
    MathOperations: {
        /**
         * @param baseValue - Optional parameter (default: 0.0)
         */
        init(baseValue?: number): MathOperations;
        /**
         * @param b - Optional parameter (default: 5.0)
         */
        subtract(a: number, b?: number): number;
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