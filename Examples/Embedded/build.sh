#!/bin/bash
package_dir="$(cd "$(dirname "$0")" && pwd)"
JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM=true \
  swift build --package-path "$package_dir" --product EmbeddedApp \
  -c release --triple wasm32-unknown-none-wasm
