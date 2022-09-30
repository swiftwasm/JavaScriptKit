/// If you need to execute Swift async functions that can be resumed by JS
/// event loop in your XCTest suites, please add `JavaScriptEventLoopTestSupport`
/// to your test target dependencies.
///
/// ```diff
///  .testTarget(
///    name: "MyAppTests",
///    dependencies: [
///      "MyApp",
/// +    "JavaScriptEventLoopTestSupport",
///    ]
///  )
/// ```
///
/// Linking this module automatically activates JS event loop based global
/// executor by calling `JavaScriptEventLoop.installGlobalExecutor()`

import JavaScriptEventLoop

// This module just expose 'JavaScriptEventLoop.installGlobalExecutor' to C ABI
// See _CJavaScriptEventLoopTestSupport.c for why this is needed

#if compiler(>=5.5)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@_cdecl("swift_javascriptkit_activate_js_executor_impl")
func swift_javascriptkit_activate_js_executor_impl() {
    JavaScriptEventLoop.installGlobalExecutor()
}

#endif
