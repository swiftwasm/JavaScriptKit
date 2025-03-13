swift package --swift-sdk "${SWIFT_SDK_ID:-wasm32-unknown-wasip1-threads}" -c release \
    plugin --allow-writing-to-package-directory \
    js --use-cdn --output ./Bundle
