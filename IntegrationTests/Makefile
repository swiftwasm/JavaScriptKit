CONFIGURATION ?= debug
SWIFT_BUILD_FLAGS ?=
NODEJS_FLAGS ?=

NODEJS = node --experimental-wasi-unstable-preview1 $(NODEJS_FLAGS)

FORCE:
TestSuites/.build/$(CONFIGURATION)/%.wasm: FORCE
	swift build --package-path TestSuites \
	            --product $(basename $(notdir $@)) \
	            --triple wasm32-unknown-wasi \
	            --configuration $(CONFIGURATION) \
	            -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor \
	            -Xlinker --export-if-defined=main -Xlinker --export-if-defined=__main_argc_argv \
		    --static-swift-stdlib -Xswiftc -static-stdlib \
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
	$(NODEJS) bin/benchmark-tests.js

.PHONY: benchmark
benchmark: benchmark_setup run_benchmark

.PHONY: primary_test
primary_test: build_rt dist/PrimaryTests.wasm
	$(NODEJS) bin/primary-tests.js

.PHONY: concurrency_test
concurrency_test: build_rt dist/ConcurrencyTests.wasm
	$(NODEJS) bin/concurrency-tests.js

.PHONY: test
test: concurrency_test primary_test
