#!/bin/bash
set -euxo pipefail
swift package --swift-sdk "${SWIFT_SDK_ID_wasm32_unknown_wasip1:-${SWIFT_SDK_ID:-wasm32-unknown-wasip1}}" -c "${1:-debug}" js --use-cdn
