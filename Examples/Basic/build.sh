#!/bin/bash
set -euxo pipefail
swift package --swift-sdk "${SWIFT_SDK_ID_wasm32_unknown_wasi:-${SWIFT_SDK_ID:-wasm32-unknown-wasi}}" -c "${1:-debug}" js --use-cdn
