extension TemplateContext {
    var bin_test_js: String {
        return """
import { NodeRunner } from "../test.js"

const runner = new NodeRunner()
await runner.run()
"""
}
}
