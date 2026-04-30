# MultiModule Example

This example demonstrates using `@JS` types defined in one module (`Core`) from another module (`App`) within the same Swift package.

## Building and Running

1. Build the project:
   ```sh
   swift package --swift-sdk $SWIFT_SDK_ID js --use-cdn
   ```

2. Serve the files:
   ```sh
   npx serve
   ```

Then open your browser to `http://localhost:3000`.
