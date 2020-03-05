MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SWIFT_LIB_DIR ?= $(MAKEFILE_DIR)/../src/swift

.PHONY: JavaScriptKitExample
JavaScriptKitExample:
	cd JavaScriptKitExample && make build

dist/JavaScriptKitExample.wasm: JavaScriptKitExample
	mkdir -p dist
	cp ./JavaScriptKitExample/.build/debug/JavaScriptKitExample $@

build: dist/JavaScriptKitExample.wasm
	cd ../src/web && npm run build
	npm run build
