#!/bin/bash
set -euxo pipefail
package_dir="$(cd "$(dirname "$0")" && pwd)"
swift package ${SWIFT_PACKAGE_FLAGS:-} --build-system native --package-path "$package_dir" \
  --swift-sdk "${SWIFT_SDK_ID_wasm32_unknown_wasip1:-${SWIFT_SDK_ID:-wasm32-unknown-wasip1}}-embedded" js -c release
