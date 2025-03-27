MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SWIFT_SDK_ID ?= wasm32-unknown-wasi
SWIFT_BUILD_FLAGS := --swift-sdk $(SWIFT_SDK_ID)

.PHONY: bootstrap
bootstrap:
	npm ci
	npx playwright install

.PHONY: build
build:
	swift build --triple wasm32-unknown-wasi
	npm run build

.PHONY: unittest
unittest:
	@echo Running unit tests
	swift package --swift-sdk "$(SWIFT_SDK_ID)" \
	    --disable-sandbox \
	    -Xlinker --stack-first \
	    -Xlinker --global-base=524288 \
	    -Xlinker -z \
	    -Xlinker stack-size=524288 \
	    js test --prelude ./Tests/prelude.mjs

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
	cp Runtime/lib/index.js Plugins/PackageToJS/Templates/runtime.js
	cp Runtime/lib/index.mjs Plugins/PackageToJS/Templates/runtime.mjs
	cp Runtime/lib/index.d.ts Plugins/PackageToJS/Templates/runtime.d.ts
