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

// src/closure-heap.ts
var closure_heap_exports = {};
__export(closure_heap_exports, {
  SwiftClosureDeallocator: () => SwiftClosureDeallocator
});
module.exports = __toCommonJS(closure_heap_exports);
var SwiftClosureDeallocator = class {
  constructor(exports) {
    if (typeof FinalizationRegistry === "undefined") {
      throw new Error("The Swift part of JavaScriptKit was configured to require the availability of JavaScript WeakRefs. Please build with `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` to disable features that use WeakRefs.");
    }
    this.functionRegistry = new FinalizationRegistry((id) => {
      exports.swjs_free_host_function(id);
    });
  }
  track(func, func_ref) {
    this.functionRegistry.register(func, func_ref);
  }
};
