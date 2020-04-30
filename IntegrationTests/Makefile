MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
CONFIGURATION ?= debug

.PHONY: JavaScriptKitExec
JavaScriptKitExec:
	cd JavaScriptKitExec &&  \
	    swift build --triple wasm32-unknown-wasi \
	                --configuration $(CONFIGURATION)

dist/JavaScriptKitExec.wasm: JavaScriptKitExec
	mkdir -p dist
	cp ./JavaScriptKitExec/.build/$(CONFIGURATION)/JavaScriptKitExec $@

node_modules:
	npm install
build: node_modules dist/JavaScriptKitExec.wasm
	cd ../Runtime && npm run build
test: build
	node index.js
