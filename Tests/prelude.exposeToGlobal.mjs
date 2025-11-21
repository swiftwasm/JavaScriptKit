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
    // Repetition tests to satisfy testAll
    const g = new exports.Greeter("John");
    g.release();
    const calc = exports.createCalculator();
    calc.release();

    assert.equal(globalThis.Networking.API.MethodValues.Get, 0);
    assert.equal(globalThis.Networking.API.MethodValues.Post, 1);
    assert.equal(globalThis.Networking.API.MethodValues.Put, 2);
    assert.equal(globalThis.Networking.API.MethodValues.Delete, 3);

    assert.equal(globalThis.Configuration.LogLevelValues.Debug, "debug");
    assert.equal(globalThis.Configuration.LogLevelValues.Info, "info");
    assert.equal(globalThis.Configuration.LogLevelValues.Warning, "warning");
    assert.equal(globalThis.Configuration.LogLevelValues.Error, "error");
    assert.equal(globalThis.Configuration.PortValues.Http, 80);
    assert.equal(globalThis.Configuration.PortValues.Https, 443);
    assert.equal(globalThis.Configuration.PortValues.Development, 3000);

    assert.equal(globalThis.Networking.APIV2.Internal.SupportedMethodValues.Get, 0);
    assert.equal(globalThis.Networking.APIV2.Internal.SupportedMethodValues.Post, 1);

    const globalConverter = new globalThis.Utils.Converter();
    assert.equal(globalConverter.toString(99), "99");
    globalConverter.release();

    const globalHttpServer = new globalThis.Networking.API.HTTPServer();
    globalHttpServer.call(globalThis.Networking.API.MethodValues.Get);
    globalHttpServer.release();

    const globalTestServer = new globalThis.Networking.APIV2.Internal.TestServer();
    globalTestServer.call(globalThis.Networking.APIV2.Internal.SupportedMethodValues.Post);
    globalTestServer.release();

    assert.equal(globalThis.StaticPropertyNamespace.namespaceProperty, "namespace");
    assert.equal(globalThis.StaticPropertyNamespace.namespaceConstant, "constant");

    globalThis.StaticPropertyNamespace.namespaceProperty = "modified namespace";
    assert.equal(globalThis.StaticPropertyNamespace.namespaceProperty, "modified namespace");

    assert.equal(globalThis.StaticPropertyNamespace.NestedProperties.nestedProperty, 999);
    assert.equal(globalThis.StaticPropertyNamespace.NestedProperties.nestedConstant, "nested");
    assert.equal(globalThis.StaticPropertyNamespace.NestedProperties.nestedDouble, 1.414);

    globalThis.StaticPropertyNamespace.NestedProperties.nestedProperty = 1000;
    globalThis.StaticPropertyNamespace.NestedProperties.nestedDouble = 2.828;
    assert.equal(globalThis.StaticPropertyNamespace.NestedProperties.nestedProperty, 1000);
    assert.equal(globalThis.StaticPropertyNamespace.NestedProperties.nestedDouble, 2.828);

    // // Verify both globalThis and exports point to same objects
    // assert.equal(globalThis.StaticPropertyNamespace.namespaceProperty, exports.StaticPropertyNamespace.namespaceProperty);
    // assert.equal(globalThis.StaticPropertyNamespace.NestedProperties.nestedProperty, exports.StaticPropertyNamespace.NestedProperties.nestedProperty);

    // // Verify enum values accessible via globalThis match exports
    // assert.equal(exports.Configuration.LogLevel.Debug, globalThis.Configuration.LogLevelValues.Debug);
    // assert.equal(exports.Networking.API.Method.Get, globalThis.Networking.API.MethodValues.Get);
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
