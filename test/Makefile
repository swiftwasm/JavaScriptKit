MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SWIFT_LIB_DIR ?= $(MAKEFILE_DIR)/../src/swift

.PHONY: JavaScriptKitExec
JavaScriptKitExec:
	cd JavaScriptKitExec && make build

dist/JavaScriptKitExec.wasm: JavaScriptKitExec
	mkdir -p dist
	cp ./JavaScriptKitExec/.build/debug/JavaScriptKitExec $@

build: dist/JavaScriptKitExec.wasm
	cd ../src/web && npm run build
test: build
	node index.js
