MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
WASI_SDK_DIR ?= $(MAKEFILE_DIR)/.wasi-sdk


build: .wasi-sdk/dummy
	swift build --triple wasm32-unknown-wasi \
		-Xswiftc -Xclang-linker \
		-Xswiftc --sysroot=$(WASI_SDK_DIR)/share/wasi-sysroot \
		-Xlinker --allow-undefined
.wasi-sdk/dummy:
	./script/install-wasi-sdk.sh $(WASI_SDK_DIR)
	touch .wasi-sdk/dummy
