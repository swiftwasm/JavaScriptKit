#ifndef _CJavaScriptKit_BridgeJSInstrincics_h
#define _CJavaScriptKit_BridgeJSInstrincics_h

#include <stdint.h>
#include "WasmGlobalMacros.h"

#if __wasm__
// Global thread-local pointer storage for temporarily storing JS exceptions
// thrown from imported JavaScript functions.
WASM_GLOBAL_DEFINE_INLINE_ACCESSORS(_swift_js_exception, i32, int32_t)
#endif

#endif
