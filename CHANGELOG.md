# Unreleased

**Closed issues:**

- `TypedArray` improvement? ([#52](https://github.com/swiftwasm/JavaScriptKit/issues/52))

**Merged pull requests:**

- Add a generic `JSPromise` implementation ([#62](https://github.com/swiftwasm/JavaScriptKit/pull/62)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Remove payload2 from value bridging interface ([#64](https://github.com/swiftwasm/JavaScriptKit/pull/64)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Update Node.js dependencies ([#65](https://github.com/swiftwasm/JavaScriptKit/pull/65)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Implement `JSString` to reduce bridging overhead ([#63](https://github.com/swiftwasm/JavaScriptKit/pull/63)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Add `JSBridgedType` and `JSBridgedClass` ([#26](https://github.com/swiftwasm/JavaScriptKit/pull/26)) via [@j-f1](https://github.com/j-f1)
- Make `JSValue` conform to `ExpressibleByNilLiteral` ([#59](https://github.com/swiftwasm/JavaScriptKit/pull/59)) via [@j-f1](https://github.com/j-f1)
- Remove `JavaScriptTypedArrayKind` ([#58](https://github.com/swiftwasm/JavaScriptKit/pull/58)) via [@j-f1](https://github.com/j-f1)
- Add doc comments for public APIs (Part 2) ([#57](https://github.com/swiftwasm/JavaScriptKit/pull/57)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Add doc comments for public APIs (Part 1) ([#55](https://github.com/swiftwasm/JavaScriptKit/pull/55)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Cleanup invalid test target ([#53](https://github.com/swiftwasm/JavaScriptKit/pull/53)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Remove deprecated Ref suffix ([#51](https://github.com/swiftwasm/JavaScriptKit/pull/51)) via [@j-f1](https://github.com/j-f1)
- Rename `ref` to `jsObject` on JSDate for consistency with JSError ([#50](https://github.com/swiftwasm/JavaScriptKit/pull/50)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Generate and publish documentation with `swift-doc` ([#49](https://github.com/swiftwasm/JavaScriptKit/pull/49)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Add `JSTimer` implementation with tests ([#46](https://github.com/swiftwasm/JavaScriptKit/pull/46)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Add `JSError.stack`, add `Error` conformance ([#48](https://github.com/swiftwasm/JavaScriptKit/pull/48)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Add `JSDate` implementation with tests ([#45](https://github.com/swiftwasm/JavaScriptKit/pull/45)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Add `JSError` with tests, add JSObject.description ([#47](https://github.com/swiftwasm/JavaScriptKit/pull/47)) via [@MaxDesiatov](https://github.com/MaxDesiatov)

# 0.6.0 (11 September 2020)

This release adds `JSTypedArray` generic type, renames `JSObjectRef` to `JSObject`, and makes `JSClosure` memory management more explicit.

**Closed issues:**

- Support for JS Arrays “holes”, including the test suite ([#39](https://github.com/swiftwasm/JavaScriptKit/issues/39))
- BigInt Support ([#29](https://github.com/swiftwasm/JavaScriptKit/issues/29))
- Separate namespaces for methods and properties? ([#27](https://github.com/swiftwasm/JavaScriptKit/issues/27))

**Merged pull requests:**

- Add a helper method to copy an array of numbers to a JS TypedArray ([#31](https://github.com/swiftwasm/JavaScriptKit/pull/31)) via [@j-f1](https://github.com/j-f1)
- Resolve small issues ([#44](https://github.com/swiftwasm/JavaScriptKit/pull/44)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Bump bl from 3.0.0 to 3.0.1 in /IntegrationTests ([#42](https://github.com/swiftwasm/JavaScriptKit/pull/42)) via [@dependabot[bot]](https://github.com/dependabot[bot])
- Bump bl from 3.0.0 to 3.0.1 in /Example ([#43](https://github.com/swiftwasm/JavaScriptKit/pull/43)) via [@dependabot[bot]](https://github.com/dependabot[bot])
- Support Holes in Array ([#41](https://github.com/swiftwasm/JavaScriptKit/pull/41)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Refine public API ([#40](https://github.com/swiftwasm/JavaScriptKit/pull/40)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Fix invalid array termination for null and undefined ([#38](https://github.com/swiftwasm/JavaScriptKit/pull/38)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Add a test helper function ([#36](https://github.com/swiftwasm/JavaScriptKit/pull/36)) via [@j-f1](https://github.com/j-f1)
- Enable Xcode 12 with fresh SwiftWasm 5.3 snapshot ([#35](https://github.com/swiftwasm/JavaScriptKit/pull/35)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Add void-returning overload to `JSClosure.init` ([#34](https://github.com/swiftwasm/JavaScriptKit/pull/34)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Change `JSClosure.release` to `deinit` ([#33](https://github.com/swiftwasm/JavaScriptKit/pull/33)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Clean up the `JSObjectRef` API ([#28](https://github.com/swiftwasm/JavaScriptKit/pull/28)) via [@j-f1](https://github.com/j-f1)
- Remove unused `Tests` directory ([#32](https://github.com/swiftwasm/JavaScriptKit/pull/32)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
