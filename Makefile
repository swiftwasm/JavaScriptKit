MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
WASI_SDK_DIR ?= $(MAKEFILE_DIR)/.wasi-sdk
WASI_SYSROOT ?= $(WASI_SDK_DIR)/share/wasi-sysroot

build: .wasi-sdk/dummy
	./script/build-package.sh $(WASI_SYSROOT)
.wasi-sdk/dummy:
	./script/install-wasi-sdk.sh $(WASI_SDK_DIR)
	touch .wasi-sdk/dummy
test:
	cd IntegrationTests && make test