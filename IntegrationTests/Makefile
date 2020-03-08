MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: JavaScriptKitExec
JavaScriptKitExec:
	cd JavaScriptKitExec &&  \
	    swift build --triple wasm32-unknown-wasi

dist/JavaScriptKitExec.wasm: JavaScriptKitExec
	mkdir -p dist
	cp ./JavaScriptKitExec/.build/debug/JavaScriptKitExec $@

node_modules:
	npm install
build: node_modules dist/JavaScriptKitExec.wasm
	cd ../Runtime && npm run build
test: build
	node index.js
