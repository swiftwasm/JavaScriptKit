const { startWasiTask } = require("../lib")
const { performance } = require("perf_hooks");

global.benchmarkRunner = function(name, body) {
  console.log(`Running '${name}' ...`)
  const startTime = performance.now();
  body(5000)
  const endTime = performance.now();
  console.log("done " + (endTime - startTime) + " ms");
}

startWasiTask("./dist/BenchmarkTests.wasm").catch(err => {
  console.log(err)
});