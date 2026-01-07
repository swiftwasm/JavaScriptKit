#!/bin/bash
set -euxo pipefail
package_dir="$(cd "$(dirname "$0")" && pwd)"
swift package --package-path "$package_dir" \
  -c release --swift-sdk "$(swiftc -print-target-info | jq -r '.swiftCompilerTag')_wasm-embedded" js
