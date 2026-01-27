// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

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

export const ComplexResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Error: 1;
        readonly Status: 2;
        readonly Coordinates: 3;
        readonly Comprehensive: 4;
        readonly Info: 5;
    };
};

export type ComplexResultTag =
  { tag: typeof ComplexResultValues.Tag.Success; param0: string } | { tag: typeof ComplexResultValues.Tag.Error; param0: string; param1: number } | { tag: typeof ComplexResultValues.Tag.Status; param0: boolean; param1: number; param2: string } | { tag: typeof ComplexResultValues.Tag.Coordinates; param0: number; param1: number; param2: number } | { tag: typeof ComplexResultValues.Tag.Comprehensive; param0: boolean; param1: boolean; param2: number; param3: number; param4: number; param5: number; param6: string; param7: string; param8: string } | { tag: typeof ComplexResultValues.Tag.Info }

export const APIOptionalResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
        readonly Status: 2;
    };
};

export type APIOptionalResultTag =
  { tag: typeof APIOptionalResultValues.Tag.Success; param0: string | null } | { tag: typeof APIOptionalResultValues.Tag.Failure; param0: number | null; param1: boolean | null } | { tag: typeof APIOptionalResultValues.Tag.Status; param0: boolean | null; param1: number | null; param2: string | null }

export const PrecisionValues: {
    readonly Rough: 0.1;
    readonly Fine: 0.001;
};
export type PrecisionTag = typeof PrecisionValues[keyof typeof PrecisionValues];

export const CardinalDirectionValues: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
export type CardinalDirectionTag = typeof CardinalDirectionValues[keyof typeof CardinalDirectionValues];

export const TypedPayloadResultValues: {
    readonly Tag: {
        readonly Precision: 0;
        readonly Direction: 1;
        readonly OptPrecision: 2;
        readonly OptDirection: 3;
        readonly Empty: 4;
    };
};

export type TypedPayloadResultTag =
  { tag: typeof TypedPayloadResultValues.Tag.Precision; param0: PrecisionTag } | { tag: typeof TypedPayloadResultValues.Tag.Direction; param0: CardinalDirectionTag } | { tag: typeof TypedPayloadResultValues.Tag.OptPrecision; param0: PrecisionTag | null } | { tag: typeof TypedPayloadResultValues.Tag.OptDirection; param0: CardinalDirectionTag | null } | { tag: typeof TypedPayloadResultValues.Tag.Empty }

export type APIResultObject = typeof APIResultValues;

export type ComplexResultObject = typeof ComplexResultValues;

export type ResultObject = typeof Utilities.ResultValues;

export type NetworkingResultObject = typeof API.NetworkingResultValues;

export type APIOptionalResultObject = typeof APIOptionalResultValues;

export type PrecisionObject = typeof PrecisionValues;

export type CardinalDirectionObject = typeof CardinalDirectionValues;

export type TypedPayloadResultObject = typeof TypedPayloadResultValues;

export namespace API {
    const NetworkingResultValues: {
        readonly Tag: {
            readonly Success: 0;
            readonly Failure: 1;
        };
    };
    type NetworkingResultTag =
      { tag: typeof NetworkingResultValues.Tag.Success; param0: string } | { tag: typeof NetworkingResultValues.Tag.Failure; param0: string; param1: number }
}
export namespace Utilities {
    const ResultValues: {
        readonly Tag: {
            readonly Success: 0;
            readonly Failure: 1;
            readonly Status: 2;
        };
    };
    type ResultTag =
      { tag: typeof ResultValues.Tag.Success; param0: string } | { tag: typeof ResultValues.Tag.Failure; param0: string; param1: number } | { tag: typeof ResultValues.Tag.Status; param0: boolean; param1: number; param2: string }
}
export type Exports = {
    handle(result: APIResultTag): void;
    getResult(): APIResultTag;
    roundtripAPIResult(result: APIResultTag): APIResultTag;
    roundTripOptionalAPIResult(result: APIResultTag | null): APIResultTag | null;
    handleComplex(result: ComplexResultTag): void;
    getComplexResult(): ComplexResultTag;
    roundtripComplexResult(result: ComplexResultTag): ComplexResultTag;
    roundTripOptionalComplexResult(result: ComplexResultTag | null): ComplexResultTag | null;
    roundTripOptionalUtilitiesResult(result: Utilities.ResultTag | null): Utilities.ResultTag | null;
    roundTripOptionalNetworkingResult(result: API.NetworkingResultTag | null): API.NetworkingResultTag | null;
    roundTripOptionalAPIOptionalResult(result: APIOptionalResultTag | null): APIOptionalResultTag | null;
    compareAPIResults(result1: APIOptionalResultTag | null, result2: APIOptionalResultTag | null): APIOptionalResultTag | null;
    roundTripTypedPayloadResult(result: TypedPayloadResultTag): TypedPayloadResultTag;
    roundTripOptionalTypedPayloadResult(result: TypedPayloadResultTag | null): TypedPayloadResultTag | null;
    APIResult: APIResultObject
    ComplexResult: ComplexResultObject
    APIOptionalResult: APIOptionalResultObject
    Precision: PrecisionObject
    CardinalDirection: CardinalDirectionObject
    TypedPayloadResult: TypedPayloadResultObject
    API: {
        NetworkingResult: NetworkingResultObject
    },
    Utilities: {
        Result: ResultObject
    },
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