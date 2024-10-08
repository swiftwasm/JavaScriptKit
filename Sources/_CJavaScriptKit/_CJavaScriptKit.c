#include "_CJavaScriptKit.h"
#if __wasm32__
#if __Embedded
#if __has_include("malloc.h")
#include <malloc.h>
#endif
extern void *malloc(size_t size);
extern void free(void *ptr);
extern void *memset (void *, int, size_t);
extern void *memcpy (void *__restrict, const void *__restrict, size_t);
#else
#include <stdlib.h>
#include <stdbool.h>

#endif

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

#endif

_Thread_local void *swjs_thread_local_closures;
