#!/bin/bash

JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM=true swift build --package-path /home/katei/ghq/github.com/swiftwasm/JavaScriptKit/Examples/Embedded -c release --triple wasm32-unknown-none-wasm
