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
@_cdecl("swift_javascriptkit_activate_js_executor_impl")
func swift_javascriptkit_activate_js_executor_impl() {
    JavaScriptEventLoop.installGlobalExecutor()
}
