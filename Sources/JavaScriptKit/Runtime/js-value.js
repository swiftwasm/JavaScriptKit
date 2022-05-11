var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// src/js-value.ts
var js_value_exports = {};
__export(js_value_exports, {
  Kind: () => Kind,
  decode: () => decode,
  decodeArray: () => decodeArray,
  write: () => write
});
module.exports = __toCommonJS(js_value_exports);

// src/types.ts
function assertNever(x, message) {
  throw new Error(message);
}

// src/js-value.ts
var Kind = /* @__PURE__ */ ((Kind2) => {
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
var decode = (kind, payload1, payload2, memory) => {
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
var decodeArray = (ptr, length, memory) => {
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
var write = (value, kind_ptr, payload1_ptr, payload2_ptr, is_exception, memory) => {
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
