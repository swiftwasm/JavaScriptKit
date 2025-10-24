// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const DirectionValues: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
export type DirectionTag = typeof DirectionValues[keyof typeof DirectionValues];

export const ThemeValues: {
    readonly Light: "light";
    readonly Dark: "dark";
    readonly Auto: "auto";
};
export type ThemeTag = typeof ThemeValues[keyof typeof ThemeValues];

export const HttpStatusValues: {
    readonly Ok: 200;
    readonly NotFound: 404;
    readonly ServerError: 500;
    readonly Unknown: -1;
};
export type HttpStatusTag = typeof HttpStatusValues[keyof typeof HttpStatusValues];

export const APIResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
        readonly Flag: 2;
        readonly Rate: 3;
        readonly Precise: 4;
        readonly Info: 5;
    };
};

export type APIResultTag =
  { tag: typeof APIResultValues.Tag.Success; param0: string } | { tag: typeof APIResultValues.Tag.Failure; param0: number } | { tag: typeof APIResultValues.Tag.Flag; param0: boolean } | { tag: typeof APIResultValues.Tag.Rate; param0: number } | { tag: typeof APIResultValues.Tag.Precise; param0: number } | { tag: typeof APIResultValues.Tag.Info }

export type DirectionObject = typeof DirectionValues;

export type ThemeObject = typeof ThemeValues;

export type HttpStatusObject = typeof HttpStatusValues;

export type APIResultObject = typeof APIResultValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Person extends SwiftHeapObject {
}
export interface TestProcessor extends SwiftHeapObject {
    getTransform(): (arg0: string) => string;
    processWithCustom(text: string, customTransform: (arg0: string) => string): string;
    printTogether(person: Person, name: string, ratio: number, customTransform: (arg0: Person | null, arg1: string | null, arg2: number | null) => string): string;
    roundtrip(personClosure: (arg0: Person) => string): (arg0: Person) => string;
    roundtripOptional(personClosure: (arg0: Person | null) => string): (arg0: Person | null) => string;
    processDirection(callback: (arg0: DirectionTag) => string): string;
    processTheme(callback: (arg0: ThemeTag) => string): string;
    processHttpStatus(callback: (arg0: HttpStatusTag) => number): number;
    processAPIResult(callback: (arg0: APIResultTag) => string): string;
    makeDirectionChecker(): (arg0: DirectionTag) => boolean;
    makeThemeValidator(): (arg0: ThemeTag) => boolean;
    makeStatusCodeExtractor(): (arg0: HttpStatusTag) => number;
    makeAPIResultHandler(): (arg0: APIResultTag) => string;
    processOptionalDirection(callback: (arg0: DirectionTag | null) => string): string;
    processOptionalTheme(callback: (arg0: ThemeTag | null) => string): string;
    processOptionalAPIResult(callback: (arg0: APIResultTag | null) => string): string;
    makeOptionalDirectionFormatter(): (arg0: DirectionTag | null) => string;
}
export type Exports = {
    Person: {
        new(name: string): Person;
    }
    TestProcessor: {
        new(transform: (arg0: string) => string): TestProcessor;
    }
    Direction: DirectionObject
    Theme: ThemeObject
    HttpStatus: HttpStatusObject
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