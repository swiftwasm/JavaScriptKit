SWIFT_SDK_ID ?= wasm32-unknown-wasi

.PHONY: bootstrap
bootstrap:
	npm ci
	npx playwright install

.PHONY: unittest
unittest:
	@echo Running unit tests
	env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk "$(SWIFT_SDK_ID)" \
	    --disable-sandbox \
	    -Xlinker --stack-first \
	    -Xlinker --global-base=524288 \
	    -Xlinker -z \
	    -Xlinker stack-size=524288 \
	    js test --prelude ./Tests/prelude.mjs

.PHONY: regenerate_swiftpm_resources
regenerate_swiftpm_resources:
	npm run build
	cp Runtime/lib/index.mjs Plugins/PackageToJS/Templates/runtime.mjs
	cp Runtime/lib/index.d.ts Plugins/PackageToJS/Templates/runtime.d.ts
