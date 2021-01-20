# 0.10.0 (21 January 2021)

This release contains multiple breaking changes in preparation for enabling `async`/`await`, when
this feature is available in a stable SwiftWasm release. Namely:

* `JSClosure.init(_ body: @escaping ([JSValue]) -> ())` overload is deprecated to simplify type
checking. Its presence requires explicit type signatures at the place of use. It will be removed
in the future version of JavaScriptKit.
* `JSClosure` is no longer a subclass of `JSFunction`. These classes are not related enough to keep
them in the same class hierarchy.
* Introduced `JSOneshotClosure` for closures that are going to be called only once. You don't need
to manage references to these closures manually, as opposed to `JSClosure`.
* Removed generic parameters on `JSPromise`, now both success and failure values are always assumed
to be of `JSValue` type. This also significantly simplifies type checking and allows callers to
fully control type casting if needed.

**Closed issues:**

- DOMKit? ([#21](https://github.com/swiftwasm/JavaScriptKit/issues/21))

**Merged pull requests:**

- Simplify `JSPromise` API ([#115](https://github.com/swiftwasm/JavaScriptKit/pull/115)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Create `FUNDING.yml` ([#117](https://github.com/swiftwasm/JavaScriptKit/pull/117)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Major API change on `JSClosure` ([#113](https://github.com/swiftwasm/JavaScriptKit/pull/113)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Update `package.json` to lockfileVersion 2 ([#114](https://github.com/swiftwasm/JavaScriptKit/pull/114)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Bump `ini` from 1.3.5 to 1.3.8 in `/Example` ([#111](https://github.com/swiftwasm/JavaScriptKit/pull/111)) via [@dependabot[bot]](https://github.com/dependabot[bot])
- Update doc comment in `JSTypedArray.swift` ([#110](https://github.com/swiftwasm/JavaScriptKit/pull/110)) via [@MaxDesiatov](https://github.com/MaxDesiatov)

# 0.9.0 (27 November 2020)

This release introduces support for catching `JSError` instances in Swift from throwing JavaScript
functions. This is possible thanks to the new `JSThrowingFunction` and `JSThrowingObject` classes.
The former can only be called with `try`, while the latter will expose all of its member functions
as throwing. Use the new `throws` property on `JSFunction` to convert it to `JSThrowingFunction`,
and the new `throwing` property on `JSObject` to convert it to `JSThrowingObject`.

**Closed issues:**

- Support JS errors ([#37](https://github.com/swiftwasm/JavaScriptKit/issues/37))

**Merged pull requests:**

- Update toolchain version swift-wasm-5.3.0-RELEASE ([#108](https://github.com/swiftwasm/JavaScriptKit/pull/108)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Update ci trigger condition ([#104](https://github.com/swiftwasm/JavaScriptKit/pull/104)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Fix branch and triple in `compatibility.yml` ([#105](https://github.com/swiftwasm/JavaScriptKit/pull/105)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Check source code compatibility ([#103](https://github.com/swiftwasm/JavaScriptKit/pull/103)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- JS Exception Support ([#102](https://github.com/swiftwasm/JavaScriptKit/pull/102)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Mention `carton` Docker image and refine wording in `README.md` ([#101](https://github.com/swiftwasm/JavaScriptKit/pull/101)) via [@MaxDesiatov](https://github.com/MaxDesiatov)

# 0.8.0 (21 October 2020)

This release introduces a few enhancements and deprecations. Namely, `JSValueConstructible`
and `JSValueConvertible` were renamed to `ConstructibleFromJSValue` and `ConvertibleToJSValue`
respectively. The old names are deprecated, and you should move away from using the old names in
your code. Additionally, JavaScriptKit now requires the most recent 5.3 and development toolchains,
but thanks to this it no longer uses unsafe flags, which prevented building other libraries
depending on JavaScriptKit on other platforms.

The main user-visible enhancement is that now force casts are no longer required in client code.
That is, we now allow this

```swift
let document = JSObject.global.document
let foundDivs = document.getElementsByTagName("div")
```

in addition to the previously available explicit style with force unwrapping:

```swift
let document = JSObject.global.document.object!
let foundDivs = document.getElementsByTagName!("div").object!
```

Note that the code in the first example is still dynamically typed. The Swift compiler won't warn
you if you misspell names of properties or cast them to a wrong type. This feature is purely
additive, and is added for convenience. You can still use force unwraps in your code interfacing
with JavaScriptKit. If you're interested in a statically-typed DOM API, we recommend having a look
at the [DOMKit](https://github.com/swiftwasm/DOMKit) library, which is currently in development.

Lastly, `JSError` now conforms to the `JSBridgedClass` protocol, which makes it easier to integrate
with idiomatic Swift code.

**Closed issues:**

- Errors building example: undefined symbols ([#95](https://github.com/swiftwasm/JavaScriptKit/issues/95))
- Documentation website is broken ([#93](https://github.com/swiftwasm/JavaScriptKit/issues/93))
- Rename `JSValueConstructible` and `JSValueConvertible` ([#87](https://github.com/swiftwasm/JavaScriptKit/issues/87))
- Build fails with the unsafe flags error ([#6](https://github.com/swiftwasm/JavaScriptKit/issues/6))

**Merged pull requests:**

- Update example code in `README.md` ([#100](https://github.com/swiftwasm/JavaScriptKit/pull/100)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Update toolchain version, script, and `README.md` ([#96](https://github.com/swiftwasm/JavaScriptKit/pull/96)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- [Proposal] Add unsafe convenience methods for JSValue ([#98](https://github.com/swiftwasm/JavaScriptKit/pull/98)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Remove all unsafe linker flags from Package.swift ([#91](https://github.com/swiftwasm/JavaScriptKit/pull/91)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Sync package.json and package-lock.json  ([#90](https://github.com/swiftwasm/JavaScriptKit/pull/90)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Rename JSValueConvertible/Constructible/Codable ([#88](https://github.com/swiftwasm/JavaScriptKit/pull/88)) via [@j-f1](https://github.com/j-f1)
- Bump @actions/core from 1.2.2 to 1.2.6 in /ci/perf-tester ([#89](https://github.com/swiftwasm/JavaScriptKit/pull/89)) via [@dependabot[bot]](https://github.com/dependabot[bot])
- Make `JSError` conform to `JSBridgedClass` ([#86](https://github.com/swiftwasm/JavaScriptKit/pull/86)) via [@MaxDesiatov](https://github.com/MaxDesiatov)

# 0.7.2 (28 September 2020)

This is a bugfix release that resolves an issue with the JavaScript runtime being unavailable when installed via NPM.

# 0.7.1 (27 September 2020)

This is a bugfix release that resolves an issue with the JavaScript runtime being unavailable when installed via NPM.

**Closed issues:**

- 0.7.0 unavailable on NPM ([#79](https://github.com/swiftwasm/JavaScriptKit/issues/79))
- Automatic performance testing ([#67](https://github.com/swiftwasm/JavaScriptKit/issues/67))

**Merged pull requests:**

- Fix runtime files location in `package.json` ([#81](https://github.com/swiftwasm/JavaScriptKit/pull/81)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Run 4 perf tests instead of 2 ([#80](https://github.com/swiftwasm/JavaScriptKit/pull/80)) via [@j-f1](https://github.com/j-f1)
- Specify correct SwiftWasm snapshot in `README.md` ([#78](https://github.com/swiftwasm/JavaScriptKit/pull/78)) via [@MaxDesiatov](https://github.com/MaxDesiatov)

# 0.7.0 (25 September 2020)

This release adds multiple new types bridged from JavaScript, namely `JSError`, `JSDate`, `JSTimer` (which corresponds to `setTimeout`/`setInterval` calls and manages closure lifetime for you), `JSString` and `JSPromise`. We now also have [documentation published automatically](https://swiftwasm.github.io/JavaScriptKit/) for the main branch.

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
