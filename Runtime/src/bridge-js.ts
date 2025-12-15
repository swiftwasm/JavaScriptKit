/**
 * Create a set of throwing stub functions for the BridgeJS API.
 * If no generate BridgeJS code is used, pass this object as "bjs" in the wasm imports.
 * @returns A set of throwing stub functions for the BridgeJS API.
 */
export function createBridgeJSStubs() {
    const unexpectedBjsCall = () => {
        throw new Error("Unexpected call to BridgeJS function");
    };
    return {
        swift_js_return_string: unexpectedBjsCall,
        swift_js_init_memory: unexpectedBjsCall,
        swift_js_make_js_string: unexpectedBjsCall,
        swift_js_init_memory_with_result: unexpectedBjsCall,
        swift_js_throw: unexpectedBjsCall,
        swift_js_retain: unexpectedBjsCall,
        swift_js_release: unexpectedBjsCall,
        swift_js_push_tag: unexpectedBjsCall,
        swift_js_push_int: unexpectedBjsCall,
        swift_js_push_f32: unexpectedBjsCall,
        swift_js_push_f64: unexpectedBjsCall,
        swift_js_push_string: unexpectedBjsCall,
        swift_js_pop_param_int32: unexpectedBjsCall,
        swift_js_pop_param_f32: unexpectedBjsCall,
        swift_js_pop_param_f64: unexpectedBjsCall,
        swift_js_return_optional_bool: unexpectedBjsCall,
        swift_js_return_optional_int: unexpectedBjsCall,
        swift_js_return_optional_string: unexpectedBjsCall,
        swift_js_return_optional_double: unexpectedBjsCall,
        swift_js_return_optional_float: unexpectedBjsCall,
        swift_js_return_optional_heap_object: unexpectedBjsCall,
        swift_js_return_optional_object: unexpectedBjsCall,
        swift_js_get_optional_int_presence: unexpectedBjsCall,
        swift_js_get_optional_int_value: unexpectedBjsCall,
        swift_js_get_optional_string: unexpectedBjsCall,
        swift_js_get_optional_float_presence: unexpectedBjsCall,
        swift_js_get_optional_float_value: unexpectedBjsCall,
        swift_js_get_optional_double_presence: unexpectedBjsCall,
        swift_js_get_optional_double_value: unexpectedBjsCall,
        swift_js_get_optional_heap_object_pointer: unexpectedBjsCall,
    };
}
