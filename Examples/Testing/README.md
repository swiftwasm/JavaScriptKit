# Testing example

This example demonstrates how to write and run tests for Swift code compiled to WebAssembly using JavaScriptKit.

## Running Tests

To run the tests, use the following command:

```console
swift package --disable-sandbox --swift-sdk wasm32-unknown-wasi js test
```

## Code Coverage

To generate and view code coverage reports:

1. Run tests with code coverage enabled:

```console
swift package --disable-sandbox --swift-sdk wasm32-unknown-wasi js test --enable-code-coverage
```

2. Generate HTML coverage report:

```console
llvm-cov show -instr-profile=.build/plugins/PackageToJS/outputs/PackageTests/default.profdata --format=html .build/plugins/PackageToJS/outputs/PackageTests/main.wasm -o .build/coverage/html Sources
```

3. Serve and view the coverage report:

```console
npx serve .build/coverage/html
```
