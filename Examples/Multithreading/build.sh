#!/bin/bash
set -euxo pipefail
swift package --swift-sdk "${SWIFT_SDK_ID_wasm32_unknown_wasip1_threads:-${SWIFT_SDK_ID:-wasm32-unknown-wasip1-threads}}" -c release \
    plugin --allow-writing-to-package-directory \
    js --use-cdn --output ./Bundle
