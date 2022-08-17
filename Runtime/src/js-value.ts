import { Memory } from "./memory.js";
import { assertNever, JavaScriptValueKindAndFlags, pointer } from "./types.js";

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
    memory: Memory
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
            return memory.getObject(payload1);

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
export const decodeArray = (ptr: pointer, length: number, memory: Memory) => {
    // fast path for empty array
    if (length === 0) { return []; }

    let result = [];
    // It's safe to hold DataView here because WebAssembly.Memory.buffer won't
    // change within this function.
    const view = memory.dataView();
    for (let index = 0; index < length; index++) {
        const base = ptr + 16 * index;
        const kind = view.getUint32(base, true);
        const payload1 = view.getUint32(base + 4, true);
        const payload2 = view.getFloat64(base + 8, true);
        result.push(decode(kind, payload1, payload2, memory));
    }
    return result;
};

export const write = (
    value: any,
    kind_ptr: pointer,
    payload1_ptr: pointer,
    payload2_ptr: pointer,
    is_exception: boolean,
    memory: Memory
) => {
    const exceptionBit = (is_exception ? 1 : 0) << 31;
    if (value === null) {
        memory.writeUint32(kind_ptr, exceptionBit | Kind.Null);
        return;
    }

    const writeRef = (kind: Kind) => {
        memory.writeUint32(kind_ptr, exceptionBit | kind);
        memory.writeUint32(payload1_ptr, memory.retain(value));
    };

    const type = typeof value;
    switch (type) {
        case "boolean": {
            memory.writeUint32(kind_ptr, exceptionBit | Kind.Boolean);
            memory.writeUint32(payload1_ptr, value ? 1 : 0);
            break;
        }
        case "number": {
            memory.writeUint32(kind_ptr, exceptionBit | Kind.Number);
            memory.writeFloat64(payload2_ptr, value);
            break;
        }
        case "string": {
            writeRef(Kind.String);
            break;
        }
        case "undefined": {
            memory.writeUint32(kind_ptr, exceptionBit | Kind.Undefined);
            break;
        }
        case "object": {
            writeRef(Kind.Object);
            break;
        }
        case "function": {
            writeRef(Kind.Function);
            break;
        }
        case "symbol": {
            writeRef(Kind.Symbol);
            break;
        }
        case "bigint": {
            writeRef(Kind.BigInt);
            break;
        }
        default:
            assertNever(type, `Type "${type}" is not supported yet`);
    }
};


export const writeV2 = (
    value: any,
    payload1_ptr: pointer,
    payload2_ptr: pointer,
    is_exception: boolean,
    memory: Memory
): JavaScriptValueKindAndFlags => {
    const exceptionBit = (is_exception ? 1 : 0) << 31;
    if (value === null) {
        return exceptionBit | Kind.Null;
    }

    const writeRef = (kind: Kind) => {
        memory.writeUint32(payload1_ptr, memory.retain(value));
        return exceptionBit | kind
    };

    const type = typeof value;
    switch (type) {
        case "boolean": {
            memory.writeUint32(payload1_ptr, value ? 1 : 0);
            return exceptionBit | Kind.Boolean;
        }
        case "number": {
            memory.writeFloat64(payload2_ptr, value);
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
