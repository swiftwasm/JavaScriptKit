// @ts-check

import {
    Direction, Status, Theme, HttpStatus, TSDirection, TSTheme, APIResult, ComplexResult
} from '../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.js';

/** @type {import('../.build/plugins/PackageToJS/outputs/PackageTests/test.d.ts').SetupOptionsFn} */
export async function setupOptions(options, context) {
    Error.stackTraceLimit = 100;
    setupTestGlobals(globalThis);
    return {
        ...options,
        getImports: (importsContext) => {
            return {
                "jsRoundTripVoid": () => {
                    return;
                },
                "jsRoundTripNumber": (v) => {
                    return v;
                },
                "jsRoundTripBool": (v) => {
                    return v;
                },
                "jsRoundTripString": (v) => {
                    return v;
                },
                "jsThrowOrVoid": (shouldThrow) => {
                    if (shouldThrow) {
                        throw new Error("TestError");
                    }
                },
                "jsThrowOrNumber": (shouldThrow) => {
                    if (shouldThrow) {
                        throw new Error("TestError");
                    }
                    return 1;
                },
                "jsThrowOrBool": (shouldThrow) => {
                    if (shouldThrow) {
                        throw new Error("TestError");
                    }
                    return true;
                },
                "jsThrowOrString": (shouldThrow) => {
                    if (shouldThrow) {
                        throw new Error("TestError");
                    }
                    return "Hello, world!";
                },
                JsGreeter: class {
                    /**
                     * @param {string} name
                     * @param {string} prefix
                     */
                    constructor(name, prefix) {
                        this.name = name;
                        this.prefix = prefix;
                    }
                    greet() {
                        return `${this.prefix}, ${this.name}!`;
                    }
                    /** @param {string} name */
                    changeName(name) {
                        this.name = name;
                    }
                },
                runAsyncWorks: async () => {
                    const exports = importsContext.getExports();
                    if (!exports) {
                        throw new Error("No exports!?");
                    }
                    BridgeJSRuntimeTests_runAsyncWorks(exports);
                    return;
                }
            };
        },
        addToCoreImports(importObject, importsContext) {
            const { getInstance, getExports } = importsContext;
            options.addToCoreImports?.(importObject, importsContext);
            importObject["JavaScriptEventLoopTestSupportTests"] = {
                "isMainThread": () => context.isMainThread,
            }
            const bridgeJSRuntimeTests = importObject["BridgeJSRuntimeTests"] || {};
            bridgeJSRuntimeTests["runJsWorks"] = () => {
                const exports = getExports();
                if (!exports) {
                    throw new Error("No exports!?");
                }
                return BridgeJSRuntimeTests_runJsWorks(getInstance(), exports);
            }
            importObject["BridgeJSRuntimeTests"] = bridgeJSRuntimeTests;
        }
    }
}

import assert from "node:assert";

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function BridgeJSRuntimeTests_runJsWorks(instance, exports) {
    exports.roundTripVoid();
    for (const v of [0, 1, -1, 2147483647, -2147483648]) {
        assert.equal(exports.roundTripInt(v), v);
    }
    for (const v of [
        0.0, 1.0, -1.0,
        NaN,
        Infinity,
        /* .pi */ 3.141592502593994,
        /* .greatestFiniteMagnitude */ 3.4028234663852886e+38,
        /* .leastNonzeroMagnitude */ 1.401298464324817e-45
    ]) {
        assert.equal(exports.roundTripFloat(v), v);
    }
    for (const v of [
        0.0, 1.0, -1.0,
        NaN,
        Infinity,
        /* .pi */ 3.141592502593994,
        /* .greatestFiniteMagnitude */ 3.4028234663852886e+38,
        /* .leastNonzeroMagnitude */ 1.401298464324817e-45
    ]) {
        assert.equal(exports.roundTripDouble(v), v);
    }
    for (const v of [true, false]) {
        assert.equal(exports.roundTripBool(v), v);
    }
    for (const v of [
        "Hello, world!",
        "😄",
        "こんにちは",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ]) {
        assert.equal(exports.roundTripString(v), v);
    }

    const g = new exports.Greeter("John");
    assert.equal(g.greet(), "Hello, John!");
    g.changeName("Jane");
    assert.equal(g.greet(), "Hello, Jane!");
    exports.takeGreeter(g, "Jay");
    assert.equal(g.greet(), "Hello, Jay!");

    const g2 = exports.roundTripSwiftHeapObject(g)
    assert.equal(g2.greet(), "Hello, Jay!");
    g2.release();

    g.release();

    // Test class without @JS init constructor
    const calc = exports.createCalculator();
    assert.equal(calc.square(5), 25);
    assert.equal(calc.add(3, 4), 7);
    assert.equal(exports.useCalculator(calc, 3, 10), 19); // 3^2 + 10 = 19

    calc.release();

    const anyObject = {};
    assert.equal(exports.roundTripJSObject(anyObject), anyObject);

    try {
        exports.throwsSwiftError(true);
        assert.fail("Expected error");
    } catch (error) {
        assert.equal(error.message, "TestError", error);
    }

    try {
        exports.throwsSwiftError(false);
    } catch (error) {
        assert.fail("Expected no error");
    }

    assert.equal(Direction.North, 0);
    assert.equal(Direction.South, 1);
    assert.equal(Direction.East, 2);
    assert.equal(Direction.West, 3);
    assert.equal(Status.Loading, 0);
    assert.equal(Status.Success, 1);
    assert.equal(Status.Error, 2);

    assert.equal(exports.setDirection(Direction.North), Direction.North);
    assert.equal(exports.setDirection(Direction.South), Direction.South);
    assert.equal(exports.getDirection(), Direction.North);
    assert.equal(exports.processDirection(Direction.North), Status.Success);
    assert.equal(exports.processDirection(Direction.East), Status.Loading);

    assert.equal(Theme.Light, "light");
    assert.equal(Theme.Dark, "dark");
    assert.equal(Theme.Auto, "auto");
    assert.equal(HttpStatus.Ok, 200);
    assert.equal(HttpStatus.NotFound, 404);
    assert.equal(HttpStatus.ServerError, 500);

    assert.equal(exports.setTheme(Theme.Light), Theme.Light);
    assert.equal(exports.setTheme(Theme.Dark), Theme.Dark);
    assert.equal(exports.getTheme(), Theme.Light);
    assert.equal(exports.setHttpStatus(HttpStatus.Ok), HttpStatus.Ok);
    assert.equal(exports.getHttpStatus(), HttpStatus.Ok);
    assert.equal(exports.processTheme(Theme.Light), HttpStatus.Ok);
    assert.equal(exports.processTheme(Theme.Dark), HttpStatus.NotFound);

    assert.equal(TSDirection.North, 0);
    assert.equal(TSDirection.South, 1);
    assert.equal(TSDirection.East, 2);
    assert.equal(TSDirection.West, 3);
    assert.equal(TSTheme.Light, "light");
    assert.equal(TSTheme.Dark, "dark");
    assert.equal(TSTheme.Auto, "auto");

    assert.equal(exports.setTSDirection(TSDirection.North), TSDirection.North);
    assert.equal(exports.getTSDirection(), TSDirection.North);
    assert.equal(exports.setTSTheme(TSTheme.Light), TSTheme.Light);
    assert.equal(exports.getTSTheme(), TSTheme.Light);

    assert.equal(globalThis.Networking.API.Method.Get, 0);
    assert.equal(globalThis.Networking.API.Method.Post, 1);
    assert.equal(globalThis.Networking.API.Method.Put, 2);
    assert.equal(globalThis.Networking.API.Method.Delete, 3);
    assert.equal(globalThis.Configuration.LogLevel.Debug, "debug");
    assert.equal(globalThis.Configuration.LogLevel.Info, "info");
    assert.equal(globalThis.Configuration.LogLevel.Warning, "warning");
    assert.equal(globalThis.Configuration.LogLevel.Error, "error");
    assert.equal(globalThis.Configuration.Port.Http, 80);
    assert.equal(globalThis.Configuration.Port.Https, 443);
    assert.equal(globalThis.Configuration.Port.Development, 3000);
    assert.equal(globalThis.Networking.APIV2.Internal.SupportedMethod.Get, 0);
    assert.equal(globalThis.Networking.APIV2.Internal.SupportedMethod.Post, 1);

    const converter = new exports.Converter();
    assert.equal(converter.toString(42), "42");
    assert.equal(converter.toString(123), "123");
    converter.release();

    const httpServer = new exports.HTTPServer();
    httpServer.call(globalThis.Networking.API.Method.Get);
    httpServer.call(globalThis.Networking.API.Method.Post);
    httpServer.release();

    const testServer = new exports.TestServer();
    testServer.call(globalThis.Networking.APIV2.Internal.SupportedMethod.Get);
    testServer.call(globalThis.Networking.APIV2.Internal.SupportedMethod.Post);
    testServer.release();

    const globalConverter = new globalThis.Utils.Converter();
    assert.equal(globalConverter.toString(99), "99");
    globalConverter.release();

    const globalHttpServer = new globalThis.Networking.API.HTTPServer();
    globalHttpServer.call(globalThis.Networking.API.Method.Get);
    globalHttpServer.release();

    const globalTestServer = new globalThis.Networking.APIV2.Internal.TestServer();
    globalTestServer.call(globalThis.Networking.APIV2.Internal.SupportedMethod.Post);
    globalTestServer.release();

    const s1 = { tag: APIResult.Tag.Success, param0: "Cześć 🙋‍♂️" };
    const f1 = { tag: APIResult.Tag.Failure, param0: 42 };
    const i1 = { tag: APIResult.Tag.Info };

    assert.deepEqual(exports.echoAPIResult(s1), s1);
    assert.deepEqual(exports.echoAPIResult(f1), f1);
    assert.deepEqual(exports.echoAPIResult(i1), i1);


    assert.deepEqual(exports.makeAPIResultSuccess("Test"), { tag: APIResult.Tag.Success, param0: "Test" });
    assert.deepEqual(exports.makeAPIResultSuccess("ok"), { tag: APIResult.Tag.Success, param0: "ok" });
    assert.deepEqual(exports.makeAPIResultFailure(123), { tag: APIResult.Tag.Failure, param0: 123 });
    assert.deepEqual(exports.makeAPIResultInfo(), { tag: APIResult.Tag.Info });

    const bTrue = { tag: APIResult.Tag.Flag, param0: true };
    const bFalse = { tag: APIResult.Tag.Flag, param0: false };
    assert.deepEqual(exports.makeAPIResultFlag(true), bTrue);
    assert.deepEqual(exports.makeAPIResultFlag(false), bFalse);

    const rVal = 3.25;
    const r1 = { tag: APIResult.Tag.Rate, param0: rVal };
    assert.deepEqual(exports.echoAPIResult(r1), r1);
    assert.deepEqual(exports.makeAPIResultRate(rVal), r1);

    const pVal = 3.141592653589793;
    const p1 = { tag: APIResult.Tag.Precise, param0: pVal };
    assert.deepEqual(exports.echoAPIResult(p1), p1);
    assert.deepEqual(exports.makeAPIResultPrecise(pVal), p1);

    const cs1 = { tag: ComplexResult.Tag.Success, param0: "All good!" };
    const ce1 = { tag: ComplexResult.Tag.Error, param0: "Network error", param1: 503 };
    const cl1 = { tag: ComplexResult.Tag.Location, param0: 37.7749, param1: -122.4194, param2: "San Francisco" };
    const cst1 = { tag: ComplexResult.Tag.Status, param0: true, param1: 200, param2: "OK" };
    const ci1 = { tag: ComplexResult.Tag.Info };

    assert.deepEqual(exports.echoComplexResult(cs1), cs1);
    assert.deepEqual(exports.echoComplexResult(ce1), ce1);
    assert.deepEqual(exports.echoComplexResult(cl1), cl1);
    assert.deepEqual(exports.echoComplexResult(cst1), cst1);
    assert.deepEqual(exports.echoComplexResult(ci1), ci1);

    assert.deepEqual(exports.roundtripComplexResult(cs1), cs1);
    assert.deepEqual(exports.roundtripComplexResult(ce1), ce1);
    assert.deepEqual(exports.roundtripComplexResult(cl1), cl1);
    assert.deepEqual(exports.roundtripComplexResult(cst1), cst1);
    assert.deepEqual(exports.roundtripComplexResult(ci1), ci1);

    assert.deepEqual(exports.makeComplexResultSuccess("Great!"), { tag: ComplexResult.Tag.Success, param0: "Great!" });
    assert.deepEqual(exports.makeComplexResultError("Timeout", 408), { tag: ComplexResult.Tag.Error, param0: "Timeout", param1: 408 });
    assert.deepEqual(exports.makeComplexResultLocation(40.7128, -74.0060, "New York"), { tag: ComplexResult.Tag.Location, param0: 40.7128, param1: -74.0060, param2: "New York" });
    assert.deepEqual(exports.makeComplexResultStatus(false, 500, "Internal Server Error"), { tag: ComplexResult.Tag.Status, param0: false, param1: 500, param2: "Internal Server Error" });
    assert.deepEqual(exports.makeComplexResultInfo(), { tag: ComplexResult.Tag.Info });
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
async function BridgeJSRuntimeTests_runAsyncWorks(exports) {
    await exports.asyncRoundTripVoid();
}

function setupTestGlobals(global) {
    global.globalObject1 = {
        prop_1: {
            nested_prop: 1,
        },
        prop_2: 2,
        prop_3: true,
        prop_4: [3, 4, "str_elm_1", null, undefined, 5],
        prop_5: {
            func1: function () {
                return;
            },
            func2: function () {
                return 1;
            },
            func3: function (n) {
                return n * 2;
            },
            func4: function (a, b, c) {
                return a + b + c;
            },
            func5: function (x) {
                return "Hello, " + x;
            },
            func6: function (c, a, b) {
                if (c) {
                    return a;
                } else {
                    return b;
                }
            },
        },
        prop_6: {
            call_host_1: () => {
                return global.globalObject1.prop_6.host_func_1();
            },
        },
        prop_7: 3.14,
        prop_8: [0, , 2, 3, , , 6],
        eval_closure: function (fn) {
            return fn(arguments[1]);
        },
        observable_obj: {
            set_called: false,
            target: new Proxy(
                {
                    nested: {},
                },
                {
                    set(target, key, value) {
                        global.globalObject1.observable_obj.set_called = true;
                        target[key] = value;
                        return true;
                    },
                }
            ),
        },
    };

    global.Animal = function (name, age, isCat) {
        if (age < 0) {
            throw new Error("Invalid age " + age);
        }
        this.name = name;
        this.age = age;
        this.bark = () => {
            return isCat ? "nyan" : "wan";
        };
        this.isCat = isCat;
        this.getIsCat = function () {
            return this.isCat;
        };
        this.setName = function (name) {
            this.name = name;
        };
    };

    global.callThrowingClosure = (c) => {
        try {
            c();
        } catch (error) {
            return error;
        }
    };

    global.objectDecodingTest = {
        obj: {},
        fn: () => { },
        sym: Symbol("s"),
        bi: BigInt(3)
    };
}