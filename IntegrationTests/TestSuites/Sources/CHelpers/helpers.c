int growMemory(int pages) {
    return __builtin_wasm_memory_grow(0, pages);
}

