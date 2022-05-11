import { assertNever } from "./types.js";
export var Kind = /* @__PURE__ */ ((Kind2) => {
  Kind2[Kind2["Boolean"] = 0] = "Boolean";
  Kind2[Kind2["String"] = 1] = "String";
  Kind2[Kind2["Number"] = 2] = "Number";
  Kind2[Kind2["Object"] = 3] = "Object";
  Kind2[Kind2["Null"] = 4] = "Null";
  Kind2[Kind2["Undefined"] = 5] = "Undefined";
  Kind2[Kind2["Function"] = 6] = "Function";
  Kind2[Kind2["Symbol"] = 7] = "Symbol";
  Kind2[Kind2["BigInt"] = 8] = "BigInt";
  return Kind2;
})(Kind || {});
export const decode = (kind, payload1, payload2, memory) => {
  switch (kind) {
    case 0 /* Boolean */:
      switch (payload1) {
        case 0:
          return false;
        case 1:
          return true;
      }
    case 2 /* Number */:
      return payload2;
    case 1 /* String */:
    case 3 /* Object */:
    case 6 /* Function */:
    case 7 /* Symbol */:
    case 8 /* BigInt */:
      return memory.getObject(payload1);
    case 4 /* Null */:
      return null;
    case 5 /* Undefined */:
      return void 0;
    default:
      assertNever(kind, `JSValue Type kind "${kind}" is not supported`);
  }
};
export const decodeArray = (ptr, length, memory) => {
  let result = [];
  for (let index = 0; index < length; index++) {
    const base = ptr + 16 * index;
    const kind = memory.readUint32(base);
    const payload1 = memory.readUint32(base + 4);
    const payload2 = memory.readFloat64(base + 8);
    result.push(decode(kind, payload1, payload2, memory));
  }
  return result;
};
export const write = (value, kind_ptr, payload1_ptr, payload2_ptr, is_exception, memory) => {
  const exceptionBit = (is_exception ? 1 : 0) << 31;
  if (value === null) {
    memory.writeUint32(kind_ptr, exceptionBit | 4 /* Null */);
    return;
  }
  const writeRef = (kind) => {
    memory.writeUint32(kind_ptr, exceptionBit | kind);
    memory.writeUint32(payload1_ptr, memory.retain(value));
  };
  const type = typeof value;
  switch (type) {
    case "boolean": {
      memory.writeUint32(kind_ptr, exceptionBit | 0 /* Boolean */);
      memory.writeUint32(payload1_ptr, value ? 1 : 0);
      break;
    }
    case "number": {
      memory.writeUint32(kind_ptr, exceptionBit | 2 /* Number */);
      memory.writeFloat64(payload2_ptr, value);
      break;
    }
    case "string": {
      writeRef(1 /* String */);
      break;
    }
    case "undefined": {
      memory.writeUint32(kind_ptr, exceptionBit | 5 /* Undefined */);
      break;
    }
    case "object": {
      writeRef(3 /* Object */);
      break;
    }
    case "function": {
      writeRef(6 /* Function */);
      break;
    }
    case "symbol": {
      writeRef(7 /* Symbol */);
      break;
    }
    case "bigint": {
      writeRef(8 /* BigInt */);
      break;
    }
    default:
      assertNever(type, `Type "${type}" is not supported yet`);
  }
};
