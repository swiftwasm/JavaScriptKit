#!/usr/bin/env bash

set -euxo pipefail

swift build --package-path ./Plugins/BridgeJS --product BridgeJSTool

# The Swift half of the stack ABI, generated from the description in BridgeJSABI.swift --
# the same description BridgeJSLink generates the JavaScript half from.
./Plugins/BridgeJS/.build/debug/BridgeJSTool emit-intrinsics --output ./Sources/JavaScriptKit/Generated/BridgeJSIntrinsics+ABI.swift

./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name BridgeJSRuntimeTests --target-dir ./Tests/BridgeJSRuntimeTests --output-dir ./Tests/BridgeJSRuntimeTests/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name BridgeJSGlobalTests --target-dir ./Tests/BridgeJSGlobalTests --output-dir ./Tests/BridgeJSGlobalTests/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name BridgeJSIdentityTests --target-dir ./Tests/BridgeJSIdentityTests --output-dir ./Tests/BridgeJSIdentityTests/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name Benchmarks --target-dir ./Benchmarks/Sources --output-dir ./Benchmarks/Sources/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name PlayBridgeJS --target-dir ./Examples/PlayBridgeJS/Sources/PlayBridgeJS --output-dir ./Examples/PlayBridgeJS/Sources/PlayBridgeJS/Generated
