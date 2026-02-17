// @ts-check

import assert from "node:assert";
import {
    StatusValues,
    ThemeValues,
    HttpStatusValues,
    TSDirection,
    TSTheme,
    APIResultValues,
    APIOptionalResultValues,
    AllTypesResultValues,
    OptionalAllTypesResultValues,
} from "../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.js";

import { ImportedFoo } from "./Types.mjs";

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["OptionalSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsRoundTripOptionalNumberNull: (v) => {
            return v ?? null;
        },
        jsRoundTripOptionalNumberUndefined: (v) => {
            return v === undefined ? undefined : v;
        },
        jsRoundTripOptionalStringNull: (v) => {
            return v ?? null;
        },
        jsRoundTripOptionalStringUndefined: (v) => {
            return v === undefined ? undefined : v;
        },
        runJsOptionalSupportTests: () => {
            const exports = importsContext.getExports();
            if (!exports) {
                throw new Error("No exports!?");
            }
            runJsOptionalSupportTests(exports);
        },
    };
}

/**
 * Optional value bridging coverage for BridgeJS runtime tests.
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
export function runJsOptionalSupportTests(exports) {
    assert.equal(exports.roundTripOptionalString(null), null);
    assert.equal(exports.roundTripOptionalInt(null), null);
    assert.equal(exports.roundTripOptionalBool(null), null);
    assert.equal(exports.roundTripOptionalFloat(null), null);
    assert.equal(exports.roundTripOptionalDouble(null), null);

    assert.equal(exports.roundTripOptionalString("Hello"), "Hello");
    assert.equal(exports.roundTripOptionalInt(42), 42);
    assert.equal(exports.roundTripOptionalBool(true), true);
    assert.equal(
        exports.roundTripOptionalFloat(3.141592502593994),
        3.141592502593994,
    ); // Float32 precision
    assert.equal(exports.roundTripOptionalDouble(2.718), 2.718);

    assert.equal(exports.roundTripOptionalSyntax(null), null);
    assert.equal(exports.roundTripOptionalSyntax("Test"), "Test");
    assert.equal(exports.roundTripOptionalMixSyntax(null), null);
    assert.equal(exports.roundTripOptionalMixSyntax("Mix"), "Mix");
    assert.equal(exports.roundTripOptionalSwiftSyntax(null), null);
    assert.equal(exports.roundTripOptionalSwiftSyntax("Swift"), "Swift");
    assert.equal(exports.roundTripOptionalWithSpaces(null), null);
    assert.equal(exports.roundTripOptionalWithSpaces(1.618), 1.618);
    assert.equal(exports.roundTripOptionalTypeAlias(null), null);
    assert.equal(exports.roundTripOptionalTypeAlias(25), 25);
    assert.equal(
        exports.roundTripOptionalStatus(exports.Status.Success),
        StatusValues.Success,
    );
    assert.equal(
        exports.roundTripOptionalTheme(exports.Theme.Light),
        ThemeValues.Light,
    );
    assert.equal(
        exports.roundTripOptionalHttpStatus(exports.HttpStatus.Ok),
        HttpStatusValues.Ok,
    );
    assert.equal(
        exports.roundTripOptionalTSDirection(TSDirection.North),
        TSDirection.North,
    );
    assert.equal(
        exports.roundTripOptionalTSTheme(TSTheme.Light),
        TSTheme.Light,
    );
    assert.equal(
        exports.roundTripOptionalNetworkingAPIMethod(
            exports.Networking.API.Method.Get,
        ),
        exports.Networking.API.Method.Get,
    );

    const pVal = 3.141592653589793;
    const p1 = { tag: APIResultValues.Tag.Precise, param0: pVal };
    const cl1 = {
        tag: exports.ComplexResult.Tag.Location,
        param0: 37.7749,
        param1: -122.4194,
        param2: "San Francisco",
    };

    assert.deepEqual(exports.roundTripOptionalAPIResult(p1), p1);
    assert.deepEqual(exports.roundTripOptionalComplexResult(cl1), cl1);

    const apiSuccess = {
        tag: exports.APIResult.Tag.Success,
        param0: "test success",
    };
    const apiFailure = { tag: exports.APIResult.Tag.Failure, param0: 404 };
    const apiInfo = { tag: exports.APIResult.Tag.Info };

    assert.equal(
        exports.compareAPIResults(apiSuccess, apiFailure),
        "r1:success:test success,r2:failure:404",
    );
    assert.equal(exports.compareAPIResults(null, apiInfo), "r1:nil,r2:info");
    assert.equal(
        exports.compareAPIResults(apiFailure, null),
        "r1:failure:404,r2:nil",
    );
    assert.equal(exports.compareAPIResults(null, null), "r1:nil,r2:nil");

    const optionalGreeter = new exports.Greeter("Schrödinger");
    const optionalGreeter2 = exports.roundTripOptionalClass(optionalGreeter);
    assert.equal(optionalGreeter2?.greet() ?? "", "Hello, Schrödinger!");
    assert.equal(optionalGreeter2?.name ?? "", "Schrödinger");
    assert.equal(optionalGreeter2?.prefix ?? "", "Hello");
    assert.equal(exports.roundTripOptionalClass(null), null);
    optionalGreeter.release();
    optionalGreeter2?.release();

    const optionalsHolder = new exports.OptionalPropertyHolder(null);

    assert.equal(optionalsHolder.optionalName, null);
    assert.equal(optionalsHolder.optionalAge, null);
    assert.equal(optionalsHolder.optionalGreeter, null);

    optionalsHolder.optionalName = "Alice";
    optionalsHolder.optionalAge = 25;
    assert.equal(optionalsHolder.optionalName, "Alice");
    assert.equal(optionalsHolder.optionalAge, 25);

    const testPropertyGreeter = new exports.Greeter("Bob");
    optionalsHolder.optionalGreeter = testPropertyGreeter;
    assert.equal(optionalsHolder.optionalGreeter.greet(), "Hello, Bob!");
    assert.equal(optionalsHolder.optionalGreeter.name, "Bob");

    optionalsHolder.optionalName = null;
    optionalsHolder.optionalAge = null;
    optionalsHolder.optionalGreeter = null;
    assert.equal(optionalsHolder.optionalName, null);
    assert.equal(optionalsHolder.optionalAge, null);
    assert.equal(optionalsHolder.optionalGreeter, null);
    testPropertyGreeter.release();
    optionalsHolder.release();

    const optGreeter = new exports.Greeter("Optionaly");
    assert.equal(exports.roundTripOptionalGreeter(null), null);
    const optGreeterReturned = exports.roundTripOptionalGreeter(optGreeter);
    assert.equal(optGreeterReturned.name, "Optionaly");
    assert.equal(optGreeterReturned.greet(), "Hello, Optionaly!");

    const appliedOptional = exports.applyOptionalGreeter(
        null,
        (g) => g ?? optGreeter,
    );
    assert.equal(appliedOptional.name, "Optionaly");

    const holderOpt = exports.makeOptionalHolder(null, undefined);
    assert.equal(holderOpt.nullableGreeter, null);
    assert.equal(holderOpt.undefinedNumber, undefined);
    holderOpt.nullableGreeter = optGreeter;
    holderOpt.undefinedNumber = 123.5;
    assert.equal(holderOpt.nullableGreeter.name, "Optionaly");
    assert.equal(holderOpt.undefinedNumber, 123.5);
    holderOpt.release();
    optGreeterReturned.release();
    optGreeter.release();

    const aor1 = {
        tag: APIOptionalResultValues.Tag.Success,
        param0: "hello world",
    };
    const aor2 = { tag: APIOptionalResultValues.Tag.Success, param0: null };
    const aor3 = {
        tag: APIOptionalResultValues.Tag.Failure,
        param0: 404,
        param1: true,
    };
    const aor4 = {
        tag: APIOptionalResultValues.Tag.Failure,
        param0: 404,
        param1: null,
    };
    const aor5 = {
        tag: APIOptionalResultValues.Tag.Failure,
        param0: null,
        param1: null,
    };
    const aor6 = {
        tag: APIOptionalResultValues.Tag.Status,
        param0: true,
        param1: 200,
        param2: "OK",
    };
    const aor7 = {
        tag: APIOptionalResultValues.Tag.Status,
        param0: true,
        param1: null,
        param2: "Partial",
    };
    const aor8 = {
        tag: APIOptionalResultValues.Tag.Status,
        param0: null,
        param1: null,
        param2: "Zero",
    };
    const aor9 = {
        tag: APIOptionalResultValues.Tag.Status,
        param0: false,
        param1: 500,
        param2: null,
    };
    const aor10 = {
        tag: APIOptionalResultValues.Tag.Status,
        param0: null,
        param1: 0,
        param2: "Zero",
    };

    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor1), aor1);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor2), aor2);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor3), aor3);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor4), aor4);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor5), aor5);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor6), aor6);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor7), aor7);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor8), aor8);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor9), aor9);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor10), aor10);
    assert.equal(exports.roundTripOptionalAPIOptionalResult(null), null);

    // Optional TypedPayloadResult roundtrip
    const tpr_precision = {
        tag: exports.TypedPayloadResult.Tag.Precision,
        param0: Math.fround(0.1),
    };
    assert.deepEqual(
        exports.roundTripOptionalTypedPayloadResult(tpr_precision),
        tpr_precision,
    );
    const tpr_direction = {
        tag: exports.TypedPayloadResult.Tag.Direction,
        param0: exports.Direction.North,
    };
    assert.deepEqual(
        exports.roundTripOptionalTypedPayloadResult(tpr_direction),
        tpr_direction,
    );
    const tpr_optPrecisionSome = {
        tag: exports.TypedPayloadResult.Tag.OptPrecision,
        param0: Math.fround(0.001),
    };
    assert.deepEqual(
        exports.roundTripOptionalTypedPayloadResult(tpr_optPrecisionSome),
        tpr_optPrecisionSome,
    );
    const tpr_optPrecisionNull = {
        tag: exports.TypedPayloadResult.Tag.OptPrecision,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalTypedPayloadResult(tpr_optPrecisionNull),
        tpr_optPrecisionNull,
    );
    const tpr_empty = { tag: exports.TypedPayloadResult.Tag.Empty };
    assert.deepEqual(
        exports.roundTripOptionalTypedPayloadResult(tpr_empty),
        tpr_empty,
    );
    assert.equal(exports.roundTripOptionalTypedPayloadResult(null), null);

    // Optional AllTypesResult roundtrip
    const atr_struct = {
        tag: AllTypesResultValues.Tag.StructPayload,
        param0: { street: "100 Main St", city: "Boston", zipCode: 2101 },
    };
    assert.deepEqual(
        exports.roundTripOptionalAllTypesResult(atr_struct),
        atr_struct,
    );
    const atr_array = {
        tag: AllTypesResultValues.Tag.ArrayPayload,
        param0: [10, 20, 30],
    };
    assert.deepEqual(
        exports.roundTripOptionalAllTypesResult(atr_array),
        atr_array,
    );
    const atr_empty = { tag: AllTypesResultValues.Tag.Empty };
    assert.deepEqual(
        exports.roundTripOptionalAllTypesResult(atr_empty),
        atr_empty,
    );
    assert.equal(exports.roundTripOptionalAllTypesResult(null), null);

    // OptionalAllTypesResult — optional struct, class, JSObject, nested enum, array as associated value payloads
    const oatr_structSome = {
        tag: OptionalAllTypesResultValues.Tag.OptStruct,
        param0: { street: "200 Oak St", city: "Denver", zipCode: null },
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_structSome),
        oatr_structSome,
    );

    const oatr_structNone = {
        tag: OptionalAllTypesResultValues.Tag.OptStruct,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_structNone),
        oatr_structNone,
    );

    const oatr_classSome = {
        tag: OptionalAllTypesResultValues.Tag.OptClass,
        param0: new exports.Greeter("OptEnumUser"),
    };
    const oatr_classSome_result =
        exports.roundTripOptionalPayloadResult(oatr_classSome);
    assert.equal(
        oatr_classSome_result.tag,
        OptionalAllTypesResultValues.Tag.OptClass,
    );
    assert.equal(oatr_classSome_result.param0.name, "OptEnumUser");

    const oatr_classNone = {
        tag: OptionalAllTypesResultValues.Tag.OptClass,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_classNone),
        oatr_classNone,
    );

    const oatr_jsObjectSome = {
        tag: OptionalAllTypesResultValues.Tag.OptJSObject,
        param0: { key: "value" },
    };
    const oatr_jsObjectSome_result =
        exports.roundTripOptionalPayloadResult(oatr_jsObjectSome);
    assert.equal(
        oatr_jsObjectSome_result.tag,
        OptionalAllTypesResultValues.Tag.OptJSObject,
    );
    assert.equal(oatr_jsObjectSome_result.param0.key, "value");

    const oatr_jsObjectNone = {
        tag: OptionalAllTypesResultValues.Tag.OptJSObject,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_jsObjectNone),
        oatr_jsObjectNone,
    );

    const oatr_nestedEnumSome = {
        tag: OptionalAllTypesResultValues.Tag.OptNestedEnum,
        param0: { tag: APIResultValues.Tag.Failure, param0: 404 },
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_nestedEnumSome),
        oatr_nestedEnumSome,
    );

    const oatr_nestedEnumNone = {
        tag: OptionalAllTypesResultValues.Tag.OptNestedEnum,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_nestedEnumNone),
        oatr_nestedEnumNone,
    );

    const oatr_arraySome = {
        tag: OptionalAllTypesResultValues.Tag.OptArray,
        param0: [1, 2, 3],
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_arraySome),
        oatr_arraySome,
    );

    const oatr_arrayNone = {
        tag: OptionalAllTypesResultValues.Tag.OptArray,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_arrayNone),
        oatr_arrayNone,
    );

    const oatr_jsClassSome = {
        tag: OptionalAllTypesResultValues.Tag.OptJsClass,
        param0: new ImportedFoo("optEnumFoo"),
    };
    const oatr_jsClassSome_result =
        exports.roundTripOptionalPayloadResult(oatr_jsClassSome);
    assert.equal(
        oatr_jsClassSome_result.tag,
        OptionalAllTypesResultValues.Tag.OptJsClass,
    );
    assert.equal(oatr_jsClassSome_result.param0.value, "optEnumFoo");

    const oatr_jsClassNone = {
        tag: OptionalAllTypesResultValues.Tag.OptJsClass,
        param0: null,
    };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_jsClassNone),
        oatr_jsClassNone,
    );

    const oatr_empty = { tag: OptionalAllTypesResultValues.Tag.Empty };
    assert.deepEqual(
        exports.roundTripOptionalPayloadResult(oatr_empty),
        oatr_empty,
    );

    // Optional OptionalAllTypesResult roundtrip
    assert.deepEqual(
        exports.roundTripOptionalPayloadResultOpt(oatr_structSome),
        oatr_structSome,
    );
    assert.deepEqual(
        exports.roundTripOptionalPayloadResultOpt(oatr_structNone),
        oatr_structNone,
    );
    assert.deepEqual(
        exports.roundTripOptionalPayloadResultOpt(oatr_empty),
        oatr_empty,
    );
    assert.equal(exports.roundTripOptionalPayloadResultOpt(null), null);

    exports.takeOptionalJSObject(null);
    assert.doesNotThrow(() => exports.takeOptionalJSObject({ key: "value" }));
}
