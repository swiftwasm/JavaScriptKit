MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: JavaScriptKitExample
JavaScriptKitExample:
	cd JavaScriptKitExample && make build

dist/JavaScriptKitExample.wasm: JavaScriptKitExample
	mkdir -p dist
	cp ./JavaScriptKitExample/.build/debug/JavaScriptKitExample $@

node_modules:
	npm install
build: node_modules dist/JavaScriptKitExample.wasm
	cd ../Runtime && npm run build
	npm run build
