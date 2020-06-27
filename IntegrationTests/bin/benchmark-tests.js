const { startWasiTask } = require("../lib")
const { performance } = require("perf_hooks");

global.benchmarkRunner = function(name, body) {
  console.log(`Running '${name}' ...`)
  const startTime = performance.now();
  body(5000)
  const endTime = performance.now();
  console.log("done " + (endTime - startTime) + " ms");
}

class JSBenchmark {
    constructor(title) { this.title = title }
    testSuite(name, body) {
        benchmarkRunner(`${this.title}/${name}`, (iteration) => {
            for (let idx = 0; idx < iteration; idx++) {
                body()
            }
        })
    }
}

const serialization = new JSBenchmark("Serialization")
serialization.testSuite("Write JavaScript number directly", () => {
    const jsNumber = 42
    const object = global
    for (let idx = 0; idx < 100; idx++) {
        object["numberValue" + idx] = jsNumber
    }
})

serialization.testSuite("Write JavaScript string directly", () => {
    const jsString = "Hello, world"
    const object = global
    for (let idx = 0; idx < 100; idx++) {
        object["stringValue" + idx] = jsString
    }
})

startWasiTask("./dist/BenchmarkTests.wasm").catch(err => {
  console.log(err)
});