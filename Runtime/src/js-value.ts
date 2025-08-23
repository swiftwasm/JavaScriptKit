import { JSObjectSpace } from "./object-heap.js";
import {
    assertNever,
    JavaScriptValueKindAndFlags,
    pointer,
    ref,
} from "./types.js";

export const enum Kind {
    Boolean = 0,
    String = 1,
    Number = 2,
    Object = 3,
    Null = 4,
    Undefined = 5,
    Function = 6,
    Symbol = 7,
    BigInt = 8,
}

export const decode = (
    kind: Kind,
    payload1: number,
    payload2: number,
    objectSpace: JSObjectSpace,
) => {
    switch (kind) {
        case Kind.Boolean:
            switch (payload1) {
                case 0:
                    return false;
                case 1:
                    return true;
            }
        case Kind.Number:
            return payload2;

        case Kind.String:
        case Kind.Object:
        case Kind.Function:
        case Kind.Symbol:
        case Kind.BigInt:
            return objectSpace.getObject(payload1);

        case Kind.Null:
            return null;

        case Kind.Undefined:
            return undefined;

        default:
            assertNever(kind, `JSValue Type kind "${kind}" is not supported`);
    }
};

// Note:
// `decodeValues` assumes that the size of RawJSValue is 16.
export const decodeArray = (
    ptr: pointer,
    length: number,
    memory: DataView,
    objectSpace: JSObjectSpace,
) => {
    // fast path for empty array
    if (length === 0) {
        return [];
    }

    let result = [];
    for (let index = 0; index < length; index++) {
        const base = ptr + 16 * index;
        const kind = memory.getUint32(base, true);
        const payload1 = memory.getUint32(base + 4, true);
        const payload2 = memory.getFloat64(base + 8, true);
        result.push(decode(kind, payload1, payload2, objectSpace));
    }
    return result;
};

// A helper function to encode a RawJSValue into a pointers.
// Please prefer to use `writeAndReturnKindBits` to avoid unnecessary
// memory stores.
// This function should be used only when kind flag is stored in memory.
export const write = (
    value: any,
    kind_ptr: pointer,
    payload1_ptr: pointer,
    payload2_ptr: pointer,
    is_exception: boolean,
    memory: DataView,
    objectSpace: JSObjectSpace,
) => {
    const kind = writeAndReturnKindBits(
        value,
        payload1_ptr,
        payload2_ptr,
        is_exception,
        memory,
        objectSpace,
    );
    memory.setUint32(kind_ptr, kind, true);
};

export const writeAndReturnKindBits = (
    value: any,
    payload1_ptr: pointer,
    payload2_ptr: pointer,
    is_exception: boolean,
    memory: DataView,
    objectSpace: JSObjectSpace,
): JavaScriptValueKindAndFlags => {
    const exceptionBit = (is_exception ? 1 : 0) << 31;
    if (value === null) {
        return exceptionBit | Kind.Null;
    }

    const writeRef = (kind: Kind) => {
        memory.setUint32(payload1_ptr, objectSpace.retain(value), true);
        return exceptionBit | kind;
    };

    const type = typeof value;
    switch (type) {
        case "boolean": {
            memory.setUint32(payload1_ptr, value ? 1 : 0, true);
            return exceptionBit | Kind.Boolean;
        }
        case "number": {
            memory.setFloat64(payload2_ptr, value, true);
            return exceptionBit | Kind.Number;
        }
        case "string": {
            return writeRef(Kind.String);
        }
        case "undefined": {
            return exceptionBit | Kind.Undefined;
        }
        case "object": {
            return writeRef(Kind.Object);
        }
        case "function": {
            return writeRef(Kind.Function);
        }
        case "symbol": {
            return writeRef(Kind.Symbol);
        }
        case "bigint": {
            return writeRef(Kind.BigInt);
        }
        default:
            assertNever(type, `Type "${type}" is not supported yet`);
    }
    throw new Error("Unreachable");
};

export function decodeObjectRefs(
    ptr: pointer,
    length: number,
    memory: DataView,
): ref[] {
    const result: ref[] = new Array(length);
    for (let i = 0; i < length; i++) {
        result[i] = memory.getUint32(ptr + 4 * i, true);
    }
    return result;
}
