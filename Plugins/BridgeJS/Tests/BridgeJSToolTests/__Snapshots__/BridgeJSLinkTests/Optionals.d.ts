// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Greeter extends SwiftHeapObject {
    greet(): string;
    changeName(name: string | null): void;
    name: string | null;
}
export interface OptionalPropertyHolder extends SwiftHeapObject {
    optionalName: string | null;
    optionalAge: number | null;
    optionalGreeter: Greeter | null;
}
export interface WithOptionalJSClass {
    roundTripStringOrNull(value: string | null): string | null;
    roundTripStringOrUndefined(value: string | undefined): string | undefined;
    roundTripDoubleOrNull(value: number | null): number | null;
    roundTripDoubleOrUndefined(value: number | undefined): number | undefined;
    roundTripBoolOrNull(value: boolean | null): boolean | null;
    roundTripBoolOrUndefined(value: boolean | undefined): boolean | undefined;
    roundTripIntOrNull(value: number | null): number | null;
    roundTripIntOrUndefined(value: number | undefined): number | undefined;
    stringOrNull: string | null;
    stringOrUndefined: string | undefined;
    doubleOrNull: number | null;
    doubleOrUndefined: number | undefined;
    boolOrNull: boolean | null;
    boolOrUndefined: boolean | undefined;
    intOrNull: number | null;
    intOrUndefined: number | undefined;
}
export type Exports = {
    Greeter: {
        new(name: string | null): Greeter;
    }
    OptionalPropertyHolder: {
        new(): OptionalPropertyHolder;
    }
    roundTripOptionalClass(value: Greeter | null): Greeter | null;
    testOptionalPropertyRoundtrip(holder: OptionalPropertyHolder | null): OptionalPropertyHolder | null;
    roundTripString(name: string | null): string | null;
    roundTripInt(value: number | null): number | null;
    roundTripBool(flag: boolean | null): boolean | null;
    roundTripFloat(number: number | null): number | null;
    roundTripDouble(precision: number | null): number | null;
    roundTripSyntax(name: string | null): string | null;
    roundTripMixSyntax(name: string | null): string | null;
    roundTripSwiftSyntax(name: string | null): string | null;
    roundTripMixedSwiftSyntax(name: string | null): string | null;
    roundTripWithSpaces(value: number | null): number | null;
    roundTripAlias(age: number | null): number | null;
    roundTripOptionalAlias(name: string | null): string | null;
    testMixedOptionals(firstName: string | null, lastName: string | null, age: number | null, active: boolean): string | null;
}
export type Imports = {
    WithOptionalJSClass: {
        new(valueOrNull: string | null, valueOrUndefined: string | undefined): WithOptionalJSClass;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;