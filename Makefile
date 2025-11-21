SWIFT_SDK_ID ?= wasm32-unknown-wasi

.PHONY: bootstrap
bootstrap:
	npm ci

.PHONY: unittest
unittest:
	@echo Running unit tests
	env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk "$(SWIFT_SDK_ID)" \
	    --disable-sandbox \
	    js test --prelude ./Tests/prelude.mjs -Xnode --expose-gc

.PHONY: unittest-with-global
unittest-with-global:
	cp Tests/BridgeJSRuntimeTests/bridge-js.config.exposeToGlobal.json Tests/BridgeJSRuntimeTests/bridge-js.config.local.json
	swift package --allow-writing-to-directory Tests/BridgeJSRuntimeTests \
	    bridge-js --package-path Tests/BridgeJSRuntimeTests
	rm -f Tests/BridgeJSRuntimeTests/bridge-js.config.local.json
	env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk "$(SWIFT_SDK_ID)" \
	    --disable-sandbox \
	    js test --prelude ./Tests/prelude.exposeToGlobal.mjs -Xnode --expose-gc

.PHONY: regenerate_swiftpm_resources
regenerate_swiftpm_resources:
	npm run build
	cp Runtime/lib/index.mjs Plugins/PackageToJS/Templates/runtime.mjs
	cp Runtime/lib/index.d.ts Plugins/PackageToJS/Templates/runtime.d.ts
