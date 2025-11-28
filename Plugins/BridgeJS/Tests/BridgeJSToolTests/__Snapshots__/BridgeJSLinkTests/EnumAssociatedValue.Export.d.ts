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

export type APIResultObject = typeof APIResultValues;

export type ComplexResultObject = typeof ComplexResultValues;

export type ResultObject = typeof Utilities.ResultValues;

export type NetworkingResultObject = typeof API.NetworkingResultValues;

export type APIOptionalResultObject = typeof APIOptionalResultValues;

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
    APIResult: APIResultObject
    ComplexResult: ComplexResultObject
    APIOptionalResult: APIOptionalResultObject
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