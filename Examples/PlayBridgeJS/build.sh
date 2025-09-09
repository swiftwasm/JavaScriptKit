#!/bin/bash
set -euxo pipefail
env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk "${SWIFT_SDK_ID_wasm32_unknown_wasip1:-${SWIFT_SDK_ID:-wasm32-unknown-wasip1}}" -c "${1:-debug}" \
    plugin --allow-writing-to-package-directory \
    js --use-cdn --output ./Bundle
