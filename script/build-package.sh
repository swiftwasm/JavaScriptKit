#!/bin/bash
WASI_SYSROOT=$1

swift build --triple wasm32-unknown-wasi \
	-Xswiftc -Xclang-linker \
	-Xswiftc --sysroot=$WASI_SYSROOT \
	-Xcc --sysroot=$WASI_SYSROOT \
	-Xlinker --allow-undefined \
	-Xlinker --export=swjs_call_host_function \
	-Xlinker --export=swjs_prepare_host_function_call \
	"$@"
