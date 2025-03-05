MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SWIFT_SDK_ID ?= wasm32-unknown-wasi
SWIFT_BUILD_FLAGS := --swift-sdk $(SWIFT_SDK_ID)

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
	    CONFIGURATION=debug   SWIFT_BUILD_FLAGS="$(SWIFT_BUILD_FLAGS)" $(MAKE) test && \
	    CONFIGURATION=debug   SWIFT_BUILD_FLAGS="$(SWIFT_BUILD_FLAGS) -Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS" $(MAKE) test && \
	    CONFIGURATION=release SWIFT_BUILD_FLAGS="$(SWIFT_BUILD_FLAGS)" $(MAKE) test && \
	    CONFIGURATION=release SWIFT_BUILD_FLAGS="$(SWIFT_BUILD_FLAGS) -Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS" $(MAKE) test

TEST_RUNNER := node --experimental-wasi-unstable-preview1 scripts/test-harness.mjs
.PHONY: unittest
unittest:
	@echo Running unit tests
	swift build --build-tests -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor -Xlinker --export-if-defined=main -Xlinker --export-if-defined=__main_argc_argv --static-swift-stdlib -Xswiftc -static-stdlib $(SWIFT_BUILD_FLAGS)
# Swift 6.1 and later uses .xctest for XCTest bundle but earliers used .wasm
# See https://github.com/swiftlang/swift-package-manager/pull/8254
	if [ -f .build/debug/JavaScriptKitPackageTests.xctest ]; then \
		$(TEST_RUNNER) .build/debug/JavaScriptKitPackageTests.xctest; \
	else \
		$(TEST_RUNNER) .build/debug/JavaScriptKitPackageTests.wasm; \
	fi

.PHONY: benchmark_setup
benchmark_setup:
	SWIFT_BUILD_FLAGS="$(SWIFT_BUILD_FLAGS)" CONFIGURATION=release $(MAKE) -C IntegrationTests benchmark_setup

.PHONY: run_benchmark
run_benchmark:
	SWIFT_BUILD_FLAGS="$(SWIFT_BUILD_FLAGS)" CONFIGURATION=release $(MAKE) -s -C IntegrationTests run_benchmark

.PHONY: perf-tester
perf-tester:
	cd ci/perf-tester && npm ci

.PHONY: regenerate_swiftpm_resources
regenerate_swiftpm_resources:
	npm run build
	cp Runtime/lib/index.js Runtime/lib/index.mjs Sources/JavaScriptKit/Runtime
