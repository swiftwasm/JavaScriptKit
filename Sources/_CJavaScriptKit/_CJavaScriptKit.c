#include "_CJavaScriptKit.h"
#include <stdlib.h>
#include <stdbool.h>

#if __wasm32__

bool _call_host_function_impl(const JavaScriptHostFuncRef host_func_ref,
                              const RawJSValue *argv, const int argc,
                              const JavaScriptObjectRef callback_func);

__attribute__((export_name("swjs_call_host_function")))
bool swjs_call_host_function(const JavaScriptHostFuncRef host_func_ref,
                             const RawJSValue *argv, const int argc,
                             const JavaScriptObjectRef callback_func) {
    return _call_host_function_impl(host_func_ref, argv, argc, callback_func);
}

void _free_host_function_impl(const JavaScriptHostFuncRef host_func_ref);

__attribute__((export_name("swjs_free_host_function")))
void swjs_free_host_function(const JavaScriptHostFuncRef host_func_ref) {
    _free_host_function_impl(host_func_ref);
}

__attribute__((export_name("swjs_prepare_host_function_call")))
void *swjs_prepare_host_function_call(const int argc) {
    return malloc(argc * sizeof(RawJSValue));
}

__attribute__((export_name("swjs_cleanup_host_function_call")))
void swjs_cleanup_host_function_call(void *argv_buffer) {
    free(argv_buffer);
}

/// The compatibility runtime library version.
/// Notes: If you change any interface of runtime library, please increment
/// this and `SwiftRuntime.version` in `./Runtime/src/index.ts`.
__attribute__((export_name("swjs_library_version")))
int swjs_library_version(void) {
    return 708;
}

int _library_features(void);

__attribute__((export_name("swjs_library_features")))
int swjs_library_features(void) {
    return _library_features();
}

#endif
