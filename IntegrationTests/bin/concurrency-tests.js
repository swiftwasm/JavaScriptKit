const { startWasiTask } = require("../lib");

Error.stackTraceLimit = Infinity;

startWasiTask("./dist/ConcurrencyTests.wasm").catch((err) => {
    console.log(err);
    process.exit(1);
});
