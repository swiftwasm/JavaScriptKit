import { startWasiTask } from "../lib.js";

Error.stackTraceLimit = Infinity;

startWasiTask("./dist/ConcurrencyTests.wasm").catch((err) => {
    console.log(err);
    process.exit(1);
});
