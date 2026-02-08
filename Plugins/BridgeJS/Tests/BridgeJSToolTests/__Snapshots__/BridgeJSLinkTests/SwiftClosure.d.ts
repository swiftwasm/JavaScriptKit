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
}
export type Exports = {
    Person: {
        new(name: string): Person;
    }
    TestProcessor: {
        new(transform: (arg0: string) => string): TestProcessor;
    }
    roundtripString(stringClosure: (arg0: string) => string): (arg0: string) => string;
    roundtripInt(intClosure: (arg0: number) => number): (arg0: number) => number;
    roundtripBool(boolClosure: (arg0: boolean) => boolean): (arg0: boolean) => boolean;
    roundtripFloat(floatClosure: (arg0: number) => number): (arg0: number) => number;
    roundtripDouble(doubleClosure: (arg0: number) => number): (arg0: number) => number;
    roundtripOptionalString(stringClosure: (arg0: string | null) => string | null): (arg0: string | null) => string | null;
    roundtripOptionalInt(intClosure: (arg0: number | null) => number | null): (arg0: number | null) => number | null;
    roundtripOptionalBool(boolClosure: (arg0: boolean | null) => boolean | null): (arg0: boolean | null) => boolean | null;
    roundtripOptionalFloat(floatClosure: (arg0: number | null) => number | null): (arg0: number | null) => number | null;
    roundtripOptionalDouble(doubleClosure: (arg0: number | null) => number | null): (arg0: number | null) => number | null;
    roundtripPerson(personClosure: (arg0: Person) => Person): (arg0: Person) => Person;
    roundtripOptionalPerson(personClosure: (arg0: Person | null) => Person | null): (arg0: Person | null) => Person | null;
    roundtripDirection(callback: (arg0: DirectionTag) => DirectionTag): (arg0: DirectionTag) => DirectionTag;
    roundtripTheme(callback: (arg0: ThemeTag) => ThemeTag): (arg0: ThemeTag) => ThemeTag;
    roundtripHttpStatus(callback: (arg0: HttpStatusTag) => HttpStatusTag): (arg0: HttpStatusTag) => HttpStatusTag;
    roundtripAPIResult(callback: (arg0: APIResultTag) => APIResultTag): (arg0: APIResultTag) => APIResultTag;
    roundtripOptionalDirection(callback: (arg0: DirectionTag | null) => DirectionTag | null): (arg0: DirectionTag | null) => DirectionTag | null;
    roundtripOptionalTheme(callback: (arg0: ThemeTag | null) => ThemeTag | null): (arg0: ThemeTag | null) => ThemeTag | null;
    roundtripOptionalHttpStatus(callback: (arg0: HttpStatusTag | null) => HttpStatusTag | null): (arg0: HttpStatusTag | null) => HttpStatusTag | null;
    roundtripOptionalAPIResult(callback: (arg0: APIResultTag | null) => APIResultTag | null): (arg0: APIResultTag | null) => APIResultTag | null;
    roundtripOptionalDirection(callback: (arg0: DirectionTag | null) => DirectionTag | null): (arg0: DirectionTag | null) => DirectionTag | null;
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