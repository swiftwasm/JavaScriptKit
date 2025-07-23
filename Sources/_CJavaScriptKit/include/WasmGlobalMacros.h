#ifndef _CJavaScriptKit_WasmGlobalMacros_h
#define _CJavaScriptKit_WasmGlobalMacros_h

// Define an inline getter for a Wasm global
#define WASM_GLOBAL_DEFINE_INLINE_GETTER(name, core_type, c_type) \
    static inline c_type name##_get(void) { \
        c_type val; \
        __asm__( \
            ".globaltype " #name ", " #core_type "\n" \
            "global.get " #name "\n" \
            "local.set %0\n" \
            : "=r"(val)); \
        return val; \
    }

// Define an inline setter for a Wasm global
#define WASM_GLOBAL_DEFINE_INLINE_SETTER(name, core_type, c_type) \
    static inline void name##_set(c_type val) { \
        __asm__( \
            ".globaltype " #name ", " #core_type "\n" \
            "local.get %0\n" \
            "global.set " #name "\n" \
            : : "r"(val)); \
    }

// Define an inline getter and setter for a Wasm global
#define WASM_GLOBAL_DEFINE_INLINE_ACCESSORS(name, core_type, c_type) \
    WASM_GLOBAL_DEFINE_INLINE_GETTER(name, core_type, c_type) \
    WASM_GLOBAL_DEFINE_INLINE_SETTER(name, core_type, c_type)

// Define a Wasm global storage
#define WASM_GLOBAL_DEFINE_STORAGE(name, core_type) \
    __asm__( \
        ".globaltype " #name ", " #core_type "\n" \
        ".global " #name "\n" \
        #name ":\n" \
    );

// Define an export name for a Wasm value
#define WASM_EXPORT_NAME(name, export_name) \
    __asm__( \
        ".export_name " #name ", " #export_name "\n" \
    );

#endif
