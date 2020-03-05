#!/bin/bash

set -x
INSTALL_PATH=$1

WASI_SDK_DOWNLOAD_URL="https://github.com/swiftwasm/wasi-sdk/releases/download/0.2.0-swiftwasm/dist-ubuntu-latest.tgz.zip"

TMP_DIR=$(mktemp -d)
pushd $TMP_DIR
wget -O dist-wasi-sdk.tgz.zip $WASI_SDK_DOWNLOAD_URL
unzip dist-wasi-sdk.tgz.zip -d .
WASI_SDK_TAR_PATH=$(find . -type f -name "wasi-sdk-*")
WASI_SDK_FULL_NAME=$(basename $WASI_SDK_TAR_PATH -linux.tar.gz)
tar xfz $WASI_SDK_TAR_PATH
popd

mv $TMP_DIR/$WASI_SDK_FULL_NAME $INSTALL_PATH
