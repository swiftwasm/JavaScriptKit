const { startWasiTask } = require("../lib");

startWasiTask("./dist/ConcurrencyTests.wasm").catch((err) => {
    console.log(err);
    process.exit(1);
});
