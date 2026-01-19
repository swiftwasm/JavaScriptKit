#!/usr/bin/env bash

set -euxo pipefail

swift build --package-path ./Plugins/BridgeJS --product BridgeJSTool

./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name BridgeJSRuntimeTests --target-dir ./Tests/BridgeJSRuntimeTests --output-dir ./Tests/BridgeJSRuntimeTests/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name BridgeJSGlobalTests --target-dir ./Tests/BridgeJSGlobalTests --output-dir ./Tests/BridgeJSGlobalTests/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name Benchmarks --target-dir ./Benchmarks/Sources --output-dir ./Benchmarks/Sources/Generated
./Plugins/BridgeJS/.build/debug/BridgeJSTool generate --project ./tsconfig.json --module-name PlayBridgeJS --target-dir ./Examples/PlayBridgeJS/Sources/PlayBridgeJS --output-dir ./Examples/PlayBridgeJS/Sources/PlayBridgeJS/Generated
