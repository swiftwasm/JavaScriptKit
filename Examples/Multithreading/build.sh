swift build --swift-sdk DEVELOPMENT-SNAPSHOT-2024-07-09-a-wasm32-unknown-wasip1-threads -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor -Xlinker --export=__main_argc_argv -c release -Xswiftc -g
