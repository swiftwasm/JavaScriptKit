#ifndef _CJavaScriptKit_h
#define _CJavaScriptKit_h

#include <stdlib.h>

typedef unsigned int JavaScriptObjectRef;
typedef unsigned int JavaScriptHostFuncRef;

typedef enum {
    JavaScriptValueKind_Invalid   = -1,
    JavaScriptValueKind_Boolean   = 0,
    JavaScriptValueKind_String    = 1,
    JavaScriptValueKind_Number    = 2,
    JavaScriptValueKind_Object    = 3,
    JavaScriptValueKind_Null      = 4,
    JavaScriptValueKind_Undefined = 5,
    JavaScriptValueKind_Function  = 6,
} JavaScriptValueKind;

typedef unsigned JavaScriptPayload;

typedef struct {
    JavaScriptValueKind kind;
    JavaScriptPayload payload1;
    JavaScriptPayload payload2;
} RawJSValue;


extern const unsigned int _JS_Predef_Value_Global;

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_set_prop")
))
extern void _set_prop(
    const JavaScriptObjectRef _this,
    const char *prop, const int length,
    const RawJSValue *rawJSValue
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_get_prop")
))
extern void _get_prop(
    const JavaScriptObjectRef _this,
    const char *prop, const int length,
    RawJSValue *rawJSValue
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_set_subscript")
))
extern void _set_subscript(
    const JavaScriptObjectRef _this,
    const int length,
    const RawJSValue *rawJSValue
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_get_subscript")
))
extern void _get_subscript(
    const JavaScriptObjectRef _this,
    const int length,
    RawJSValue *rawJSValue
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_load_string")
))
extern void _load_string(
    const JavaScriptObjectRef ref,
    unsigned char *buffer
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_call_function")
))
extern void _call_function(
    const JavaScriptObjectRef ref,
    const RawJSValue *argv, const int argc,
    RawJSValue *rawJSValue
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_call_function_with_this")
))
extern void _call_function_with_this(
    const JavaScriptObjectRef _this,
    const JavaScriptObjectRef func_ref,
    const RawJSValue *argv, const int argc,
    RawJSValue *rawJSValue
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_call_new")
))
extern void _call_new(
    const JavaScriptObjectRef ref,
    const RawJSValue *argv, const int argc,
    JavaScriptPayload *result_obj
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_create_function")
))
extern void _create_function(
    const JavaScriptHostFuncRef host_func_id,
    const JavaScriptObjectRef *func_ref_ptr
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_destroy_ref")
))
extern void _destroy_ref(
    const JavaScriptObjectRef ref
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_instance_of")
))
extern void _instance_of(
    const JavaScriptObjectRef _this,
    const char *constructor, const int length,
    RawJSValue *rawJSValue

);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_copy_typed_array_content")
))
extern void _copy_typed_array_content(
    const JavaScriptObjectRef _this,
    const void *elementsPtr, const int length
);

#endif /* _CJavaScriptKit_h */
