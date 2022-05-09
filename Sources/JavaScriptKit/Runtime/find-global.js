export let globalVariable;
if (typeof globalThis !== "undefined") {
  globalVariable = globalThis;
} else if (typeof window !== "undefined") {
  globalVariable = window;
} else if (typeof global !== "undefined") {
  globalVariable = global;
} else if (typeof self !== "undefined") {
  globalVariable = self;
}
