const { startWasiTask } = require("../lib");

global.fetch = require('node-fetch');
global.sleep = function () {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve('resolved');
        }, 2000);
    });
}

startWasiTask("./dist/ConcurrencyTests.wasm").catch((err) => {
    console.log(err);
    process.exit(1);
});
