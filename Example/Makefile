MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: JavaScriptKitExample
JavaScriptKitExample:
	cd JavaScriptKitExample && \
	    swift build --triple wasm32-unknown-wasi

dist/JavaScriptKitExample.wasm: JavaScriptKitExample
	mkdir -p dist
	cp ./JavaScriptKitExample/.build/debug/JavaScriptKitExample $@

node_modules:
	npm ci
build: node_modules dist/JavaScriptKitExample.wasm
	cd ../Runtime && npm run build
	npm run build
