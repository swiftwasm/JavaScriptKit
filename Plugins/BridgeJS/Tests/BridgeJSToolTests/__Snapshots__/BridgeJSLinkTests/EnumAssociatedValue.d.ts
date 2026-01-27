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

export const AllTypesResultValues: {
    readonly Tag: {
        readonly StructPayload: 0;
        readonly ClassPayload: 1;
        readonly JsObjectPayload: 2;
        readonly NestedEnum: 3;
        readonly ArrayPayload: 4;
        readonly Empty: 5;
    };
};

export type AllTypesResultTag =
  { tag: typeof AllTypesResultValues.Tag.StructPayload; param0: PointTag } | { tag: typeof AllTypesResultValues.Tag.ClassPayload; param0: User } | { tag: typeof AllTypesResultValues.Tag.JsObjectPayload; param0: any } | { tag: typeof AllTypesResultValues.Tag.NestedEnum; param0: APIResultTag } | { tag: typeof AllTypesResultValues.Tag.ArrayPayload; param0: number[] } | { tag: typeof AllTypesResultValues.Tag.Empty }

export const OptionalAllTypesResultValues: {
    readonly Tag: {
        readonly OptStruct: 0;
        readonly OptClass: 1;
        readonly OptJSObject: 2;
        readonly OptNestedEnum: 3;
        readonly OptArray: 4;
        readonly Empty: 5;
    };
};

export type OptionalAllTypesResultTag =
  { tag: typeof OptionalAllTypesResultValues.Tag.OptStruct; param0: PointTag | null } | { tag: typeof OptionalAllTypesResultValues.Tag.OptClass; param0: User | null } | { tag: typeof OptionalAllTypesResultValues.Tag.OptJSObject; param0: any | null } | { tag: typeof OptionalAllTypesResultValues.Tag.OptNestedEnum; param0: APIResultTag | null } | { tag: typeof OptionalAllTypesResultValues.Tag.OptArray; param0: number[] | null } | { tag: typeof OptionalAllTypesResultValues.Tag.Empty }

export interface Point {
    x: number;
    y: number;
}
export type APIResultObject = typeof APIResultValues;

export type ComplexResultObject = typeof ComplexResultValues;

export type ResultObject = typeof Utilities.ResultValues;

export type NetworkingResultObject = typeof API.NetworkingResultValues;

export type APIOptionalResultObject = typeof APIOptionalResultValues;

export type PrecisionObject = typeof PrecisionValues;

export type CardinalDirectionObject = typeof CardinalDirectionValues;

export type TypedPayloadResultObject = typeof TypedPayloadResultValues;

export type AllTypesResultObject = typeof AllTypesResultValues;

export type OptionalAllTypesResultObject = typeof OptionalAllTypesResultValues;

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
/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface User extends SwiftHeapObject {
}
export type Exports = {
    User: {
    }
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
    roundTripAllTypesResult(result: AllTypesResultTag): AllTypesResultTag;
    roundTripOptionalAllTypesResult(result: AllTypesResultTag | null): AllTypesResultTag | null;
    roundTripOptionalPayloadResult(result: OptionalAllTypesResultTag): OptionalAllTypesResultTag;
    roundTripOptionalPayloadResultOpt(result: OptionalAllTypesResultTag | null): OptionalAllTypesResultTag | null;
    APIResult: APIResultObject
    ComplexResult: ComplexResultObject
    APIOptionalResult: APIOptionalResultObject
    Precision: PrecisionObject
    CardinalDirection: CardinalDirectionObject
    TypedPayloadResult: TypedPayloadResultObject
    AllTypesResult: AllTypesResultObject
    OptionalAllTypesResult: OptionalAllTypesResultObject
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