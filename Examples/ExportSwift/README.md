# ExportSwift Example
This example demonstrates how to export Swift functions to JavaScript.

## Building and Running

1. Build the project:
   ```sh
   env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk $SWIFT_SDK_ID js --use-cdn
   ```

2. Serve the files:
   ```sh
   npx serve
   ```

Then open your browser to `http://localhost:3000`.
