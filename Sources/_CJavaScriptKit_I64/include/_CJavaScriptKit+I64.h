
#ifndef _CJavaScriptKit_I64_h
#define _CJavaScriptKit_I64_h

#include <_CJavaScriptKit.h>

/// Converts the provided Int64 or UInt64 to a BigInt.
///
/// @param value The value to convert.
/// @param is_signed Whether to treat the value as a signed integer or not.
__attribute__((__import_module__("javascript_kit"),
               __import_name__("swjs_i64_to_bigint")))
extern JavaScriptObjectRef _i64_to_bigint(const long long value, bool is_signed);

/// Converts the provided BigInt to an Int64 or UInt64.
///
/// @param ref The target JavaScript object.
/// @param is_signed Whether to treat the return value as a signed integer or not.
__attribute__((__import_module__("javascript_kit"),
               __import_name__("swjs_bigint_to_i64")))
extern long long _bigint_to_i64(const JavaScriptObjectRef ref, bool is_signed);

#endif /* _CJavaScriptKit_I64_h */
