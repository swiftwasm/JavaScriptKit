MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: bootstrap
bootstrap:
	cd Runtime && npm install

.PHONY: build
build:
	swift build --triple wasm32-unknown-wasi
	cd Runtime && npm run build

.PHONY: test
test:
	cd IntegrationTests && \
	    CONFIGURATION=debug make test && \
	    CONFIGURATION=release make test

.PHONY: benchmark_setup
benchmark_setup:
	cd IntegrationTests && make benchmark_setup

.PHONY: run_benchmark
run_benchmark:
	cd IntegrationTests && make -s run_benchmark

.PHONY: perf-tester
perf-tester:
	cd perf-tester && npm install && npm run build
