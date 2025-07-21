#!/bin/bash
set -ex
swift package --swift-sdk "${SWIFT_SDK_ID:-wasm32-unknown-wasi}" -c "${1:-debug}" js --use-cdn
