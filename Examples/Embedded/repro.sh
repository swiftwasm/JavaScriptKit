#!/bin/bash

JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM=true swift build --package-path /home/katei/ghq/github.com/swiftwasm/JavaScriptKit/Examples/Embedded -c release --triple wasm32-unknown-none-wasm 2>&1 | tee /tmp/repro.log

if grep "swift-frontend: /home/build-user/llvm-project/llvm/lib/IR/Instructions.cpp:" /tmp/repro.log; then
    echo "Reproducible"
    exit 1
else
    echo "Not reproducible"
    exit 0
fi

