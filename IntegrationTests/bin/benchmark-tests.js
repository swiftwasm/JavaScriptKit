import { startWasiTask } from "../lib.js";
import { performance } from "perf_hooks";

const SAMPLE_ITERATION = 1000000

global.benchmarkRunner = function (name, body) {
    console.log(`Running '${name}' ...`);
    const startTime = performance.now();
    body(SAMPLE_ITERATION);
    const endTime = performance.now();
    console.log("done " + (endTime - startTime) + " ms");
};

global.noopFunction = function () {}
global.jsNumber = 42
global.jsString = "myString"

class JSBenchmark {
    constructor(title) {
        this.title = title;
    }
    testSuite(name, body) {
        benchmarkRunner(`${this.title}/${name}`, (iteration) => {
            body(iteration);
        });
    }
}

const serialization = new JSBenchmark("Serialization");
serialization.testSuite("Call JavaScript function directly", (n) => {
    for (let idx = 0; idx < n; idx++) {
        global.noopFunction()
    }
});

serialization.testSuite("Assign JavaScript number directly", (n) => {
    const jsNumber = 42;
    const object = global;
    const key = "numberValue"
    for (let idx = 0; idx < n; idx++) {
        object[key] = jsNumber;
    }
});

serialization.testSuite("Call with JavaScript number directly", (n) => {
    const jsNumber = 42;
    for (let idx = 0; idx < n; idx++) {
        global.noopFunction(jsNumber)
    }
});

serialization.testSuite("Write JavaScript string directly", (n) => {
    const jsString = "Hello, world";
    const object = global;
    const key = "stringValue"
    for (let idx = 0; idx < n; idx++) {
        object[key] = jsString;
    }
});

serialization.testSuite("Call with JavaScript string directly", (n) => {
    const jsString = "Hello, world";
    for (let idx = 0; idx < n; idx++) {
        global.noopFunction(jsString)
    }
});

startWasiTask("./dist/BenchmarkTests.wasm").catch((err) => {
    console.log(err);
});
