// This 'ctor' function is called at startup time of this program.
// It's invoked by '_start' of command-line or '_initialize' of reactor.
// This ctor activate the event loop based global executor automatically
// before running the test cases. For general applications, applications
// have to activate the event loop manually on their responsibility.
// However, XCTest framework doesn't provide a way to run arbitrary code
// before running all of the test suites. So, we have to do it here.
//
// See also: https://github.com/WebAssembly/WASI/blob/main/legacy/application-abi.md#current-unstable-abi

extern void swift_javascriptkit_activate_js_executor_impl(void);

// priority 0~100 is reserved by wasi-libc
// https://github.com/WebAssembly/wasi-libc/blob/30094b6ed05f19cee102115215863d185f2db4f0/libc-bottom-half/sources/environ.c#L20
__attribute__((constructor(/* priority */ 200)))
void swift_javascriptkit_activate_js_executor(void) {
    swift_javascriptkit_activate_js_executor_impl();
}

