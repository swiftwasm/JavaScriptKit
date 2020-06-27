CONFIGURATION ?= debug

.PHONY: TestSuites/.build/$(CONFIGURATION)/PrimaryTests
TestSuites/.build/$(CONFIGURATION)/PrimaryTests:
	swift build --package-path TestSuites \
	            --product PrimaryTests \
	            --triple wasm32-unknown-wasi \
	            --configuration $(CONFIGURATION)

.PHONY: TestSuites/.build/$(CONFIGURATION)/BenchmarkTests
TestSuites/.build/$(CONFIGURATION)/BenchmarkTests:
	swift build --package-path TestSuites \
	            --product BenchmarkTests \
	            --triple wasm32-unknown-wasi \
	            --configuration $(CONFIGURATION)

dist/PrimaryTests.wasm: TestSuites/.build/$(CONFIGURATION)/PrimaryTests
	mkdir -p dist
	cp $< $@

dist/BenchmarkTests.wasm: TestSuites/.build/$(CONFIGURATION)/BenchmarkTests
	mkdir -p dist
	cp $< $@

node_modules: package-lock.json
	npm install
build: node_modules dist/PrimaryTests.wasm dist/BenchmarkTests.wasm
	cd ../Runtime && npm run build
test: build
	node index.js
