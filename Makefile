SWIFT_SDK_ID ?=

.PHONY: bootstrap
bootstrap:
	npm ci

.PHONY: unittest
unittest:
	@echo Running unit tests
	@test -n "$(SWIFT_SDK_ID)" || { \
		echo "SWIFT_SDK_ID is not set. Run 'swift sdk list' and pass a matching SDK, e.g. 'make unittest SWIFT_SDK_ID=<id>'."; \
		exit 2; \
	}
	env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk "$(SWIFT_SDK_ID)" \
	    --disable-sandbox \
	    js test --prelude ./Tests/prelude.mjs -Xnode --expose-gc

.PHONY: regenerate_swiftpm_resources
regenerate_swiftpm_resources:
	npm run build
	cp Runtime/lib/index.mjs Plugins/PackageToJS/Templates/runtime.mjs
	cp Runtime/lib/index.d.ts Plugins/PackageToJS/Templates/runtime.d.ts
