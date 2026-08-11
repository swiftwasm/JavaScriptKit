// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const APIResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
        Flag: 2,
        Rate: 3,
        Precise: 4,
        Info: 5,
    },
};
export const ComplexResultValues = {
    Tag: {
        Success: 0,
        Error: 1,
        Status: 2,
        Coordinates: 3,
        Comprehensive: 4,
        Info: 5,
    },
};
export const ResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
        Status: 2,
    },
};
export const NetworkingResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
    },
};
export const APIOptionalResultValues = {
    Tag: {
        Success: 0,
        Failure: 1,
        Status: 2,
    },
};
export const PrecisionValues = {
    Rough: 0.1,
    Fine: 0.001,
};

export const CardinalDirectionValues = {
    North: 0,
    South: 1,
    East: 2,
    West: 3,
};

export const TypedPayloadResultValues = {
    Tag: {
        Precision: 0,
        Direction: 1,
        OptPrecision: 2,
        OptDirection: 3,
        Empty: 4,
    },
};
export const AllTypesResultValues = {
    Tag: {
        StructPayload: 0,
        ClassPayload: 1,
        JsObjectPayload: 2,
        NestedEnum: 3,
        ArrayPayload: 4,
        Empty: 5,
    },
};
export const OptionalAllTypesResultValues = {
    Tag: {
        OptStruct: 0,
        OptClass: 1,
        OptJSObject: 2,
        OptNestedEnum: 3,
        OptArray: 4,
        Empty: 5,
    },
};
export async function createInstantiator(options, swift) {
    let instance;
    let memory;
    let setException;
    let decodeString;
    const textDecoder = new TextDecoder("utf-8");
    const textEncoder = new TextEncoder("utf-8");
    let tmpRetString;
    let tmpRetBytes;
    let tmpRetException;
    let tmpRetOptionalBool;
    let tmpRetOptionalInt;
    let tmpRetOptionalFloat;
    let tmpRetOptionalDouble;
    let tmpRetOptionalHeapObject;
    let strStack = [];
    let i32Stack = [];
    let i64Stack = [];
    let f32Stack = [];
    let f64Stack = [];
    let ptrStack = [];
    let taStack = [];
    const enumHelpers = {};
    const structHelpers = {};

    let _exports = null;
    let bjs = null;
    function __bjs_arrayCodec(elementCodec) {
        return {
            lower(value) {
                for (let i = 0; i < value.length; i++) {
                    elementCodec.lower(value[i]);
                }
                i32Stack.push(value.length);
            },
            lift() {
                const count = i32Stack.pop();
                if (count === -1) {
                    return taStack.pop();
                }
                const result = new Array(count);
                for (let i = count - 1; i >= 0; i--) {
                    result[i] = elementCodec.lift();
                }
                return result;
            },
        };
    }
    function __bjs_optionalCodec(elementCodec, isUndefinedOr = false) {
        return {
            lower(value) {
                const isSome = isUndefinedOr ? value !== undefined : value != null;
                if (isSome) {
                    elementCodec.lower(value);
                    i32Stack.push(1);
                } else {
                    i32Stack.push(0);
                }
            },
            lift() {
                if (i32Stack.pop() === 0) {
                    return isUndefinedOr ? undefined : null;
                }
                return elementCodec.lift();
            },
        };
    }
    function __bjs_dictCodec(valueCodec) {
        return {
            lower(value) {
                const keys = Object.keys(value);
                for (let i = 0; i < keys.length; i++) {
                    __bjs_stringCodec.lower(keys[i]);
                    valueCodec.lower(value[keys[i]]);
                }
                i32Stack.push(keys.length);
            },
            lift() {
                const count = i32Stack.pop();
                const result = {};
                for (let i = 0; i < count; i++) {
                    const value = valueCodec.lift();
                    const key = __bjs_stringCodec.lift();
                    result[key] = value;
                }
                return result;
            },
        };
    }

    const __bjs_stringCodec = {
        lower: (v) => {
            const bytes = textEncoder.encode(v);
            const id = swift.memory.retain(bytes);
            i32Stack.push(bytes.length);
            i32Stack.push(id);
        },
        lift: () => {
            const string = strStack.pop();
            return string;
        },
    };
    const __bjs_primitiveCodecs = {
        Bool: {
            lower: (v) => {
                i32Stack.push(v ? 1 : 0);
            },
            lift: () => {
                const bool = i32Stack.pop() !== 0;
                return bool;
            },
        },
        Int: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        Int8: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        UInt8: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        Int16: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        UInt16: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        Int32: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop();
                return int;
            },
        },
        UInt32: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        UInt: {
            lower: (v) => {
                i32Stack.push((v | 0));
            },
            lift: () => {
                const int = i32Stack.pop() >>> 0;
                return int;
            },
        },
        Int64: {
            lower: (v) => {
                i64Stack.push(v);
            },
            lift: () => {
                const int = i64Stack.pop();
                return int;
            },
        },
        UInt64: {
            lower: (v) => {
                i64Stack.push(v);
            },
            lift: () => {
                const int = i64Stack.pop();
                return int;
            },
        },
        Float: {
            lower: (v) => {
                f32Stack.push(Math.fround(v));
            },
            lift: () => {
                const f32 = f32Stack.pop();
                return f32;
            },
        },
        Double: {
            lower: (v) => {
                f64Stack.push(v);
            },
            lift: () => {
                const f64 = f64Stack.pop();
                return f64;
            },
        },
        String: __bjs_stringCodec,
        JSValue: {
            lower: (v) => {
                const [vKind, vPayload1, vPayload2] = __bjs_jsValueLower(v);
                i32Stack.push(vKind);
                i32Stack.push(vPayload1);
                f64Stack.push(vPayload2);
            },
            lift: () => {
                const jsValuePayload2 = f64Stack.pop();
                const jsValuePayload1 = i32Stack.pop();
                const jsValueKind = i32Stack.pop();
                const jsValue = __bjs_jsValueLift(jsValueKind, jsValuePayload1, jsValuePayload2);
                return jsValue;
            },
        },
    };

    function __bjs_jsValueLower(value) {
        let kind;
        let payload1;
        let payload2;
        if (value === null) {
            kind = 4;
            payload1 = 0;
            payload2 = 0;
        } else {
            switch (typeof value) {
                case "boolean":
                    kind = 0;
                    payload1 = value ? 1 : 0;
                    payload2 = 0;
                    break;
                case "number":
                    kind = 2;
                    payload1 = 0;
                    payload2 = value;
                    break;
                case "string":
                    kind = 1;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "undefined":
                    kind = 5;
                    payload1 = 0;
                    payload2 = 0;
                    break;
                case "object":
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "function":
                    kind = 3;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "symbol":
                    kind = 7;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                case "bigint":
                    kind = 8;
                    payload1 = swift.memory.retain(value);
                    payload2 = 0;
                    break;
                default:
                    throw new TypeError("Unsupported JSValue type");
            }
        }
        return [kind, payload1, payload2];
    }
    function __bjs_jsValueLift(kind, payload1, payload2) {
        let jsValue;
        switch (kind) {
            case 0:
                jsValue = payload1 !== 0;
                break;
            case 1:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 2:
                jsValue = payload2;
                break;
            case 3:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 4:
                jsValue = null;
                break;
            case 5:
                jsValue = undefined;
                break;
            case 7:
                jsValue = swift.memory.getObject(payload1);
                break;
            case 8:
                jsValue = swift.memory.getObject(payload1);
                break;
            default:
                throw new TypeError("Unsupported JSValue kind " + kind);
        }
        return jsValue;
    }

    const __bjs_codec_Optional_String = __bjs_optionalCodec(__bjs_stringCodec);
    const __bjs_codec_Optional_Bool = __bjs_optionalCodec(__bjs_primitiveCodecs.Bool);
    const __bjs_codec_Optional_Int = __bjs_optionalCodec(__bjs_primitiveCodecs.Int);
    const __bjs_codec_TestModule_Precision = {
        lower: (v) => {
            f32Stack.push(Math.fround(v));
        },
        lift: () => {
            const rawValue = f32Stack.pop();
            return rawValue;
        },
    };
    const __bjs_codec_Optional_TestModule_Precision = __bjs_optionalCodec(__bjs_codec_TestModule_Precision);
    const __bjs_codec_TestModule_CardinalDirection = {
        lower: (v) => {
            i32Stack.push((v | 0));
        },
        lift: () => {
            const caseId = i32Stack.pop();
            return caseId;
        },
    };
    const __bjs_codec_Optional_TestModule_CardinalDirection = __bjs_optionalCodec(__bjs_codec_TestModule_CardinalDirection);
    const __bjs_codec_Array_Int = __bjs_arrayCodec(__bjs_primitiveCodecs.Int);
    const __bjs_codec_TestModule_Point = {
        lower: (v) => {
            structHelpers.Point.lower(v);
        },
        lift: () => {
            const struct = structHelpers.Point.lift();
            return struct;
        },
    };
    const __bjs_codec_Optional_TestModule_Point = __bjs_optionalCodec(__bjs_codec_TestModule_Point);
    const __bjs_codec_TestModule_User = {
        lower: (v) => {
            ptrStack.push(v.pointer);
        },
        lift: () => {
            const ptr = ptrStack.pop();
            const obj = _exports['User'].__construct(ptr);
            return obj;
        },
    };
    const __bjs_codec_Optional_TestModule_User = __bjs_optionalCodec(__bjs_codec_TestModule_User);
    const __bjs_codec_JSObject = {
        lower: (v) => {
            const objId = swift.memory.retain(v);
            i32Stack.push(objId);
        },
        lift: () => {
            const objId = i32Stack.pop();
            const obj = swift.memory.getObject(objId);
            swift.memory.release(objId);
            return obj;
        },
    };
    const __bjs_codec_Optional_JSObject = __bjs_optionalCodec(__bjs_codec_JSObject);
    const __bjs_codec_TestModule_APIResult = {
        lower: (v) => {
            const caseId = enumHelpers.APIResult.lower(v);
            i32Stack.push(caseId);
        },
        lift: () => {
            const enumValue = enumHelpers.APIResult.lift(i32Stack.pop());
            return enumValue;
        },
    };
    const __bjs_codec_Optional_TestModule_APIResult = __bjs_optionalCodec(__bjs_codec_TestModule_APIResult);
    const __bjs_codec_Optional_Array_Int = __bjs_optionalCodec(__bjs_codec_Array_Int);

    const __bjs_createPointHelpers = () => ({
        lower: (value) => {
            f64Stack.push(value.x);
            f64Stack.push(value.y);
        },
        lift: () => {
            const f64 = f64Stack.pop();
            const f641 = f64Stack.pop();
            return { x: f641, y: f64 };
        }
    });
    const __bjs_createAPIResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case APIResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return APIResultValues.Tag.Success;
                }
                case APIResultValues.Tag.Failure: {
                    i32Stack.push((value.param0 | 0));
                    return APIResultValues.Tag.Failure;
                }
                case APIResultValues.Tag.Flag: {
                    i32Stack.push(value.param0 ? 1 : 0);
                    return APIResultValues.Tag.Flag;
                }
                case APIResultValues.Tag.Rate: {
                    f32Stack.push(Math.fround(value.param0));
                    return APIResultValues.Tag.Rate;
                }
                case APIResultValues.Tag.Precise: {
                    f64Stack.push(value.param0);
                    return APIResultValues.Tag.Precise;
                }
                case APIResultValues.Tag.Info: {
                    return APIResultValues.Tag.Info;
                }
                default: throw new Error("Unknown APIResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case APIResultValues.Tag.Success: {
                    const string = strStack.pop();
                    return { tag: APIResultValues.Tag.Success, param0: string };
                }
                case APIResultValues.Tag.Failure: {
                    const int = i32Stack.pop();
                    return { tag: APIResultValues.Tag.Failure, param0: int };
                }
                case APIResultValues.Tag.Flag: {
                    const bool = i32Stack.pop() !== 0;
                    return { tag: APIResultValues.Tag.Flag, param0: bool };
                }
                case APIResultValues.Tag.Rate: {
                    const f32 = f32Stack.pop();
                    return { tag: APIResultValues.Tag.Rate, param0: f32 };
                }
                case APIResultValues.Tag.Precise: {
                    const f64 = f64Stack.pop();
                    return { tag: APIResultValues.Tag.Precise, param0: f64 };
                }
                case APIResultValues.Tag.Info: return { tag: APIResultValues.Tag.Info };
                default: throw new Error("Unknown APIResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createComplexResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ComplexResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return ComplexResultValues.Tag.Success;
                }
                case ComplexResultValues.Tag.Error: {
                    i32Stack.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return ComplexResultValues.Tag.Error;
                }
                case ComplexResultValues.Tag.Status: {
                    const bytes = textEncoder.encode(value.param2);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    i32Stack.push((value.param1 | 0));
                    i32Stack.push(value.param0 ? 1 : 0);
                    return ComplexResultValues.Tag.Status;
                }
                case ComplexResultValues.Tag.Coordinates: {
                    f64Stack.push(value.param2);
                    f64Stack.push(value.param1);
                    f64Stack.push(value.param0);
                    return ComplexResultValues.Tag.Coordinates;
                }
                case ComplexResultValues.Tag.Comprehensive: {
                    const bytes = textEncoder.encode(value.param8);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    const bytes1 = textEncoder.encode(value.param7);
                    const id1 = swift.memory.retain(bytes1);
                    i32Stack.push(bytes1.length);
                    i32Stack.push(id1);
                    const bytes2 = textEncoder.encode(value.param6);
                    const id2 = swift.memory.retain(bytes2);
                    i32Stack.push(bytes2.length);
                    i32Stack.push(id2);
                    f64Stack.push(value.param5);
                    f64Stack.push(value.param4);
                    i32Stack.push((value.param3 | 0));
                    i32Stack.push((value.param2 | 0));
                    i32Stack.push(value.param1 ? 1 : 0);
                    i32Stack.push(value.param0 ? 1 : 0);
                    return ComplexResultValues.Tag.Comprehensive;
                }
                case ComplexResultValues.Tag.Info: {
                    return ComplexResultValues.Tag.Info;
                }
                default: throw new Error("Unknown ComplexResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case ComplexResultValues.Tag.Success: {
                    const string = strStack.pop();
                    return { tag: ComplexResultValues.Tag.Success, param0: string };
                }
                case ComplexResultValues.Tag.Error: {
                    const int = i32Stack.pop();
                    const string = strStack.pop();
                    return { tag: ComplexResultValues.Tag.Error, param0: string, param1: int };
                }
                case ComplexResultValues.Tag.Status: {
                    const string = strStack.pop();
                    const int = i32Stack.pop();
                    const bool = i32Stack.pop() !== 0;
                    return { tag: ComplexResultValues.Tag.Status, param0: bool, param1: int, param2: string };
                }
                case ComplexResultValues.Tag.Coordinates: {
                    const f64 = f64Stack.pop();
                    const f641 = f64Stack.pop();
                    const f642 = f64Stack.pop();
                    return { tag: ComplexResultValues.Tag.Coordinates, param0: f642, param1: f641, param2: f64 };
                }
                case ComplexResultValues.Tag.Comprehensive: {
                    const string = strStack.pop();
                    const string1 = strStack.pop();
                    const string2 = strStack.pop();
                    const f64 = f64Stack.pop();
                    const f641 = f64Stack.pop();
                    const int = i32Stack.pop();
                    const int1 = i32Stack.pop();
                    const bool = i32Stack.pop() !== 0;
                    const bool1 = i32Stack.pop() !== 0;
                    return { tag: ComplexResultValues.Tag.Comprehensive, param0: bool1, param1: bool, param2: int1, param3: int, param4: f641, param5: f64, param6: string2, param7: string1, param8: string };
                }
                case ComplexResultValues.Tag.Info: return { tag: ComplexResultValues.Tag.Info };
                default: throw new Error("Unknown ComplexResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case ResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return ResultValues.Tag.Success;
                }
                case ResultValues.Tag.Failure: {
                    i32Stack.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return ResultValues.Tag.Failure;
                }
                case ResultValues.Tag.Status: {
                    const bytes = textEncoder.encode(value.param2);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    i32Stack.push((value.param1 | 0));
                    i32Stack.push(value.param0 ? 1 : 0);
                    return ResultValues.Tag.Status;
                }
                default: throw new Error("Unknown ResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case ResultValues.Tag.Success: {
                    const string = strStack.pop();
                    return { tag: ResultValues.Tag.Success, param0: string };
                }
                case ResultValues.Tag.Failure: {
                    const int = i32Stack.pop();
                    const string = strStack.pop();
                    return { tag: ResultValues.Tag.Failure, param0: string, param1: int };
                }
                case ResultValues.Tag.Status: {
                    const string = strStack.pop();
                    const int = i32Stack.pop();
                    const bool = i32Stack.pop() !== 0;
                    return { tag: ResultValues.Tag.Status, param0: bool, param1: int, param2: string };
                }
                default: throw new Error("Unknown ResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createNetworkingResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case NetworkingResultValues.Tag.Success: {
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return NetworkingResultValues.Tag.Success;
                }
                case NetworkingResultValues.Tag.Failure: {
                    i32Stack.push((value.param1 | 0));
                    const bytes = textEncoder.encode(value.param0);
                    const id = swift.memory.retain(bytes);
                    i32Stack.push(bytes.length);
                    i32Stack.push(id);
                    return NetworkingResultValues.Tag.Failure;
                }
                default: throw new Error("Unknown NetworkingResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case NetworkingResultValues.Tag.Success: {
                    const string = strStack.pop();
                    return { tag: NetworkingResultValues.Tag.Success, param0: string };
                }
                case NetworkingResultValues.Tag.Failure: {
                    const int = i32Stack.pop();
                    const string = strStack.pop();
                    return { tag: NetworkingResultValues.Tag.Failure, param0: string, param1: int };
                }
                default: throw new Error("Unknown NetworkingResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createAPIOptionalResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case APIOptionalResultValues.Tag.Success: {
                    __bjs_codec_Optional_String.lower(value.param0);
                    return APIOptionalResultValues.Tag.Success;
                }
                case APIOptionalResultValues.Tag.Failure: {
                    __bjs_codec_Optional_Bool.lower(value.param1);
                    __bjs_codec_Optional_Int.lower(value.param0);
                    return APIOptionalResultValues.Tag.Failure;
                }
                case APIOptionalResultValues.Tag.Status: {
                    __bjs_codec_Optional_String.lower(value.param2);
                    __bjs_codec_Optional_Int.lower(value.param1);
                    __bjs_codec_Optional_Bool.lower(value.param0);
                    return APIOptionalResultValues.Tag.Status;
                }
                default: throw new Error("Unknown APIOptionalResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case APIOptionalResultValues.Tag.Success: {
                    const optValue = __bjs_codec_Optional_String.lift();
                    return { tag: APIOptionalResultValues.Tag.Success, param0: optValue };
                }
                case APIOptionalResultValues.Tag.Failure: {
                    const optValue = __bjs_codec_Optional_Bool.lift();
                    const optValue1 = __bjs_codec_Optional_Int.lift();
                    return { tag: APIOptionalResultValues.Tag.Failure, param0: optValue1, param1: optValue };
                }
                case APIOptionalResultValues.Tag.Status: {
                    const optValue = __bjs_codec_Optional_String.lift();
                    const optValue1 = __bjs_codec_Optional_Int.lift();
                    const optValue2 = __bjs_codec_Optional_Bool.lift();
                    return { tag: APIOptionalResultValues.Tag.Status, param0: optValue2, param1: optValue1, param2: optValue };
                }
                default: throw new Error("Unknown APIOptionalResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createTypedPayloadResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case TypedPayloadResultValues.Tag.Precision: {
                    f32Stack.push(Math.fround(value.param0));
                    return TypedPayloadResultValues.Tag.Precision;
                }
                case TypedPayloadResultValues.Tag.Direction: {
                    i32Stack.push((value.param0 | 0));
                    return TypedPayloadResultValues.Tag.Direction;
                }
                case TypedPayloadResultValues.Tag.OptPrecision: {
                    __bjs_codec_Optional_TestModule_Precision.lower(value.param0);
                    return TypedPayloadResultValues.Tag.OptPrecision;
                }
                case TypedPayloadResultValues.Tag.OptDirection: {
                    __bjs_codec_Optional_TestModule_CardinalDirection.lower(value.param0);
                    return TypedPayloadResultValues.Tag.OptDirection;
                }
                case TypedPayloadResultValues.Tag.Empty: {
                    return TypedPayloadResultValues.Tag.Empty;
                }
                default: throw new Error("Unknown TypedPayloadResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case TypedPayloadResultValues.Tag.Precision: {
                    const rawValue = f32Stack.pop();
                    return { tag: TypedPayloadResultValues.Tag.Precision, param0: rawValue };
                }
                case TypedPayloadResultValues.Tag.Direction: {
                    const caseId = i32Stack.pop();
                    return { tag: TypedPayloadResultValues.Tag.Direction, param0: caseId };
                }
                case TypedPayloadResultValues.Tag.OptPrecision: {
                    const optValue = __bjs_codec_Optional_TestModule_Precision.lift();
                    return { tag: TypedPayloadResultValues.Tag.OptPrecision, param0: optValue };
                }
                case TypedPayloadResultValues.Tag.OptDirection: {
                    const optValue = __bjs_codec_Optional_TestModule_CardinalDirection.lift();
                    return { tag: TypedPayloadResultValues.Tag.OptDirection, param0: optValue };
                }
                case TypedPayloadResultValues.Tag.Empty: return { tag: TypedPayloadResultValues.Tag.Empty };
                default: throw new Error("Unknown TypedPayloadResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createAllTypesResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case AllTypesResultValues.Tag.StructPayload: {
                    structHelpers.Point.lower(value.param0);
                    return AllTypesResultValues.Tag.StructPayload;
                }
                case AllTypesResultValues.Tag.ClassPayload: {
                    ptrStack.push(value.param0.pointer);
                    return AllTypesResultValues.Tag.ClassPayload;
                }
                case AllTypesResultValues.Tag.JsObjectPayload: {
                    const objId = swift.memory.retain(value.param0);
                    i32Stack.push(objId);
                    return AllTypesResultValues.Tag.JsObjectPayload;
                }
                case AllTypesResultValues.Tag.NestedEnum: {
                    const caseId = enumHelpers.APIResult.lower(value.param0);
                    i32Stack.push(caseId);
                    return AllTypesResultValues.Tag.NestedEnum;
                }
                case AllTypesResultValues.Tag.ArrayPayload: {
                    __bjs_codec_Array_Int.lower(value.param0);
                    return AllTypesResultValues.Tag.ArrayPayload;
                }
                case AllTypesResultValues.Tag.Empty: {
                    return AllTypesResultValues.Tag.Empty;
                }
                default: throw new Error("Unknown AllTypesResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case AllTypesResultValues.Tag.StructPayload: {
                    const struct = structHelpers.Point.lift();
                    return { tag: AllTypesResultValues.Tag.StructPayload, param0: struct };
                }
                case AllTypesResultValues.Tag.ClassPayload: {
                    const ptr = ptrStack.pop();
                    const obj = _exports['User'].__construct(ptr);
                    return { tag: AllTypesResultValues.Tag.ClassPayload, param0: obj };
                }
                case AllTypesResultValues.Tag.JsObjectPayload: {
                    const objId = i32Stack.pop();
                    const obj = swift.memory.getObject(objId);
                    swift.memory.release(objId);
                    return { tag: AllTypesResultValues.Tag.JsObjectPayload, param0: obj };
                }
                case AllTypesResultValues.Tag.NestedEnum: {
                    const enumValue = enumHelpers.APIResult.lift(i32Stack.pop());
                    return { tag: AllTypesResultValues.Tag.NestedEnum, param0: enumValue };
                }
                case AllTypesResultValues.Tag.ArrayPayload: {
                    const arrayResult = __bjs_codec_Array_Int.lift();
                    return { tag: AllTypesResultValues.Tag.ArrayPayload, param0: arrayResult };
                }
                case AllTypesResultValues.Tag.Empty: return { tag: AllTypesResultValues.Tag.Empty };
                default: throw new Error("Unknown AllTypesResultValues tag returned from Swift: " + String(tag));
            }
        }
    });
    const __bjs_createOptionalAllTypesResultValuesHelpers = () => ({
        lower: (value) => {
            const enumTag = value.tag;
            switch (enumTag) {
                case OptionalAllTypesResultValues.Tag.OptStruct: {
                    __bjs_codec_Optional_TestModule_Point.lower(value.param0);
                    return OptionalAllTypesResultValues.Tag.OptStruct;
                }
                case OptionalAllTypesResultValues.Tag.OptClass: {
                    __bjs_codec_Optional_TestModule_User.lower(value.param0);
                    return OptionalAllTypesResultValues.Tag.OptClass;
                }
                case OptionalAllTypesResultValues.Tag.OptJSObject: {
                    __bjs_codec_Optional_JSObject.lower(value.param0);
                    return OptionalAllTypesResultValues.Tag.OptJSObject;
                }
                case OptionalAllTypesResultValues.Tag.OptNestedEnum: {
                    __bjs_codec_Optional_TestModule_APIResult.lower(value.param0);
                    return OptionalAllTypesResultValues.Tag.OptNestedEnum;
                }
                case OptionalAllTypesResultValues.Tag.OptArray: {
                    __bjs_codec_Optional_Array_Int.lower(value.param0);
                    return OptionalAllTypesResultValues.Tag.OptArray;
                }
                case OptionalAllTypesResultValues.Tag.Empty: {
                    return OptionalAllTypesResultValues.Tag.Empty;
                }
                default: throw new Error("Unknown OptionalAllTypesResultValues tag: " + String(enumTag));
            }
        },
        lift: (tag) => {
            tag = tag | 0;
            switch (tag) {
                case OptionalAllTypesResultValues.Tag.OptStruct: {
                    const optValue = __bjs_codec_Optional_TestModule_Point.lift();
                    return { tag: OptionalAllTypesResultValues.Tag.OptStruct, param0: optValue };
                }
                case OptionalAllTypesResultValues.Tag.OptClass: {
                    const optValue = __bjs_codec_Optional_TestModule_User.lift();
                    return { tag: OptionalAllTypesResultValues.Tag.OptClass, param0: optValue };
                }
                case OptionalAllTypesResultValues.Tag.OptJSObject: {
                    const optValue = __bjs_codec_Optional_JSObject.lift();
                    return { tag: OptionalAllTypesResultValues.Tag.OptJSObject, param0: optValue };
                }
                case OptionalAllTypesResultValues.Tag.OptNestedEnum: {
                    const optValue = __bjs_codec_Optional_TestModule_APIResult.lift();
                    return { tag: OptionalAllTypesResultValues.Tag.OptNestedEnum, param0: optValue };
                }
                case OptionalAllTypesResultValues.Tag.OptArray: {
                    const optValue = __bjs_codec_Optional_Array_Int.lift();
                    return { tag: OptionalAllTypesResultValues.Tag.OptArray, param0: optValue };
                }
                case OptionalAllTypesResultValues.Tag.Empty: return { tag: OptionalAllTypesResultValues.Tag.Empty };
                default: throw new Error("Unknown OptionalAllTypesResultValues tag returned from Swift: " + String(tag));
            }
        }
    });

    return {
        /**
         * @param {WebAssembly.Imports} importObject
         */
        addImports: (importObject, importsContext) => {
            bjs = {};
            importObject["bjs"] = bjs;
            bjs["swift_js_return_string"] = function(ptr, len) {
                tmpRetString = decodeString(ptr, len);
            }
            bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                const source = swift.memory.getObject(sourceId);
                swift.memory.release(sourceId);
                const bytes = new Uint8Array(memory.buffer, bytesPtr >>> 0);
                bytes.set(source);
            }
            bjs["swift_js_make_js_string"] = function(ptr, len) {
                return swift.memory.retain(decodeString(ptr, len));
            }
            bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                const target = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0);
                target.set(tmpRetBytes);
                tmpRetBytes = undefined;
            }
            bjs["swift_js_throw"] = function(id) {
                tmpRetException = swift.memory.retainByRef(id);
            }
            bjs["swift_js_retain"] = function(id) {
                return swift.memory.retainByRef(id);
            }
            bjs["swift_js_release"] = function(id) {
                swift.memory.release(id);
            }
            bjs["swift_js_push_i32"] = function(v) {
                i32Stack.push(v | 0);
            }
            bjs["swift_js_push_f32"] = function(v) {
                f32Stack.push(Math.fround(v));
            }
            bjs["swift_js_push_f64"] = function(v) {
                f64Stack.push(v);
            }
            bjs["swift_js_push_string"] = function(ptr, len) {
                const value = decodeString(ptr, len);
                strStack.push(value);
            }
            bjs["swift_js_pop_i32"] = function() {
                return i32Stack.pop();
            }
            bjs["swift_js_pop_f32"] = function() {
                return f32Stack.pop();
            }
            bjs["swift_js_pop_f64"] = function() {
                return f64Stack.pop();
            }
            bjs["swift_js_push_pointer"] = function(pointer) {
                ptrStack.push(pointer);
            }
            bjs["swift_js_pop_pointer"] = function() {
                return ptrStack.pop();
            }
            bjs["swift_js_push_i64"] = function(v) {
                i64Stack.push(v);
            }
            bjs["swift_js_pop_i64"] = function() {
                return i64Stack.pop();
            }
            const taCtors = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array];
            bjs["swift_js_push_typed_array"] = function(kind, ptr, count) {
                const Ctor = taCtors[kind];
                const byteLen = count * Ctor.BYTES_PER_ELEMENT;
                const copy = memory.buffer.slice(ptr, ptr + byteLen);
                taStack.push(Array.from(new Ctor(copy)));
            }
            bjs["swift_js_struct_lower_Point"] = function(objectId) {
                structHelpers.Point.lower(swift.memory.getObject(objectId));
            }
            bjs["swift_js_struct_lift_Point"] = function() {
                const value = structHelpers.Point.lift();
                return swift.memory.retain(value);
            }
            bjs["bjs_core_register_type_handles"] = function() {};
            bjs["bjs_TestModule_register_type_handles"] = function() {};
            const __bjs_promiseSettlers = Symbol("JavaScriptKit.promiseSettlers");
            bjs["swift_js_make_promise"] = function() {
                let resolve, reject;
                const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
                promise[__bjs_promiseSettlers] = { resolve, reject };
                return swift.memory.retain(promise);
            }
            bjs["swift_js_return_optional_bool"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalBool = null;
                } else {
                    tmpRetOptionalBool = value !== 0;
                }
            }
            bjs["swift_js_return_optional_int"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalInt = null;
                } else {
                    tmpRetOptionalInt = value | 0;
                }
            }
            bjs["swift_js_return_optional_float"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalFloat = null;
                } else {
                    tmpRetOptionalFloat = Math.fround(value);
                }
            }
            bjs["swift_js_return_optional_double"] = function(isSome, value) {
                if (isSome === 0) {
                    tmpRetOptionalDouble = null;
                } else {
                    tmpRetOptionalDouble = value;
                }
            }
            bjs["swift_js_return_optional_string"] = function(isSome, ptr, len) {
                if (isSome === 0) {
                    tmpRetString = null;
                } else {
                    tmpRetString = decodeString(ptr, len);
                }
            }
            bjs["swift_js_return_optional_object"] = function(isSome, objectId) {
                if (isSome === 0) {
                    tmpRetString = null;
                } else {
                    tmpRetString = swift.memory.getObject(objectId);
                }
            }
            bjs["swift_js_return_optional_heap_object"] = function(isSome, pointer) {
                if (isSome === 0) {
                    tmpRetOptionalHeapObject = null;
                } else {
                    tmpRetOptionalHeapObject = pointer;
                }
            }
            bjs["swift_js_get_optional_int_presence"] = function() {
                return tmpRetOptionalInt != null ? 1 : 0;
            }
            bjs["swift_js_get_optional_int_value"] = function() {
                const value = tmpRetOptionalInt;
                tmpRetOptionalInt = undefined;
                return value;
            }
            bjs["swift_js_get_optional_string"] = function() {
                const str = tmpRetString;
                tmpRetString = undefined;
                if (str == null) {
                    return -1;
                } else {
                    const bytes = textEncoder.encode(str);
                    tmpRetBytes = bytes;
                    return bytes.length;
                }
            }
            bjs["swift_js_get_optional_float_presence"] = function() {
                return tmpRetOptionalFloat != null ? 1 : 0;
            }
            bjs["swift_js_get_optional_float_value"] = function() {
                const value = tmpRetOptionalFloat;
                tmpRetOptionalFloat = undefined;
                return value;
            }
            bjs["swift_js_get_optional_double_presence"] = function() {
                return tmpRetOptionalDouble != null ? 1 : 0;
            }
            bjs["swift_js_get_optional_double_value"] = function() {
                const value = tmpRetOptionalDouble;
                tmpRetOptionalDouble = undefined;
                return value;
            }
            bjs["swift_js_get_optional_heap_object_pointer"] = function() {
                const pointer = tmpRetOptionalHeapObject;
                tmpRetOptionalHeapObject = undefined;
                return pointer || 0;
            }
            bjs["swift_js_closure_unregister"] = function(funcRef) {}
            // Wrapper functions for module: TestModule
            if (!importObject["TestModule"]) {
                importObject["TestModule"] = {};
            }
            importObject["TestModule"]["bjs_User_wrap"] = function(pointer) {
                const obj = _exports['User'].__construct(pointer);
                return swift.memory.retain(obj);
            };
        },
        setInstance: (i) => {
            instance = i;
            memory = instance.exports.memory;

            decodeString = (ptr, len) => { const bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0); return textDecoder.decode(bytes); }

            setException = (error) => {
                instance.exports._swift_js_exception.value = swift.memory.retain(error)
            }
        },
        /** @param {WebAssembly.Instance} instance */
        createExports: (instance) => {
            const js = swift.memory.heap;
            const swiftHeapObjectFinalizationRegistry = (typeof FinalizationRegistry === "undefined") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {
                if (state.hasReleased) {
                    return;
                }
                state.hasReleased = true;
                state.identityMap?.delete(state.pointer);
                state.deinit(state.pointer);
            });

            /// Represents a Swift heap object like a class instance or an actor instance.
            class SwiftHeapObject {
                static __wrap(pointer, deinit, prototype, identityCache) {
                    pointer = pointer >>> 0;
                    const makeFresh = (identityMap) => {
                        const obj = Object.create(prototype);
                        const state = { pointer, deinit, hasReleased: false, identityMap };
                        obj.pointer = pointer;
                        obj.__swiftHeapObjectState = state;
                        swiftHeapObjectFinalizationRegistry.register(obj, state, state);
                        if (identityMap) {
                            identityMap.set(pointer, new WeakRef(obj));
                        }
                        return obj;
                    };

                    if (!identityCache) {
                        return makeFresh(null);
                    }

                    const cached = identityCache.get(pointer)?.deref();
                    if (cached && !cached.__swiftHeapObjectState.hasReleased) {
                        deinit(pointer);
                        return cached;
                    }
                    if (identityCache.has(pointer)) {
                        identityCache.delete(pointer);
                    }

                    return makeFresh(identityCache);
                }

                release() {
                    const state = this.__swiftHeapObjectState;
                    if (state.hasReleased) {
                        return;
                    }
                    state.hasReleased = true;
                    swiftHeapObjectFinalizationRegistry.unregister(state);
                    state.identityMap?.delete(state.pointer);
                    state.deinit(state.pointer);
                }
            }
            class User extends SwiftHeapObject {
                static __construct(ptr) {
                    return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_User_deinit, User.prototype, null);
                }

            }
            const PointHelpers = __bjs_createPointHelpers();
            structHelpers.Point = PointHelpers;

            const APIResultHelpers = __bjs_createAPIResultValuesHelpers();
            enumHelpers.APIResult = APIResultHelpers;

            const ComplexResultHelpers = __bjs_createComplexResultValuesHelpers();
            enumHelpers.ComplexResult = ComplexResultHelpers;

            const ResultHelpers = __bjs_createResultValuesHelpers();
            enumHelpers.Result = ResultHelpers;

            const NetworkingResultHelpers = __bjs_createNetworkingResultValuesHelpers();
            enumHelpers.NetworkingResult = NetworkingResultHelpers;

            const APIOptionalResultHelpers = __bjs_createAPIOptionalResultValuesHelpers();
            enumHelpers.APIOptionalResult = APIOptionalResultHelpers;

            const TypedPayloadResultHelpers = __bjs_createTypedPayloadResultValuesHelpers();
            enumHelpers.TypedPayloadResult = TypedPayloadResultHelpers;

            const AllTypesResultHelpers = __bjs_createAllTypesResultValuesHelpers();
            enumHelpers.AllTypesResult = AllTypesResultHelpers;

            const OptionalAllTypesResultHelpers = __bjs_createOptionalAllTypesResultValuesHelpers();
            enumHelpers.OptionalAllTypesResult = OptionalAllTypesResultHelpers;

            const exports = {
                handle: function bjs_handle(result) {
                    const resultCaseId = enumHelpers.APIResult.lower(result);
                    instance.exports.bjs_handle(resultCaseId);
                },
                getResult: function bjs_getResult() {
                    instance.exports.bjs_getResult();
                    const ret = enumHelpers.APIResult.lift(i32Stack.pop());
                    return ret;
                },
                roundtripAPIResult: function bjs_roundtripAPIResult(result) {
                    const resultCaseId = enumHelpers.APIResult.lower(result);
                    instance.exports.bjs_roundtripAPIResult(resultCaseId);
                    const ret = enumHelpers.APIResult.lift(i32Stack.pop());
                    return ret;
                },
                roundTripOptionalAPIResult: function bjs_roundTripOptionalAPIResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.APIResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalAPIResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.APIResult.lift(tag);
                    return optResult;
                },
                handleComplex: function bjs_handleComplex(result) {
                    const resultCaseId = enumHelpers.ComplexResult.lower(result);
                    instance.exports.bjs_handleComplex(resultCaseId);
                },
                getComplexResult: function bjs_getComplexResult() {
                    instance.exports.bjs_getComplexResult();
                    const ret = enumHelpers.ComplexResult.lift(i32Stack.pop());
                    return ret;
                },
                roundtripComplexResult: function bjs_roundtripComplexResult(result) {
                    const resultCaseId = enumHelpers.ComplexResult.lower(result);
                    instance.exports.bjs_roundtripComplexResult(resultCaseId);
                    const ret = enumHelpers.ComplexResult.lift(i32Stack.pop());
                    return ret;
                },
                roundTripOptionalComplexResult: function bjs_roundTripOptionalComplexResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.ComplexResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalComplexResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.ComplexResult.lift(tag);
                    return optResult;
                },
                roundTripOptionalUtilitiesResult: function bjs_roundTripOptionalUtilitiesResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.Result.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalUtilitiesResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.Result.lift(tag);
                    return optResult;
                },
                roundTripOptionalNetworkingResult: function bjs_roundTripOptionalNetworkingResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.NetworkingResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalNetworkingResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.NetworkingResult.lift(tag);
                    return optResult;
                },
                roundTripOptionalAPIOptionalResult: function bjs_roundTripOptionalAPIOptionalResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.APIOptionalResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalAPIOptionalResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.APIOptionalResult.lift(tag);
                    return optResult;
                },
                compareAPIResults: function bjs_compareAPIResults(result1, result2) {
                    const isSome = result1 != null;
                    let result;
                    if (isSome) {
                        const result1CaseId = enumHelpers.APIOptionalResult.lower(result1);
                        result = result1CaseId;
                    } else {
                        result = 0;
                    }
                    const isSome1 = result2 != null;
                    let result3;
                    if (isSome1) {
                        const result2CaseId = enumHelpers.APIOptionalResult.lower(result2);
                        result3 = result2CaseId;
                    } else {
                        result3 = 0;
                    }
                    instance.exports.bjs_compareAPIResults(+isSome, result, +isSome1, result3);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.APIOptionalResult.lift(tag);
                    return optResult;
                },
                roundTripTypedPayloadResult: function bjs_roundTripTypedPayloadResult(result) {
                    const resultCaseId = enumHelpers.TypedPayloadResult.lower(result);
                    instance.exports.bjs_roundTripTypedPayloadResult(resultCaseId);
                    const ret = enumHelpers.TypedPayloadResult.lift(i32Stack.pop());
                    return ret;
                },
                roundTripOptionalTypedPayloadResult: function bjs_roundTripOptionalTypedPayloadResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.TypedPayloadResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalTypedPayloadResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.TypedPayloadResult.lift(tag);
                    return optResult;
                },
                roundTripAllTypesResult: function bjs_roundTripAllTypesResult(result) {
                    const resultCaseId = enumHelpers.AllTypesResult.lower(result);
                    instance.exports.bjs_roundTripAllTypesResult(resultCaseId);
                    const ret = enumHelpers.AllTypesResult.lift(i32Stack.pop());
                    return ret;
                },
                roundTripOptionalAllTypesResult: function bjs_roundTripOptionalAllTypesResult(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.AllTypesResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalAllTypesResult(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.AllTypesResult.lift(tag);
                    return optResult;
                },
                roundTripOptionalPayloadResult: function bjs_roundTripOptionalPayloadResult(result) {
                    const resultCaseId = enumHelpers.OptionalAllTypesResult.lower(result);
                    instance.exports.bjs_roundTripOptionalPayloadResult(resultCaseId);
                    const ret = enumHelpers.OptionalAllTypesResult.lift(i32Stack.pop());
                    return ret;
                },
                roundTripOptionalPayloadResultOpt: function bjs_roundTripOptionalPayloadResultOpt(result) {
                    const isSome = result != null;
                    let result1;
                    if (isSome) {
                        const resultCaseId = enumHelpers.OptionalAllTypesResult.lower(result);
                        result1 = resultCaseId;
                    } else {
                        result1 = 0;
                    }
                    instance.exports.bjs_roundTripOptionalPayloadResultOpt(+isSome, result1);
                    const tag = i32Stack.pop();
                    const optResult = tag === -1 ? null : enumHelpers.OptionalAllTypesResult.lift(tag);
                    return optResult;
                },
                APIResult: APIResultValues,
                ComplexResult: ComplexResultValues,
                APIOptionalResult: APIOptionalResultValues,
                Precision: PrecisionValues,
                CardinalDirection: CardinalDirectionValues,
                TypedPayloadResult: TypedPayloadResultValues,
                AllTypesResult: AllTypesResultValues,
                OptionalAllTypesResult: OptionalAllTypesResultValues,
                API: {
                    NetworkingResult: NetworkingResultValues,
                },
                User,
                Utilities: {
                    Result: ResultValues,
                },
            };
            _exports = exports;
            return exports;
        },
    }
}