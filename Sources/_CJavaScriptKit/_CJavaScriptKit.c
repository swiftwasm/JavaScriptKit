#include "_CJavaScriptKit.h"
#include <stdlib.h>

void _call_host_function_impl(const JavaScriptHostFuncRef host_func_ref,
                              const RawJSValue *argv, const int argc,
                              const JavaScriptObjectRef callback_func);

__attribute__((export_name("swjs_call_host_function")))
void _call_host_function(const JavaScriptHostFuncRef host_func_ref,
                         const RawJSValue *argv, const int argc,
                         const JavaScriptObjectRef callback_func) {
    _call_host_function_impl(host_func_ref, argv, argc, callback_func);
}

__attribute__((export_name("swjs_prepare_host_function_call")))
void *_prepare_host_function_call(const int argc) {
    return malloc(argc * sizeof(RawJSValue));
}

__attribute__((export_name("swjs_cleanup_host_function_call")))
void _cleanup_host_function_call(void *argv_buffer) {
    free(argv_buffer);
}

/// The compatibility runtime library version.
/// Notes: If you change any interface of runtime library, please increment
/// this and `SwiftRuntime.version` in `./Runtime/src/index.ts`.
__attribute__((export_name("swjs_library_version")))
int _library_version() {
    return 700;
}
