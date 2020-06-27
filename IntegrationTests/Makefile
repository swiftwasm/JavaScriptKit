CONFIGURATION ?= debug

.PHONY: TestSuites/.build/$(CONFIGURATION)/TestSuites
TestSuites/.build/$(CONFIGURATION)/TestSuites:
	swift build --package-path TestSuites \
	            --triple wasm32-unknown-wasi \
	            --configuration $(CONFIGURATION)

dist/TestSuites.wasm: TestSuites/.build/$(CONFIGURATION)/TestSuites
	mkdir -p dist
	cp $< $@

node_modules: package-lock.json
	npm install
build: node_modules dist/TestSuites.wasm
	cd ../Runtime && npm run build
test: build
	node index.js
