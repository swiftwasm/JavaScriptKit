#!/bin/bash
swift build --swift-sdk "${SWIFT_SDK_ID:-wasm32-unknown-wasi}" -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor -Xlinker --export=__main_argc_argv
