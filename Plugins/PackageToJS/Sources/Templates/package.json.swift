extension TemplateContext {
    var package_json: String {
        return """
        {
            "name": "\(packageName)",
            "version": "0.0.0",
            "type": "module",
            "exports": {
                ".": "./index.js",
                "./wasm": "./\(wasmFilename)"
            },
            "dependencies": {
                "@bjorn3/browser_wasi_shim": "^0.4.1"
            }
        }
        """
    }
}