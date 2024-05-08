MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: bootstrap
bootstrap:
	npm ci

.PHONY: build
build:
	swift build --triple wasm32-unknown-wasi
	npm run build

.PHONY: test
test:
	@echo Running integration tests
	cd IntegrationTests && \
	    CONFIGURATION=debug make test && \
	    CONFIGURATION=debug SWIFT_BUILD_FLAGS="-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS" make test && \
	    CONFIGURATION=release make test && \
	    CONFIGURATION=release SWIFT_BUILD_FLAGS="-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS" make test

.PHONY: unittest
unittest:
	@echo Running unit tests
	swift build --build-tests --triple wasm32-unknown-wasi -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor -Xlinker --export-if-defined=main -Xlinker --export-if-defined=__main_argc_argv --static-swift-stdlib -Xswiftc -static-stdlib
	node --experimental-wasi-unstable-preview1 scripts/test-harness.mjs ./.build/wasm32-unknown-wasi/debug/JavaScriptKitPackageTests.wasm

.PHONY: benchmark_setup
benchmark_setup:
	cd IntegrationTests && CONFIGURATION=release make benchmark_setup

.PHONY: run_benchmark
run_benchmark:
	cd IntegrationTests && CONFIGURATION=release make -s run_benchmark

.PHONY: perf-tester
perf-tester:
	cd ci/perf-tester && npm ci

.PHONY: regenerate_swiftpm_resources
regenerate_swiftpm_resources:
	npm run build
	cp Runtime/lib/index.js Runtime/lib/index.mjs Sources/JavaScriptKit/Runtime
