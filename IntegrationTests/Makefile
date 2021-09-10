CONFIGURATION ?= debug
SWIFT_BUILD_FLAGS ?=

FORCE:
TestSuites/.build/$(CONFIGURATION)/%.wasm: FORCE
	swift build --package-path TestSuites \
	            --product $(basename $(notdir $@)) \
	            --triple wasm32-unknown-wasi \
	            --configuration $(CONFIGURATION) \
		    $(SWIFT_BUILD_FLAGS)

dist/%.wasm: TestSuites/.build/$(CONFIGURATION)/%.wasm
	mkdir -p dist
	cp $< $@

node_modules: package-lock.json
	npm ci

.PHONY: build_rt
build_rt: node_modules
	cd .. && npm run build

.PHONY: benchmark_setup
benchmark_setup: build_rt dist/BenchmarkTests.wasm

.PHONY: run_benchmark
run_benchmark:
	node bin/benchmark-tests.js

.PHONY: benchmark
benchmark: benchmark_setup run_benchmark

.PHONY: test
test: build_rt dist/PrimaryTests.wasm
	node bin/primary-tests.js
