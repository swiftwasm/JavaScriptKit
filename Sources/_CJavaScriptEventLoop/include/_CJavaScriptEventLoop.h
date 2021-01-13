#ifndef _CJavaScriptEventLoop_h
#define _CJavaScriptEventLoop_h


typedef struct {
    void *Queue;
    void *Promise;
} EventLoopContext;

#ifdef __cplusplus
extern "C" {
#endif
void installTaskEnqueueHook(void);
void registerEventLoopHook(void callback(EventLoopContext *context),
                           EventLoopContext *context);
#ifdef __cplusplus
};
#endif

#endif // _CJavaScriptEventLoop_h
