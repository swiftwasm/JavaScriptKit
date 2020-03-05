MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SRCROOT := $(MAKEFILE_DIR)/../../
SCRIPT_DIR := $(SRCROOT)/script
WASI_SDK_DIR ?= $(SRCROOT)/.wasi-sdk
WASI_SYSROOT ?= $(WASI_SDK_DIR)/share/wasi-sysroot

build:
	$(SCRIPT_DIR)/build-package.sh $(WASI_SYSROOT)