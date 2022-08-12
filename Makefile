MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: bootstrap
bootstrap:
	./scripts/install-toolchain.sh
	npm ci

.PHONY: build
build:
	swift build --triple wasm32-unknown-wasi
	npm run build

.PHONY: test
test:
	cd IntegrationTests && \
	    CONFIGURATION=debug make test && \
	    CONFIGURATION=debug SWIFT_BUILD_FLAGS="-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS" make test && \
	    CONFIGURATION=release make test && \
	    CONFIGURATION=release SWIFT_BUILD_FLAGS="-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS" make test

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
