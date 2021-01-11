#ifndef _CJavaScriptEventLoop_Queue_h
#define _CJavaScriptEventLoop_Queue_h

#include <type_traits>
#include <cassert>
#include <__nullptr> // FIXME
#include <swift/ABI/Task.h>
#include "_CJavaScriptEventLoop.h"

class Queue {
public:
    swift::Job *HeadJob;
    bool isSpinning;
    EventLoopContext Context;

    Queue();
    void insertJob(swift::Job *newJob);
    swift::Job *claimNext();
};


#endif /* _CJavaScriptEventLoop_Queue_h */
