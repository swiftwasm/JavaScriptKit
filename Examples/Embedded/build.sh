#!/bin/bash
set -euxo pipefail
package_dir="$(cd "$(dirname "$0")" && pwd)"
  swift package --package-path "$package_dir" \
  -c release --triple wasm32-unknown-none-wasm js
