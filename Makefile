MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
WASI_SDK_DIR ?= $(MAKEFILE_DIR)/.wasi-sdk
WASI_SYSROOT ?= $(WASI_SDK_DIR)/share/wasi-sysroot

.PHONY: bootstrap
bootstrap:
	cd Runtime && npm install

.PHONY: build
build: .wasi-sdk/dummy
	./script/build-package.sh $(WASI_SYSROOT)
	cd Runtime && npm run build

.PHONY: test
test: build
	cd IntegrationTests && make test

.wasi-sdk/dummy:
	./script/install-wasi-sdk.sh $(WASI_SDK_DIR)
	touch .wasi-sdk/dummy
