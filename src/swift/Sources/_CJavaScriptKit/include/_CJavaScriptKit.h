#ifndef _CJavaScriptKit_h
#define _CJavaScriptKit_h

#include <stdlib.h>

typedef unsigned int JavaScriptValueId;

typedef enum {
    JavaScriptValueKind_Invalid  = -1,
    JavaScriptValueKind_Boolean  = 0,
    JavaScriptValueKind_String   = 1,
    JavaScriptValueKind_Number   = 2,
    JavaScriptValueKind_Object   = 3,
    JavaScriptValueKind_Array    = 4,
    JavaScriptValueKind_Null     = 5,
    JavaScriptValueKind_Function = 6,
} JavaScriptValueKind;

typedef unsigned JavaScriptPayload;


const unsigned int _JS_Predef_Value_Global = 0;

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_set_js_value")
))
extern void _set_js_value(
    const JavaScriptValueId _this,
    const char *prop,
    const int length,
    const JavaScriptValueKind kind,
    const JavaScriptPayload payload1,
    const JavaScriptPayload payload2
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_get_js_value")
))
extern void _get_js_value(
    const JavaScriptValueId _this,
    const char *prop,
    const int length,
    JavaScriptValueKind *kind,
    JavaScriptPayload *payload1,
    JavaScriptPayload *payload2
);

__attribute__((
    __import_module__("javascript_kit"),
    __import_name__("swjs_load_string")
))
extern void _load_string(
    const JavaScriptValueId ref,
    unsigned char *buffer
);

#endif /* _CJavaScriptKit_h */
