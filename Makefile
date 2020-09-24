MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: bootstrap
bootstrap:
	npm install

.PHONY: build
build:
	swift build --triple wasm32-unknown-wasi
	npm run build

.PHONY: test
test:
	cd IntegrationTests && \
	    CONFIGURATION=debug make test && \
	    CONFIGURATION=release make test

