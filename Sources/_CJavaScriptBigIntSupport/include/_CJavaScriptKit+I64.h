
#ifndef _CJavaScriptBigIntSupport_h
#define _CJavaScriptBigIntSupport_h

#include <_CJavaScriptKit.h>

#if __wasm32__
# define IMPORT_JS_FUNCTION(name, returns, args) \
__attribute__((__import_module__("javascript_kit"), __import_name__(#name))) extern returns name args;
#else
# define IMPORT_JS_FUNCTION(name, returns, args) \
  static inline returns name args { \
    abort(); \
  }
#endif

/// Converts the provided Int64 or UInt64 to a BigInt.
///
/// @param value The value to convert.
/// @param is_signed Whether to treat the value as a signed integer or not.
IMPORT_JS_FUNCTION(swjs_i64_to_bigint, JavaScriptObjectRef, (const long long value, bool is_signed))

/// Converts the provided BigInt to an Int64 or UInt64.
///
/// @param ref The target JavaScript object.
/// @param is_signed Whether to treat the return value as a signed integer or not.
IMPORT_JS_FUNCTION(swjs_bigint_to_i64, long long, (const JavaScriptObjectRef ref, bool is_signed))

#endif /* _CJavaScriptBigIntSupport_h */
