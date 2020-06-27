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

.PHONY: build_rt
build_rt: node_modules
	cd ../Runtime && npm run build

.PHONY: benchmark
benchmark: build_rt dist/BenchmarkTests.wasm
	node bin/benchmark-tests.js

.PHONY: test
test: build_rt dist/PrimaryTests.wasm
	node bin/primary-tests.js
