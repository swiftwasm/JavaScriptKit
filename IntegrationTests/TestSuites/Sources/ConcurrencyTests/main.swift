import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.install()

try JavaScriptEventLoop.runAsync {
    struct E: Error, Equatable {
        let value: Int
    }

    await try asyncTest("Task.runDetached value") {
        let handle = Task.runDetached { 1 }
        await try expectEqual(handle.get(), 1)
    }

    await try asyncTest("Task.runDetached throws") {
        let handle = Task.runDetached {
            throw E(value: 2)
        }
        let error = await try expectAsyncThrow(await handle.get())
        let e = try expectCast(error, to: E.self)
        try expectEqual(e, E(value: 2))
    }

    await try asyncTest("await resolved Promise") {
        let p = JSPromise<Int, JSError>(resolver: { resolve in
            resolve(.success(1))
        })
        await try expectEqual(p.await(), 1)
    }

    await try asyncTest("await rejected Promise") {
        let p = JSPromise<JSValue, JSValue>(resolver: { resolve in
            resolve(.failure(.number(3)))
        })
        let error = await try expectAsyncThrow(await p.await())
        let jsValue = try expectCast(error, to: JSValue.self)
        try expectEqual(jsValue, 3)
    }
}
