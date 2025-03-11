swift build --swift-sdk "${SWIFT_SDK_ID:-wasm32-unknown-wasip1-threads}" -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor -Xlinker --export=__main_argc_argv -c release -Xswiftc -g
