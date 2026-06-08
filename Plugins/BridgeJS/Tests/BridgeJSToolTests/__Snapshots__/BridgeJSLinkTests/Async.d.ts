// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const AsyncDirectionValues: {
    readonly North: 0;
    readonly South: 1;
};
export type AsyncDirectionTag = typeof AsyncDirectionValues[keyof typeof AsyncDirectionValues];

export const AsyncThemeValues: {
    readonly Light: "light";
    readonly Dark: "dark";
};
export type AsyncThemeTag = typeof AsyncThemeValues[keyof typeof AsyncThemeValues];

export interface AsyncPoint {
    x: number;
    y: number;
}
export type AsyncDirectionObject = typeof AsyncDirectionValues;

export type AsyncThemeObject = typeof AsyncThemeValues;

export type Exports = {
    asyncReturnVoid(): Promise<void>;
    asyncRoundTripInt(v: number): Promise<number>;
    asyncRoundTripString(v: string): Promise<string>;
    asyncRoundTripBool(v: boolean): Promise<boolean>;
    asyncRoundTripFloat(v: number): Promise<number>;
    asyncRoundTripDouble(v: number): Promise<number>;
    asyncRoundTripJSObject(v: any): Promise<any>;
    asyncRoundTripStruct(v: AsyncPoint): Promise<AsyncPoint>;
    asyncRoundTripStructThrows(v: AsyncPoint): Promise<AsyncPoint>;
    asyncCombineStructs(a: AsyncPoint, b: AsyncPoint): Promise<AsyncPoint>;
    asyncRoundTripEnum(v: AsyncDirectionTag): Promise<AsyncDirectionTag>;
    asyncRoundTripRawEnum(v: AsyncThemeTag): Promise<AsyncThemeTag>;
    asyncRoundTripOptionalEnum(v: AsyncDirectionTag | null): Promise<AsyncDirectionTag | null>;
    asyncRoundTripOptionalRawEnum(v: AsyncThemeTag | null): Promise<AsyncThemeTag | null>;
    asyncRoundTripOptionalStruct(v: AsyncPoint | null): Promise<AsyncPoint | null>;
    asyncRoundTripStructArray(v: AsyncPoint[]): Promise<AsyncPoint[]>;
    asyncRoundTripEnumArray(v: AsyncDirectionTag[]): Promise<AsyncDirectionTag[]>;
    asyncRoundTripStructDictionary(v: Record<string, AsyncPoint>): Promise<Record<string, AsyncPoint>>;
    asyncRoundTripEnumDictionary(v: Record<string, AsyncDirectionTag>): Promise<Record<string, AsyncDirectionTag>>;
    AsyncDirection: AsyncDirectionObject
    AsyncTheme: AsyncThemeObject
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