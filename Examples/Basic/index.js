import { WASI, File, OpenFile, ConsoleStdout, PreopenDirectory } from 'https://esm.run/@bjorn3/browser_wasi_shim@0.3.0';

async function main(configuration = "debug") {
    // Fetch our Wasm File
    const response = await fetch(`./.build/${configuration}/Basic.wasm`);
    // Create a new WASI system instance
    const wasi = new WASI(/* args */["main.wasm"], /* env */[], /* fd */[
        new OpenFile(new File([])), // stdin
        ConsoleStdout.lineBuffered((stdout) => {
            console.log(stdout);
        }),
        ConsoleStdout.lineBuffered((stderr) => {
            console.error(stderr);
        }),
        new PreopenDirectory("/", new Map()),
    ])
    const { SwiftRuntime } = await import(`./.build/${configuration}/JavaScriptKit_JavaScriptKit.resources/Runtime/index.mjs`);
    // Create a new Swift Runtime instance to interact with JS and Swift
    const swift = new SwiftRuntime();
    // Instantiate the WebAssembly file
    const { instance } = await WebAssembly.instantiateStreaming(response, {
        wasi_snapshot_preview1: wasi.wasiImport,
        javascript_kit: swift.wasmImports,
    });
    // Set the WebAssembly instance to the Swift Runtime
    swift.setInstance(instance);
    // Start the WebAssembly WASI reactor instance
    wasi.initialize(instance);
    // Start Swift main function
    swift.main()
};

main();
