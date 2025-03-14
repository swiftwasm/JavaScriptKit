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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@_cdecl("swift_javascriptkit_activate_js_executor_impl")
func swift_javascriptkit_activate_js_executor_impl() {
    MainActor.assumeIsolated {
        JavaScriptEventLoop.installGlobalExecutor()
        #if canImport(wasi_pthread) && compiler(>=6.1) && _runtime(_multithreaded)
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            WebWorkerTaskExecutor.installGlobalExecutor()
        }
        #endif
    }
}

#endif
