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

// src/find-global.ts
var find_global_exports = {};
__export(find_global_exports, {
  globalVariable: () => globalVariable
});
module.exports = __toCommonJS(find_global_exports);
var globalVariable;
if (typeof globalThis !== "undefined") {
  globalVariable = globalThis;
} else if (typeof window !== "undefined") {
  globalVariable = window;
} else if (typeof global !== "undefined") {
  globalVariable = global;
} else if (typeof self !== "undefined") {
  globalVariable = self;
}
