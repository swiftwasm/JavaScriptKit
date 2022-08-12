/// Ask host to grow WebAssembly module's allocated memory
///
/// @param pages Number of memory pages to increase memory by.
int growMemory(int pages);

__attribute__((__import_module__("benchmark_helper"), __import_name__("noop")))
extern void benchmark_helper_noop(void);

__attribute__((__import_module__("benchmark_helper"), __import_name__("noop_with_int")))
extern void benchmark_helper_noop_with_int(int);
