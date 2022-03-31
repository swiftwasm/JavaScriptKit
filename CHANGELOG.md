# 0.13.0 (31 March 2022)

This a small improvement release that improves handling of JavaScript exceptions and compatibility with Xcode.

Thanks to [@kateinoigakukun](https://github.com/kateinoigakukun), [@pedrovgs](https://github.com/pedrovgs), and
[@valeriyvan](https://github.com/valeriyvan) for contributions!

**Closed issues:**

- UserAgent support? ([#169](https://github.com/swiftwasm/JavaScriptKit/issues/169))
- Compile error on macOS 12.2.1 ([#167](https://github.com/swiftwasm/JavaScriptKit/issues/167))

**Merged pull requests:**

- Improve error messages when JS code throws exceptions ([#173](https://github.com/swiftwasm/JavaScriptKit/pull/173)) via [@pedrovgs](https://github.com/pedrovgs)
- Update npm dependencies ([#175](https://github.com/swiftwasm/JavaScriptKit/pull/175)) via [@MaxDesiatov](https://github.com/MaxDesiatov)
- Bump minimist from 1.2.5 to 1.2.6 in /Example ([#172](https://github.com/swiftwasm/JavaScriptKit/pull/172)) via [@dependabot[bot]](https://github.com/dependabot[bot])
- Use availability guarded APIs under @available for Xcode development ([#171](https://github.com/swiftwasm/JavaScriptKit/pull/171)) via [@kateinoigakukun](https://github.com/kateinoigakukun)
- Fix warning in snippet ([#166](https://github.com/swiftwasm/JavaScriptKit/pull/166)) via [@valeriyvan](https://github.com/valeriyvan)
- Bump follow-redirects from 1.14.5 to 1.14.8 in /Example ([#165](https://github.com/swiftwasm/JavaScriptKit/pull/165)) via [@dependabot[bot]](https://github.com/dependabot[bot])


# 0.12.0 (08 February 2022)

This release introduces a [major refactor](https://github.com/swiftwasm/JavaScriptKit/pull/150) of the JavaScript runtime by [@j-f1] and several performance enhancements. 

**Merged pull requests:**

- Add Hashable conformance to JSObject ([#162](https://github.com/swiftwasm/JavaScriptKit/pull/162)) via [@yonihemi]
- Add test for detached ArrayBuffer ([#154](https://github.com/swiftwasm/JavaScriptKit/pull/154)) via [@yonihemi]
- Fix detached ArrayBuffer errors ([#153](https://github.com/swiftwasm/JavaScriptKit/pull/153)) via [@yonihemi]
- Split runtime into multiple files ([#150](https://github.com/swiftwasm/JavaScriptKit/pull/150)) via [@j-f1]
- Add a way for Swift code to access raw contents of a Typed Array ([#151](https://github.com/swiftwasm/JavaScriptKit/pull/151)) via [@yonihemi]
- Prevent installGlobalExecutor() from running more than once ([#152](https://github.com/swiftwasm/JavaScriptKit/pull/152)) via [@yonihemi]
- Return from runtime functions instead of taking a pointer where possible ([#147](https://github.com/swiftwasm/JavaScriptKit/pull/147)) via [@j-f1]
- Use TypedArray.set to copy a bunch of bytes ([#146](https://github.com/swiftwasm/JavaScriptKit/pull/146)) via [@kateinoigakukun]

# 0.11.1 (22 November 2021)

This is a bugfix release that removes a requirement for macOS Monterey in `Package.swift` for this
package. `README.md` was updated to explicitly specify that if you're building an app or a library
that depends on JavaScriptKit for macOS (i.e. cross-platform code that supports both WebAssembly
and macOS), you need either
* macOS Monterey that has the new Swift concurrency runtime available, or
* any version of macOS that supports Swift concurrency back-deployment with Xcode 13.2 or later, or
* add `.unsafeFlags(["-Xfrontend", "-disable-availability-checking"])` in `Package.swift` manifest.

**Merged pull requests:**

- Remove macOS Monterey requirement from `Package.swift` ([#144](https://github.com/swiftwasm/JavaScriptKit/pull/144)) via [@MaxDesiatov]

# 0.11.0 (22 November 2021)

This release adds support for `async`/`await` and SwiftWasm 5.5. Use the new `value` async property
on a `JSPromise` instance to `await` for its result. You'll have to add a dependency on the new
`JavaScriptEventLoop` target in your `Package.swift`, `import JavaScriptEventLoop`, and call 
`JavaScriptEventLoop.installGlobalExecutor()` in your code before you start using `await` and `Task`
APIs.

Additionally, manual memory management API of `JSClosure` has been removed to improve usability.
This significantly bumps minimum browser version requirements for users of apps depending on
JavaScriptKit. Previous manual memory management mode is still available though with a special
compiler flags, see [`README.md`](./README.md) for more details.

This new release of JavaScriptKit may work with SwiftWasm 5.4 and 5.3, but is no longer tested with
those versions due to compatibility issues introduced on macOS by latest versions of Xcode.

Many thanks to [@j-f1], [@kateinoigakukun], 
and [@PatrickPijnappel] for their contributions to this release!

**Closed issues:**

- Enchancement: Add a link to the docs  ([#136](https://github.com/swiftwasm/JavaScriptKit/issues/136))
- Use `FinalizationRegistry` to auto-deinit `JSClosure` ([#131](https://github.com/swiftwasm/JavaScriptKit/issues/131))
- `make test` crashes due to `JSClosure` memory issues ([#129](https://github.com/swiftwasm/JavaScriptKit/issues/129))
- Avoid manual memory management with `JSClosure` ([#106](https://github.com/swiftwasm/JavaScriptKit/issues/106))

**Merged pull requests:**

- Fix recursion in `JSTypedArray` initializer ([#142](https://github.com/swiftwasm/JavaScriptKit/pull/142)) via [@PatrickPijnappel]
- Experimental global executor cooperating with JS event loop ([#141](https://github.com/swiftwasm/JavaScriptKit/pull/141)) via [@kateinoigakukun]
- Update NPM dependencies of `Example` project ([#140](https://github.com/swiftwasm/JavaScriptKit/pull/140)) via [@MaxDesiatov]
- Refactor `JSClosure` to leverage `FinalizationRegistry` ([#128](https://github.com/swiftwasm/JavaScriptKit/pull/128)) via [@j-f1]
- Test with the latest 5.5 snapshot ([#138](https://github.com/swiftwasm/JavaScriptKit/pull/138)) via [@MaxDesiatov]
- Test with multiple toolchain versions ([#135](https://github.com/swiftwasm/JavaScriptKit/pull/135)) via [@kateinoigakukun]
- Gardening tests ([#133](https://github.com/swiftwasm/JavaScriptKit/pull/133)) via [@kateinoigakukun]

# 0.10.1 (29 April 2021)

This is a minor patch release that includes updates to our dependencies and minor documentation
tweaks.

**Closed issues:**

- Do you accept contributions for wrappers over JavaScript objects? ([#124](https://github.com/swiftwasm/JavaScriptKit/issues/124))
- Can't read from a file using `JSPromise` ([#121](https://github.com/swiftwasm/JavaScriptKit/issues/121))
- TypeError when trying to implement a `JSBridgedClass` for `WebSocket.send` ([#120](https://github.com/swiftwasm/JavaScriptKit/issues/120))

**Merged pull requests:**

- Update JS dependencies in package-lock.json ([#126](https://github.com/swiftwasm/JavaScriptKit/pull/126))  via [@MaxDesiatov]
- Fix typo in method documentation ([#125](https://github.com/swiftwasm/JavaScriptKit/pull/125)) via [@revolter]
- Update exported func name to match exported name ([#123](https://github.com/swiftwasm/JavaScriptKit/pull/123)) via [@kateinoigakukun]
- Fix incorrect link in `JSDate` documentation ([#122](https://github.com/swiftwasm/JavaScriptKit/pull/122)) via [@revolter]

# 0.10.0 (21 January 2021)

This release contains multiple breaking changes in preparation for enabling `async`/`await`, when
this feature is available in a stable SwiftWasm release. Namely:

* `JSClosure.init(_ body: @escaping ([JSValue]) -> ())` overload is deprecated to simplify type
checking. Its presence requires explicit type signatures at the place of use. It will be removed
in a future version of JavaScriptKit.
* `JSClosure` is no longer a subclass of `JSFunction`. These classes are not related enough to keep
them in the same class hierarchy.
As a result, you can no longer call `JSClosure` objects directly from Swift.
* Introduced `JSOneshotClosure` for closures that are going to be called only once. You don't need
to manage references to these closures manually, as opposed to `JSClosure`.
However, they can only be called a single time from the JS side. Subsequent invocation attempts will raise a fatal error on the Swift side.
* Removed generic parameters on `JSPromise`, now both success and failure values are always assumed
to be of `JSValue` type. This also significantly simplifies type checking and allows callers to
fully control type casting if needed.

**Closed issues:**

- DOMKit? ([#21](https://github.com/swiftwasm/JavaScriptKit/issues/21))

**Merged pull requests:**

- Simplify `JSPromise` API ([#115](https://github.com/swiftwasm/JavaScriptKit/pull/115)) via [@kateinoigakukun]
- Create `FUNDING.yml` ([#117](https://github.com/swiftwasm/JavaScriptKit/pull/117)) via [@MaxDesiatov]
- Major API change on `JSClosure` ([#113](https://github.com/swiftwasm/JavaScriptKit/pull/113)) via [@kateinoigakukun]
- Update `package.json` to lockfileVersion 2 ([#114](https://github.com/swiftwasm/JavaScriptKit/pull/114)) via [@kateinoigakukun]
- Bump `ini` from 1.3.5 to 1.3.8 in `/Example` ([#111](https://github.com/swiftwasm/JavaScriptKit/pull/111)) via [@dependabot]
- Update doc comment in `JSTypedArray.swift` ([#110](https://github.com/swiftwasm/JavaScriptKit/pull/110)) via [@MaxDesiatov]

# 0.9.0 (27 November 2020)

This release introduces support for catching `JSError` instances in Swift from throwing JavaScript
functions. This is possible thanks to the new `JSThrowingFunction` and `JSThrowingObject` classes.
The former can only be called with `try`, while the latter will expose all of its member functions
as throwing. Use the new `throws` property on `JSFunction` to convert it to `JSThrowingFunction`,
and the new `throwing` property on `JSObject` to convert it to `JSThrowingObject`.

**Closed issues:**

- Support JS errors ([#37](https://github.com/swiftwasm/JavaScriptKit/issues/37))

**Merged pull requests:**

- Update toolchain version swift-wasm-5.3.0-RELEASE ([#108](https://github.com/swiftwasm/JavaScriptKit/pull/108)) via [@kateinoigakukun]
- Update ci trigger condition ([#104](https://github.com/swiftwasm/JavaScriptKit/pull/104)) via [@kateinoigakukun]
- Fix branch and triple in `compatibility.yml` ([#105](https://github.com/swiftwasm/JavaScriptKit/pull/105)) via [@MaxDesiatov]
- Check source code compatibility ([#103](https://github.com/swiftwasm/JavaScriptKit/pull/103)) via [@kateinoigakukun]
- JS Exception Support ([#102](https://github.com/swiftwasm/JavaScriptKit/pull/102)) via [@kateinoigakukun]
- Mention `carton` Docker image and refine wording in `README.md` ([#101](https://github.com/swiftwasm/JavaScriptKit/pull/101)) via [@MaxDesiatov]

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

- Update example code in `README.md` ([#100](https://github.com/swiftwasm/JavaScriptKit/pull/100)) via [@MaxDesiatov]
- Update toolchain version, script, and `README.md` ([#96](https://github.com/swiftwasm/JavaScriptKit/pull/96)) via [@MaxDesiatov]
- [Proposal] Add unsafe convenience methods for JSValue ([#98](https://github.com/swiftwasm/JavaScriptKit/pull/98)) via [@kateinoigakukun]
- Remove all unsafe linker flags from Package.swift ([#91](https://github.com/swiftwasm/JavaScriptKit/pull/91)) via [@kateinoigakukun]
- Sync package.json and package-lock.json  ([#90](https://github.com/swiftwasm/JavaScriptKit/pull/90)) via [@kateinoigakukun]
- Rename JSValueConvertible/Constructible/Codable ([#88](https://github.com/swiftwasm/JavaScriptKit/pull/88)) via [@j-f1]
- Bump @actions/core from 1.2.2 to 1.2.6 in /ci/perf-tester ([#89](https://github.com/swiftwasm/JavaScriptKit/pull/89)) via [@dependabot]
- Make `JSError` conform to `JSBridgedClass` ([#86](https://github.com/swiftwasm/JavaScriptKit/pull/86)) via [@MaxDesiatov]

# 0.7.2 (28 September 2020)

This is a bugfix release that resolves an issue with the JavaScript runtime being unavailable when installed via NPM.

# 0.7.1 (27 September 2020)

This is a bugfix release that resolves an issue with the JavaScript runtime being unavailable when installed via NPM.

**Closed issues:**

- 0.7.0 unavailable on NPM ([#79](https://github.com/swiftwasm/JavaScriptKit/issues/79))
- Automatic performance testing ([#67](https://github.com/swiftwasm/JavaScriptKit/issues/67))

**Merged pull requests:**

- Fix runtime files location in `package.json` ([#81](https://github.com/swiftwasm/JavaScriptKit/pull/81)) via [@MaxDesiatov]
- Run 4 perf tests instead of 2 ([#80](https://github.com/swiftwasm/JavaScriptKit/pull/80)) via [@j-f1]
- Specify correct SwiftWasm snapshot in `README.md` ([#78](https://github.com/swiftwasm/JavaScriptKit/pull/78)) via [@MaxDesiatov]

# 0.7.0 (25 September 2020)

This release adds multiple new types bridged from JavaScript, namely `JSError`, `JSDate`, `JSTimer` (which corresponds to `setTimeout`/`setInterval` calls and manages closure lifetime for you), `JSString` and `JSPromise`. We now also have [documentation published automatically](https://swiftwasm.github.io/JavaScriptKit/) for the main branch.

**Closed issues:**

- `TypedArray` improvement? ([#52](https://github.com/swiftwasm/JavaScriptKit/issues/52))

**Merged pull requests:**

- Add a generic `JSPromise` implementation ([#62](https://github.com/swiftwasm/JavaScriptKit/pull/62)) via [@MaxDesiatov]
- Remove payload2 from value bridging interface ([#64](https://github.com/swiftwasm/JavaScriptKit/pull/64)) via [@kateinoigakukun]
- Update Node.js dependencies ([#65](https://github.com/swiftwasm/JavaScriptKit/pull/65)) via [@MaxDesiatov]
- Implement `JSString` to reduce bridging overhead ([#63](https://github.com/swiftwasm/JavaScriptKit/pull/63)) via [@kateinoigakukun]
- Add `JSBridgedType` and `JSBridgedClass` ([#26](https://github.com/swiftwasm/JavaScriptKit/pull/26)) via [@j-f1]
- Make `JSValue` conform to `ExpressibleByNilLiteral` ([#59](https://github.com/swiftwasm/JavaScriptKit/pull/59)) via [@j-f1]
- Remove `JavaScriptTypedArrayKind` ([#58](https://github.com/swiftwasm/JavaScriptKit/pull/58)) via [@j-f1]
- Add doc comments for public APIs (Part 2) ([#57](https://github.com/swiftwasm/JavaScriptKit/pull/57)) via [@kateinoigakukun]
- Add doc comments for public APIs (Part 1) ([#55](https://github.com/swiftwasm/JavaScriptKit/pull/55)) via [@kateinoigakukun]
- Cleanup invalid test target ([#53](https://github.com/swiftwasm/JavaScriptKit/pull/53)) via [@kateinoigakukun]
- Remove deprecated Ref suffix ([#51](https://github.com/swiftwasm/JavaScriptKit/pull/51)) via [@j-f1]
- Rename `ref` to `jsObject` on JSDate for consistency with JSError ([#50](https://github.com/swiftwasm/JavaScriptKit/pull/50)) via [@MaxDesiatov]
- Generate and publish documentation with `swift-doc` ([#49](https://github.com/swiftwasm/JavaScriptKit/pull/49)) via [@MaxDesiatov]
- Add `JSTimer` implementation with tests ([#46](https://github.com/swiftwasm/JavaScriptKit/pull/46)) via [@MaxDesiatov]
- Add `JSError.stack`, add `Error` conformance ([#48](https://github.com/swiftwasm/JavaScriptKit/pull/48)) via [@MaxDesiatov]
- Add `JSDate` implementation with tests ([#45](https://github.com/swiftwasm/JavaScriptKit/pull/45)) via [@MaxDesiatov]
- Add `JSError` with tests, add JSObject.description ([#47](https://github.com/swiftwasm/JavaScriptKit/pull/47)) via [@MaxDesiatov]

# 0.6.0 (11 September 2020)

This release adds `JSTypedArray` generic type, renames `JSObjectRef` to `JSObject`, and makes `JSClosure` memory management more explicit.

**Closed issues:**

- Support for JS Arrays “holes”, including the test suite ([#39](https://github.com/swiftwasm/JavaScriptKit/issues/39))
- BigInt Support ([#29](https://github.com/swiftwasm/JavaScriptKit/issues/29))
- Separate namespaces for methods and properties? ([#27](https://github.com/swiftwasm/JavaScriptKit/issues/27))

**Merged pull requests:**

- Add a helper method to copy an array of numbers to a JS TypedArray ([#31](https://github.com/swiftwasm/JavaScriptKit/pull/31)) via [@j-f1]
- Resolve small issues ([#44](https://github.com/swiftwasm/JavaScriptKit/pull/44)) via [@kateinoigakukun]
- Bump bl from 3.0.0 to 3.0.1 in /IntegrationTests ([#42](https://github.com/swiftwasm/JavaScriptKit/pull/42)) via [@dependabot]
- Bump bl from 3.0.0 to 3.0.1 in /Example ([#43](https://github.com/swiftwasm/JavaScriptKit/pull/43)) via [@dependabot]
- Support Holes in Array ([#41](https://github.com/swiftwasm/JavaScriptKit/pull/41)) via [@kateinoigakukun]
- Refine public API ([#40](https://github.com/swiftwasm/JavaScriptKit/pull/40)) via [@kateinoigakukun]
- Fix invalid array termination for null and undefined ([#38](https://github.com/swiftwasm/JavaScriptKit/pull/38)) via [@kateinoigakukun]
- Add a test helper function ([#36](https://github.com/swiftwasm/JavaScriptKit/pull/36)) via [@j-f1]
- Enable Xcode 12 with fresh SwiftWasm 5.3 snapshot ([#35](https://github.com/swiftwasm/JavaScriptKit/pull/35)) via [@MaxDesiatov]
- Add void-returning overload to `JSClosure.init` ([#34](https://github.com/swiftwasm/JavaScriptKit/pull/34)) via [@MaxDesiatov]
- Change `JSClosure.release` to `deinit` ([#33](https://github.com/swiftwasm/JavaScriptKit/pull/33)) via [@MaxDesiatov]
- Clean up the `JSObjectRef` API ([#28](https://github.com/swiftwasm/JavaScriptKit/pull/28)) via [@j-f1]
- Remove unused `Tests` directory ([#32](https://github.com/swiftwasm/JavaScriptKit/pull/32)) via [@MaxDesiatov]

[@MaxDesiatov]: https://github.com/MaxDesiatov
[@j-f1]: https://github.com/j-f1
[@kateinoigakukun]: https://github.com/kateinoigakukun
[@yonihemi]: https://github.com/yonihemi
[@PatrickPijnappel]: https://github.com/PatrickPijnappel
[@revolter]: https://github.com/revolter
[@dependabot]: https://github.com/dependabot
