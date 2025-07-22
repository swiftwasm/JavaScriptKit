#!/bin/bash
set -ex
swift package --swift-sdk "DEVELOPMENT-SNAPSHOT-2025-06-17-a-wasm32-unknown-wasi" -c "${1:-debug}" js --use-cdn
