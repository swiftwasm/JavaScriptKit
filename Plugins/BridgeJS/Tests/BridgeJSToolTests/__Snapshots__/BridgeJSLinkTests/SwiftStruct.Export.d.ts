// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface DataPoint {
    x: number;
    y: number;
    label: string;
    optCount: number | null;
    optFlag: boolean | null;
}
export interface Address {
    street: string;
    city: string;
    zipCode: number | null;
}
export interface Person {
    name: string;
    age: number;
    address: Address;
    email: string | null;
}
export interface Session {
    id: number;
    owner: Greeter;
}
export interface ConfigStruct {
}
/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Greeter extends SwiftHeapObject {
    greet(): string;
    name: string;
}
export type Exports = {
    Greeter: {
        new(name: string): Greeter;
    }
    roundtrip(session: Person): Person;
    DataPoint: {
        init(x: number, y: number, label: string, optCount: number | null, optFlag: boolean | null): DataPoint;
    }
    ConfigStruct: {
        readonly maxRetries: number;
        defaultConfig: string;
        timeout: number;
        readonly computedSetting: string;
        update(timeout: number): number;
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