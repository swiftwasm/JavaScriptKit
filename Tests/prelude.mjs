// @ts-check

import {
    Direction, Status, Theme, HttpStatus, TSDirection, TSTheme, APIResult, ComplexResult, APIOptionalResult, StaticCalculator, StaticPropertyEnum
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

    // Test property getters
    assert.equal(g.name, "John");
    assert.equal(g.prefix, "Hello");

    // Test property setters
    g.name = "Jane";
    assert.equal(g.name, "Jane");
    assert.equal(g.greet(), "Hello, Jane!");

    // Test readonly property (should still be readable)
    assert.equal(g.prefix, "Hello");

    // Test method-based name change still works
    g.changeName("Jay");
    assert.equal(g.name, "Jay");
    assert.equal(g.greet(), "Hello, Jay!");

    // Test that property changes via JS are reflected in Swift methods
    g.name = "Alice";
    assert.equal(g.greet(), "Hello, Alice!");
    exports.takeGreeter(g, "Bob");
    assert.equal(g.name, "Bob");
    assert.equal(g.greet(), "Hello, Bob!");

    const g2 = exports.roundTripSwiftHeapObject(g)
    assert.equal(g2.greet(), "Hello, Bob!");
    assert.equal(g2.name, "Bob");
    assert.equal(g2.prefix, "Hello");
    g2.release();

    g.release();

    // Test PropertyHolder with various types
    const testObj = { testProp: "test" };
    const sibling = new exports.SimplePropertyHolder(999);
    const ph = new exports.PropertyHolder(
        123,        // intValue
        3.14,       // floatValue
        2.718,      // doubleValue
        true,       // boolValue
        "test",     // stringValue
        testObj,    // jsObject
        sibling     // sibling
    );

    // Test primitive property getters
    assert.equal(ph.intValue, 123);
    assert.equal(ph.floatValue, 3.140000104904175); // Float32 precision
    assert.equal(ph.doubleValue, 2.718);
    assert.equal(ph.boolValue, true);
    assert.equal(ph.stringValue, "test");

    // Test readonly property getters
    assert.equal(ph.readonlyInt, 42);
    assert.equal(ph.readonlyFloat, 3.140000104904175); // Float32 precision
    assert.equal(ph.readonlyDouble, 2.718281828);
    assert.equal(ph.readonlyBool, true);
    assert.equal(ph.readonlyString, "constant");

    // Test JSObject property
    assert.equal(ph.jsObject, testObj);

    // Test SwiftHeapObject property (sibling should be a SimplePropertyHolder with value 999)
    assert.equal(ph.sibling.value, 999);

    // Test primitive property setters
    ph.intValue = 456;
    ph.floatValue = 6.28;
    ph.doubleValue = 1.414;
    ph.boolValue = false;
    ph.stringValue = "updated";

    assert.equal(ph.intValue, 456);
    assert.equal(ph.floatValue, 6.280000209808350); // Float32 precision
    assert.equal(ph.doubleValue, 1.414);
    assert.equal(ph.boolValue, false);
    assert.equal(ph.stringValue, "updated");

    // Test JSObject property setter
    const newObj = { newProp: "new" };
    ph.jsObject = newObj;
    assert.equal(ph.jsObject, newObj);

    // Test SwiftHeapObject property with different object
    const ph2 = exports.createPropertyHolder(999, 1.1, 2.2, false, "other", testObj);
    const newSibling = new exports.SimplePropertyHolder(123);
    ph.sibling = newSibling;
    assert.equal(ph.sibling.value, 123);

    // Test lazy property
    assert.equal(ph.lazyValue, "computed lazily");
    ph.lazyValue = "modified lazy";
    assert.equal(ph.lazyValue, "modified lazy");

    // Test computed read-write property
    assert.equal(ph.computedReadWrite, "Value: 456");
    ph.computedReadWrite = "Value: 777";
    assert.equal(ph.intValue, 777); // Should have parsed and set intValue
    assert.equal(ph.computedReadWrite, "Value: 777");

    // Test computed readonly property  
    assert.equal(ph.computedReadonly, 1554); // intValue * 2 = 777 * 2

    // Test property with observers
    // Sync observedProperty to match current intValue, then reset counters for clean test
    ph.observedProperty = 777; // Sync with current intValue after computed property changed it
    exports.resetObserverCounts(); // Reset counters to start fresh test

    // Set property from JavaScript and verify observers are called
    ph.observedProperty = 100;
    assert.equal(ph.observedProperty, 100);
    let afterSetStats = exports.getObserverStats();

    // Verify willSet and didSet were called
    // The stats should show: willSet:1,didSet:1,willSetOld:777,willSetNew:100,didSetOld:777,didSetNew:100
    assert(afterSetStats.includes("willSet:1"), `willSet should be called once, got: ${afterSetStats}`);
    assert(afterSetStats.includes("didSet:1"), `didSet should be called once, got: ${afterSetStats}`);
    assert(afterSetStats.includes("willSetOld:777"), `willSet should see old value 777, got: ${afterSetStats}`);
    assert(afterSetStats.includes("willSetNew:100"), `willSet should see new value 100, got: ${afterSetStats}`);
    assert(afterSetStats.includes("didSetOld:777"), `didSet should see old value 777, got: ${afterSetStats}`);
    assert(afterSetStats.includes("didSetNew:100"), `didSet should see new value 100, got: ${afterSetStats}`);

    // Set property to a different value and verify observers are called again
    ph.observedProperty = 200;
    assert.equal(ph.observedProperty, 200);
    let afterSecondSetStats = exports.getObserverStats();

    // Now should be: willSet:2,didSet:2,willSetOld:100,willSetNew:200,didSetOld:100,didSetNew:200
    assert(afterSecondSetStats.includes("willSet:2"), `willSet should be called twice, got: ${afterSecondSetStats}`);
    assert(afterSecondSetStats.includes("didSet:2"), `didSet should be called twice, got: ${afterSecondSetStats}`);
    assert(afterSecondSetStats.includes("willSetOld:100"), `willSet should see old value 100 on second call, got: ${afterSecondSetStats}`);
    assert(afterSecondSetStats.includes("willSetNew:200"), `willSet should see new value 200 on second call, got: ${afterSecondSetStats}`);
    assert(afterSecondSetStats.includes("didSetOld:100"), `didSet should see old value 100 on second call, got: ${afterSecondSetStats}`);
    assert(afterSecondSetStats.includes("didSetNew:200"), `didSet should see new value 200 on second call, got: ${afterSecondSetStats}`);

    ph.release();
    ph2.release();

    // Test static properties
    assert.equal(exports.StaticPropertyHolder.staticConstant, "constant");
    assert.equal(exports.StaticPropertyHolder.staticVariable, 42);
    assert.equal(exports.StaticPropertyHolder.staticString, "initial");
    assert.equal(exports.StaticPropertyHolder.staticBool, true);
    assert.equal(exports.StaticPropertyHolder.staticFloat, 3.140000104904175);
    assert.equal(exports.StaticPropertyHolder.staticDouble, 2.718);
    assert.equal(exports.StaticPropertyHolder.readOnlyComputed, 84); // staticVariable * 2 = 42 * 2

    // Test static primitive property setters
    exports.StaticPropertyHolder.staticVariable = 200;
    exports.StaticPropertyHolder.staticString = "updated";
    exports.StaticPropertyHolder.staticBool = false;
    exports.StaticPropertyHolder.staticFloat = 6.28;
    exports.StaticPropertyHolder.staticDouble = 1.414;

    assert.equal(exports.StaticPropertyHolder.staticVariable, 200);
    assert.equal(exports.StaticPropertyHolder.staticString, "updated");
    assert.equal(exports.StaticPropertyHolder.staticBool, false);
    assert.equal(exports.StaticPropertyHolder.staticFloat, 6.280000209808350);
    assert.equal(exports.StaticPropertyHolder.staticDouble, 1.414);

    // Test static JSObject
    const testStaticObj = { staticTest: "object" };
    exports.StaticPropertyHolder.jsObjectProperty = testStaticObj;
    assert.equal(exports.StaticPropertyHolder.jsObjectProperty, testStaticObj);

    const newStaticObj = { newStaticProp: "new" };
    exports.StaticPropertyHolder.jsObjectProperty = newStaticObj;
    assert.equal(exports.StaticPropertyHolder.jsObjectProperty, newStaticObj);

    // Test static optional properties
    assert.equal(exports.StaticPropertyHolder.optionalString, null);
    assert.equal(exports.StaticPropertyHolder.optionalInt, null);
    exports.StaticPropertyHolder.optionalString = "optional value";
    exports.StaticPropertyHolder.optionalInt = 42;
    assert.equal(exports.StaticPropertyHolder.optionalString, "optional value");
    assert.equal(exports.StaticPropertyHolder.optionalInt, 42);
    exports.StaticPropertyHolder.optionalString = null;
    exports.StaticPropertyHolder.optionalInt = null;
    assert.equal(exports.StaticPropertyHolder.optionalString, null);
    assert.equal(exports.StaticPropertyHolder.optionalInt, null);

    // Test static computed properties
    assert.equal(exports.StaticPropertyHolder.computedProperty, "computed: 200");
    exports.StaticPropertyHolder.computedProperty = "computed: 300"; // Should have parsed and set staticVariable
    assert.equal(exports.StaticPropertyHolder.staticVariable, 300);
    assert.equal(exports.StaticPropertyHolder.computedProperty, "computed: 300");
    assert.equal(exports.StaticPropertyHolder.readOnlyComputed, 600); // staticVariable * 2 = 300 * 2

    // Test static properties in enums
    assert.equal(exports.StaticPropertyEnum.enumProperty, "enum value");
    assert.equal(exports.StaticPropertyEnum.enumConstant, 42);
    assert.equal(exports.StaticPropertyEnum.enumBool, false);

    exports.StaticPropertyEnum.enumProperty = "modified enum";
    exports.StaticPropertyEnum.enumBool = true;
    assert.equal(exports.StaticPropertyEnum.enumProperty, "modified enum");
    assert.equal(exports.StaticPropertyEnum.enumBool, true);

    assert.equal(exports.StaticPropertyEnum.enumVariable, 200);
    assert.equal(exports.StaticPropertyEnum.computedReadonly, 400);
    assert.equal(exports.StaticPropertyEnum.computedReadWrite, "Value: 200");
    exports.StaticPropertyEnum.computedReadWrite = "Value: 500";
    assert.equal(exports.StaticPropertyEnum.enumVariable, 500);

    // Namespace enum static properties
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

    assert.equal(exports.roundtripNetworkingAPIMethod(globalThis.Networking.API.Method.Get), globalThis.Networking.API.Method.Get);
    assert.equal(exports.roundtripConfigurationLogLevel(globalThis.Configuration.LogLevel.Debug), globalThis.Configuration.LogLevel.Debug);
    assert.equal(exports.roundtripConfigurationPort(globalThis.Configuration.Port.Http), globalThis.Configuration.Port.Http);
    assert.equal(exports.processConfigurationLogLevel(globalThis.Configuration.LogLevel.Debug), globalThis.Configuration.Port.Development);
    assert.equal(exports.processConfigurationLogLevel(globalThis.Configuration.LogLevel.Info), globalThis.Configuration.Port.Http);
    assert.equal(exports.processConfigurationLogLevel(globalThis.Configuration.LogLevel.Warning), globalThis.Configuration.Port.Https);
    assert.equal(exports.processConfigurationLogLevel(globalThis.Configuration.LogLevel.Error), globalThis.Configuration.Port.Development);
    assert.equal(exports.roundtripInternalSupportedMethod(globalThis.Networking.APIV2.Internal.SupportedMethod.Get), globalThis.Networking.APIV2.Internal.SupportedMethod.Get);

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

    assert.deepEqual(exports.roundtripAPIResult(s1), s1);
    assert.deepEqual(exports.roundtripAPIResult(f1), f1);
    assert.deepEqual(exports.roundtripAPIResult(i1), i1);

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
    assert.deepEqual(exports.roundtripAPIResult(r1), r1);
    assert.deepEqual(exports.makeAPIResultRate(rVal), r1);

    const pVal = 3.141592653589793;
    const p1 = { tag: APIResult.Tag.Precise, param0: pVal };
    assert.deepEqual(exports.roundtripAPIResult(p1), p1);
    assert.deepEqual(exports.makeAPIResultPrecise(pVal), p1);

    const cs1 = { tag: ComplexResult.Tag.Success, param0: "All good!" };
    const ce1 = { tag: ComplexResult.Tag.Error, param0: "Network error", param1: 503 };
    const cl1 = { tag: ComplexResult.Tag.Location, param0: 37.7749, param1: -122.4194, param2: "San Francisco" };
    const cst1 = { tag: ComplexResult.Tag.Status, param0: true, param1: 200, param2: "OK" };
    const cc1 = { tag: ComplexResult.Tag.Coordinates, param0: 10.5, param1: 20.3, param2: 30.7 };
    const ccomp1 = { tag: ComplexResult.Tag.Comprehensive, param0: true, param1: false, param2: 42, param3: 100, param4: 3.14, param5: 2.718, param6: "Hello", param7: "World", param8: "Test" };
    const ci1 = { tag: ComplexResult.Tag.Info };

    assert.deepEqual(exports.roundtripComplexResult(cs1), cs1);
    assert.deepEqual(exports.roundtripComplexResult(ce1), ce1);
    assert.deepEqual(exports.roundtripComplexResult(cl1), cl1);
    assert.deepEqual(exports.roundtripComplexResult(cst1), cst1);
    assert.deepEqual(exports.roundtripComplexResult(cc1), cc1);
    assert.deepEqual(exports.roundtripComplexResult(ccomp1), ccomp1);
    assert.deepEqual(exports.roundtripComplexResult(ci1), ci1);

    assert.deepEqual(exports.makeComplexResultSuccess("Great!"), { tag: ComplexResult.Tag.Success, param0: "Great!" });
    assert.deepEqual(exports.makeComplexResultError("Timeout", 408), { tag: ComplexResult.Tag.Error, param0: "Timeout", param1: 408 });
    assert.deepEqual(exports.makeComplexResultLocation(40.7128, -74.0060, "New York"), { tag: ComplexResult.Tag.Location, param0: 40.7128, param1: -74.0060, param2: "New York" });
    assert.deepEqual(exports.makeComplexResultStatus(false, 500, "Internal Server Error"), { tag: ComplexResult.Tag.Status, param0: false, param1: 500, param2: "Internal Server Error" });
    assert.deepEqual(exports.makeComplexResultCoordinates(1.1, 2.2, 3.3), { tag: ComplexResult.Tag.Coordinates, param0: 1.1, param1: 2.2, param2: 3.3 });
    assert.deepEqual(exports.makeComplexResultComprehensive(true, false, 10, 20, 1.5, 2.5, "First", "Second", "Third"), { tag: ComplexResult.Tag.Comprehensive, param0: true, param1: false, param2: 10, param3: 20, param4: 1.5, param5: 2.5, param6: "First", param7: "Second", param8: "Third" });
    assert.deepEqual(exports.makeComplexResultInfo(), { tag: ComplexResult.Tag.Info });

    const urSuccess = { tag: globalThis.Utilities.Result.Tag.Success, param0: "Utility operation completed" };
    const urFailure = { tag: globalThis.Utilities.Result.Tag.Failure, param0: "Utility error occurred", param1: 500 };
    const urStatus = { tag: globalThis.Utilities.Result.Tag.Status, param0: true, param1: 200, param2: "Utility status OK" };

    assert.deepEqual(exports.roundtripUtilitiesResult(urSuccess), urSuccess);
    assert.deepEqual(exports.roundtripUtilitiesResult(urFailure), urFailure);
    assert.deepEqual(exports.roundtripUtilitiesResult(urStatus), urStatus);

    assert.deepEqual(exports.makeUtilitiesResultSuccess("Test"), { tag: globalThis.Utilities.Result.Tag.Success, param0: "Test" });
    assert.deepEqual(exports.makeUtilitiesResultSuccess("ok"), { tag: globalThis.Utilities.Result.Tag.Success, param0: "ok" });
    assert.deepEqual(exports.makeUtilitiesResultFailure("Error", 123), { tag: globalThis.Utilities.Result.Tag.Failure, param0: "Error", param1: 123 });
    assert.deepEqual(exports.makeUtilitiesResultStatus(true, 200, "OK"), { tag: globalThis.Utilities.Result.Tag.Status, param0: true, param1: 200, param2: "OK" });

    const nrSuccess = { tag: globalThis.API.NetworkingResult.Tag.Success, param0: "Network request successful" };
    const nrFailure = { tag: globalThis.API.NetworkingResult.Tag.Failure, param0: "Network timeout", param1: 408 };

    assert.deepEqual(exports.roundtripAPINetworkingResult(nrSuccess), nrSuccess);
    assert.deepEqual(exports.roundtripAPINetworkingResult(nrFailure), nrFailure);

    assert.deepEqual(exports.makeAPINetworkingResultSuccess("Connected"), { tag: globalThis.API.NetworkingResult.Tag.Success, param0: "Connected" });
    assert.deepEqual(exports.makeAPINetworkingResultFailure("Timeout", 408), { tag: globalThis.API.NetworkingResult.Tag.Failure, param0: "Timeout", param1: 408 });

    assert.equal(exports.roundTripOptionalString(null), null);
    assert.equal(exports.roundTripOptionalInt(null), null);
    assert.equal(exports.roundTripOptionalBool(null), null);
    assert.equal(exports.roundTripOptionalFloat(null), null);
    assert.equal(exports.roundTripOptionalDouble(null), null);

    assert.equal(exports.roundTripOptionalString("Hello"), "Hello");
    assert.equal(exports.roundTripOptionalInt(42), 42);
    assert.equal(exports.roundTripOptionalBool(true), true);
    assert.equal(exports.roundTripOptionalFloat(3.141592502593994), 3.141592502593994); // Float32 precision
    assert.equal(exports.roundTripOptionalDouble(2.718), 2.718);

    assert.equal(exports.roundTripOptionalSyntax(null), null);
    assert.equal(exports.roundTripOptionalSyntax("Test"), "Test");
    assert.equal(exports.roundTripOptionalMixSyntax(null), null);
    assert.equal(exports.roundTripOptionalMixSyntax("Mix"), "Mix");
    assert.equal(exports.roundTripOptionalSwiftSyntax(null), null);
    assert.equal(exports.roundTripOptionalSwiftSyntax("Swift"), "Swift");
    assert.equal(exports.roundTripOptionalWithSpaces(null), null);
    assert.equal(exports.roundTripOptionalWithSpaces(1.618), 1.618);
    assert.equal(exports.roundTripOptionalTypeAlias(null), null);
    assert.equal(exports.roundTripOptionalTypeAlias(25), 25);
    assert.equal(exports.roundTripOptionalStatus(Status.Success), Status.Success);
    assert.equal(exports.roundTripOptionalTheme(Theme.Light), Theme.Light);
    assert.equal(exports.roundTripOptionalHttpStatus(HttpStatus.Ok), HttpStatus.Ok);
    assert.equal(exports.roundTripOptionalTSDirection(TSDirection.North), TSDirection.North);
    assert.equal(exports.roundTripOptionalTSTheme(TSTheme.Light), TSTheme.Light);
    assert.equal(exports.roundTripOptionalNetworkingAPIMethod(globalThis.Networking.API.Method.Get), globalThis.Networking.API.Method.Get);
    assert.deepEqual(exports.roundTripOptionalAPIResult(p1), p1);
    assert.deepEqual(exports.roundTripOptionalComplexResult(cl1), cl1);

    const optionalGreeter = new exports.Greeter("Schrödinger");
    const optionalGreeter2 = exports.roundTripOptionalClass(optionalGreeter);
    assert.equal(optionalGreeter2?.greet() ?? "", "Hello, Schrödinger!");
    assert.equal(optionalGreeter2?.name ?? "", "Schrödinger");
    assert.equal(optionalGreeter2?.prefix ?? "", "Hello");
    assert.equal(exports.roundTripOptionalClass(null), null);
    optionalGreeter.release();
    optionalGreeter2?.release();

    const optionalsHolder = new exports.OptionalPropertyHolder(null);

    assert.equal(optionalsHolder.optionalName, null);
    assert.equal(optionalsHolder.optionalAge, null);
    assert.equal(optionalsHolder.optionalGreeter, null);

    optionalsHolder.optionalName = "Alice";
    optionalsHolder.optionalAge = 25;
    assert.equal(optionalsHolder.optionalName, "Alice");
    assert.equal(optionalsHolder.optionalAge, 25);

    const testPropertyGreeter = new exports.Greeter("Bob");
    optionalsHolder.optionalGreeter = testPropertyGreeter;
    assert.equal(optionalsHolder.optionalGreeter.greet(), "Hello, Bob!");
    assert.equal(optionalsHolder.optionalGreeter.name, "Bob");

    optionalsHolder.optionalName = null;
    optionalsHolder.optionalAge = null;
    optionalsHolder.optionalGreeter = null;
    assert.equal(optionalsHolder.optionalName, null);
    assert.equal(optionalsHolder.optionalAge, null);
    assert.equal(optionalsHolder.optionalGreeter, null);
    testPropertyGreeter.release();
    optionalsHolder.release();

    const aor1 = { tag: APIOptionalResult.Tag.Success, param0: "hello world" };
    const aor2 = { tag: APIOptionalResult.Tag.Success, param0: null };
    const aor3 = { tag: APIOptionalResult.Tag.Failure, param0: 404, param1: true };
    const aor4 = { tag: APIOptionalResult.Tag.Failure, param0: 404, param1: null };
    const aor5 = { tag: APIOptionalResult.Tag.Failure, param0: null, param1: null };
    const aor6 = { tag: APIOptionalResult.Tag.Status, param0: true, param1: 200, param2: "OK" };
    const aor7 = { tag: APIOptionalResult.Tag.Status, param0: true, param1: null, param2: "Partial" };
    const aor8 = { tag: APIOptionalResult.Tag.Status, param0: null, param1: null, param2: "Zero" };
    const aor9 = { tag: APIOptionalResult.Tag.Status, param0: false, param1: 500, param2: null };
    const aor10 = { tag: APIOptionalResult.Tag.Status, param0: null, param1: 0, param2: "Zero" };

    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor1), aor1);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor2), aor2);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor3), aor3);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor4), aor4);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor5), aor5);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor6), aor6);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor7), aor7);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor8), aor8);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor9), aor9);
    assert.deepEqual(exports.roundTripOptionalAPIOptionalResult(aor10), aor10);
    assert.equal(exports.roundTripOptionalAPIOptionalResult(null), null);

    assert.equal(exports.MathUtils.add(2147483647, 0), 2147483647);
    assert.equal(exports.StaticCalculator.roundtrip(42), 42);
    assert.equal(StaticCalculator.Scientific, 0);
    assert.equal(StaticCalculator.Basic, 1);

    assert.equal(globalThis.StaticUtils.Nested.roundtrip("hello world"), "hello world");
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