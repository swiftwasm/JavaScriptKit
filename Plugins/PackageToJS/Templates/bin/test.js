import { NodeRunner, BrowserRunner } from "../test.js"

const runners = {
    "node": NodeRunner,
    "browser": BrowserRunner,
}
const runner = new runners[process.env.TEST_RUNNER || "node"]()
await runner.run()
