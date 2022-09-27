// This module just expose 'JavaScriptEventLoop.installGlobalExecutor' to C ABI
// See _CJavaScriptEventLoopTestSupport.c for why this is needed

import JavaScriptEventLoop

@_cdecl("swift_javascriptkit_activate_js_executor_impl")
func swift_javascriptkit_activate_js_executor_impl() {
    JavaScriptEventLoop.installGlobalExecutor()
}
