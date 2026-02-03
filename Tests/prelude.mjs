// @ts-check

import {
    DirectionValues, StatusValues, ThemeValues, HttpStatusValues, TSDirection, TSTheme, APIResultValues, ComplexResultValues, APIOptionalResultValues, StaticCalculatorValues, StaticPropertyEnumValues
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
                "jsRoundTripFeatureFlag": (flag) => {
                    return flag;
                },
                "$jsWeirdFunction": () => {
                    return 42;
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
                $WeirdClass: class {
                    constructor() {
                    }
                    ["method-with-dashes"]() {
                        return "ok";
                    }
                },
                Foo: ImportedFoo,
                runAsyncWorks: async () => {
                    const exports = importsContext.getExports();
                    if (!exports) {
                        throw new Error("No exports!?");
                    }
                    BridgeJSRuntimeTests_runAsyncWorks(exports);
                    return;
                },
                jsApplyInt: (v, fn) => {
                    return fn(v);
                },
                jsMakeAdder: (base) => {
                    return (v) => base + v;
                },
                jsMapString: (value, fn) => {
                    return fn(value);
                },
                jsMakePrefixer: (prefix) => {
                    return (name) => `${prefix}${name}`;
                },
                jsCallTwice: (v, fn) => {
                    fn(v);
                    fn(v);
                    return v;
                },
                jsTranslatePoint: (point, dx, dy) => {
                    return { x: (point.x | 0) + (dx | 0), y: (point.y | 0) + (dy | 0) };
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
            bridgeJSRuntimeTests["runJsStructWorks"] = () => {
                const exports = getExports();
                if (!exports) {
                    throw new Error("No exports!?");
                }
                return BridgeJSRuntimeTests_runJsStructWorks(exports);
            }
            const bridgeJSGlobalTests = importObject["BridgeJSGlobalTests"] || {};
            bridgeJSGlobalTests["runJsWorksGlobal"] = () => {
                return BridgeJSGlobalTests_runJsWorksGlobal();
            }
            importObject["BridgeJSRuntimeTests"] = bridgeJSRuntimeTests;
            importObject["BridgeJSGlobalTests"] = bridgeJSGlobalTests;
        }
    }
}

import assert from "node:assert";

class ImportedFoo {
    /** @param {string} value */
    constructor(value) {
        this.value = value;
    }
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function BridgeJSRuntimeTests_runJsWorks(instance, exports) {
    exports.roundTripVoid();
    for (const v of [0, 1, -1, 2147483647, -2147483648]) {
        assert.equal(exports.roundTripInt(v), v);
    }
    for (const v of [0, 1, 2147483647, 4294967295]) {
        assert.equal(exports.roundTripUInt(v), v);
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

    for (const p of [1, 4, 1024, 65536, 2147483647]) {
        assert.equal(exports.roundTripUnsafeRawPointer(p), p);
        assert.equal(exports.roundTripUnsafeMutableRawPointer(p), p);
        assert.equal(exports.roundTripOpaquePointer(p), p);
        assert.equal(exports.roundTripUnsafePointer(p), p);
        assert.equal(exports.roundTripUnsafeMutablePointer(p), p);
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

    const foo = exports.makeImportedFoo("hello");
    assert.ok(foo instanceof ImportedFoo);
    assert.equal(foo.value, "hello");

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
    assert.equal(exports.StaticPropertyNamespace.namespaceProperty, "namespace");
    assert.equal(exports.StaticPropertyNamespace.namespaceConstant, "constant");

    exports.StaticPropertyNamespace.namespaceProperty = "modified namespace";
    assert.equal(exports.StaticPropertyNamespace.namespaceProperty, "modified namespace");

    assert.equal(exports.StaticPropertyNamespace.NestedProperties.nestedProperty, 999);
    assert.equal(exports.StaticPropertyNamespace.NestedProperties.nestedConstant, "nested");
    assert.equal(exports.StaticPropertyNamespace.NestedProperties.nestedDouble, 1.414);

    exports.StaticPropertyNamespace.NestedProperties.nestedProperty = 1000;
    exports.StaticPropertyNamespace.NestedProperties.nestedDouble = 2.828;
    assert.equal(exports.StaticPropertyNamespace.NestedProperties.nestedProperty, 1000);
    assert.equal(exports.StaticPropertyNamespace.NestedProperties.nestedDouble, 2.828);

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

    // Test enums
    assert.equal(exports.Direction.North, 0);
    assert.equal(exports.Direction.South, 1);
    assert.equal(exports.Direction.East, 2);
    assert.equal(DirectionValues.West, 3);
    assert.equal(exports.Status.Loading, 0);
    assert.equal(exports.Status.Success, 1);
    assert.equal(StatusValues.Error, 2);

    assert.equal(exports.setDirection(exports.Direction.North), DirectionValues.North);
    assert.equal(exports.setDirection(exports.Direction.South), exports.Direction.South);
    assert.equal(exports.getDirection(), exports.Direction.North);
    assert.equal(exports.processDirection(exports.Direction.North), exports.Status.Success);
    assert.equal(exports.processDirection(DirectionValues.East), StatusValues.Loading);

    assert.equal(exports.Theme.Light, "light");
    assert.equal(exports.Theme.Dark, "dark");
    assert.equal(ThemeValues.Auto, "auto");
    assert.equal(exports.HttpStatus.Ok, 200);
    assert.equal(exports.HttpStatus.NotFound, 404);
    assert.equal(HttpStatusValues.ServerError, 500);
    assert.equal(HttpStatusValues.Unknown, -1);

    assert.equal(exports.Precision.Rough, 0.1);
    assert.equal(exports.Precision.Normal, 0.01);
    assert.equal(exports.Precision.Fine, 0.001);
    assert.equal(exports.Ratio.Quarter, 0.25);
    assert.equal(exports.Ratio.Half, 0.5);
    assert.equal(exports.Ratio.Golden, 1.618);

    assert.equal(exports.setTheme(exports.Theme.Light), exports.Theme.Light);
    assert.equal(exports.setTheme(exports.Theme.Dark), exports.Theme.Dark);
    assert.equal(exports.getTheme(), ThemeValues.Light);
    assert.equal(exports.setHttpStatus(exports.HttpStatus.Ok), HttpStatusValues.Ok);
    assert.equal(exports.getHttpStatus(), exports.HttpStatus.Ok);
    assert.equal(exports.processTheme(exports.Theme.Light), exports.HttpStatus.Ok);
    assert.equal(exports.processTheme(exports.Theme.Dark), HttpStatusValues.NotFound);

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

    assert.equal(exports.Networking.API.Method.Get, 0);
    assert.equal(exports.Networking.API.Method.Post, 1);
    assert.equal(exports.Networking.API.Method.Put, 2);
    assert.equal(exports.Networking.API.Method.Delete, 3);
    assert.equal(exports.Configuration.LogLevel.Debug, "debug");
    assert.equal(exports.Configuration.LogLevel.Info, "info");
    assert.equal(exports.Configuration.LogLevel.Warning, "warning");
    assert.equal(exports.Configuration.LogLevel.Error, "error");
    assert.equal(exports.Configuration.Port.Http, 80);
    assert.equal(exports.Configuration.Port.Https, 443);
    assert.equal(exports.Configuration.Port.Development, 3000);
    assert.equal(exports.Networking.APIV2.Internal.SupportedMethod.Get, 0);
    assert.equal(exports.Networking.APIV2.Internal.SupportedMethod.Post, 1);

    assert.equal(exports.roundtripNetworkingAPIMethod(exports.Networking.API.Method.Get), exports.Networking.API.Method.Get);
    assert.equal(exports.roundtripConfigurationLogLevel(exports.Configuration.LogLevel.Debug), exports.Configuration.LogLevel.Debug);
    assert.equal(exports.roundtripConfigurationPort(exports.Configuration.Port.Http), exports.Configuration.Port.Http);
    assert.equal(exports.processConfigurationLogLevel(exports.Configuration.LogLevel.Debug), exports.Configuration.Port.Development);
    assert.equal(exports.processConfigurationLogLevel(exports.Configuration.LogLevel.Info), exports.Configuration.Port.Http);
    assert.equal(exports.processConfigurationLogLevel(exports.Configuration.LogLevel.Warning), exports.Configuration.Port.Https);
    assert.equal(exports.roundtripInternalSupportedMethod(exports.Networking.APIV2.Internal.SupportedMethod.Get), exports.Networking.APIV2.Internal.SupportedMethod.Get);

    const converter = new exports.Utils.Converter();
    assert.equal(converter.toString(42), "42");
    assert.equal(converter.toString(123), "123");
    converter.release();

    assert.equal(exports.Utils.StringUtils.uppercase("hello"), "HELLO");
    assert.equal(exports.Utils.StringUtils.uppercase(""), "");
    assert.equal(exports.Utils.StringUtils.lowercase("WORLD"), "world");
    assert.equal(exports.Utils.StringUtils.lowercase("HeLLo"), "hello");

    const httpServer = new exports.Networking.API.HTTPServer();
    httpServer.call(exports.Networking.API.Method.Get);
    httpServer.call(exports.Networking.API.Method.Post);
    httpServer.release();

    const testServer = new exports.Networking.APIV2.Internal.TestServer();
    testServer.call(exports.Networking.APIV2.Internal.SupportedMethod.Get);
    testServer.call(exports.Networking.APIV2.Internal.SupportedMethod.Post);
    testServer.release();

    const s1 = { tag: exports.APIResult.Tag.Success, param0: "Cześć 🙋‍♂️" };
    const f1 = { tag: exports.APIResult.Tag.Failure, param0: 42 };
    const i1 = { tag: APIResultValues.Tag.Info };

    assert.deepEqual(exports.roundtripAPIResult(s1), s1);
    assert.deepEqual(exports.roundtripAPIResult(f1), f1);
    assert.deepEqual(exports.roundtripAPIResult(i1), i1);

    assert.deepEqual(exports.makeAPIResultSuccess("Test"), { tag: exports.APIResult.Tag.Success, param0: "Test" });
    assert.deepEqual(exports.makeAPIResultSuccess("ok"), { tag: exports.APIResult.Tag.Success, param0: "ok" });
    assert.deepEqual(exports.makeAPIResultFailure(123), { tag: exports.APIResult.Tag.Failure, param0: 123 });
    assert.deepEqual(exports.makeAPIResultInfo(), { tag: APIResultValues.Tag.Info });

    const bTrue = { tag: exports.APIResult.Tag.Flag, param0: true };
    const bFalse = { tag: exports.APIResult.Tag.Flag, param0: false };
    assert.deepEqual(exports.makeAPIResultFlag(true), bTrue);
    assert.deepEqual(exports.makeAPIResultFlag(false), bFalse);

    const rVal = 3.25;
    const r1 = { tag: exports.APIResult.Tag.Rate, param0: rVal };
    assert.deepEqual(exports.roundtripAPIResult(r1), r1);
    assert.deepEqual(exports.makeAPIResultRate(rVal), r1);

    const pVal = 3.141592653589793;
    const p1 = { tag: APIResultValues.Tag.Precise, param0: pVal };
    assert.deepEqual(exports.roundtripAPIResult(p1), p1);
    assert.deepEqual(exports.makeAPIResultPrecise(pVal), p1);

    const cs1 = { tag: exports.ComplexResult.Tag.Success, param0: "All good!" };
    const ce1 = { tag: exports.ComplexResult.Tag.Error, param0: "Network error", param1: 503 };
    const cl1 = { tag: exports.ComplexResult.Tag.Location, param0: 37.7749, param1: -122.4194, param2: "San Francisco" };
    const cst1 = { tag: exports.ComplexResult.Tag.Status, param0: true, param1: 200, param2: "OK" };
    const cc1 = { tag: exports.ComplexResult.Tag.Coordinates, param0: 10.5, param1: 20.3, param2: 30.7 };
    const ccomp1 = { tag: ComplexResultValues.Tag.Comprehensive, param0: true, param1: false, param2: 42, param3: 100, param4: 3.14, param5: 2.718, param6: "Hello", param7: "World", param8: "Test" };
    const ci1 = { tag: ComplexResultValues.Tag.Info };

    assert.deepEqual(exports.roundtripComplexResult(cs1), cs1);
    assert.deepEqual(exports.roundtripComplexResult(ce1), ce1);
    assert.deepEqual(exports.roundtripComplexResult(cl1), cl1);
    assert.deepEqual(exports.roundtripComplexResult(cst1), cst1);
    assert.deepEqual(exports.roundtripComplexResult(cc1), cc1);
    assert.deepEqual(exports.roundtripComplexResult(ccomp1), ccomp1);
    assert.deepEqual(exports.roundtripComplexResult(ci1), ci1);

    assert.deepEqual(exports.makeComplexResultSuccess("Great!"), { tag: exports.ComplexResult.Tag.Success, param0: "Great!" });
    assert.deepEqual(exports.makeComplexResultError("Timeout", 408), { tag: exports.ComplexResult.Tag.Error, param0: "Timeout", param1: 408 });
    assert.deepEqual(exports.makeComplexResultLocation(40.7128, -74.0060, "New York"), { tag: exports.ComplexResult.Tag.Location, param0: 40.7128, param1: -74.0060, param2: "New York" });
    assert.deepEqual(exports.makeComplexResultStatus(false, 500, "Internal Server Error"), { tag: exports.ComplexResult.Tag.Status, param0: false, param1: 500, param2: "Internal Server Error" });
    assert.deepEqual(exports.makeComplexResultCoordinates(1.1, 2.2, 3.3), { tag: exports.ComplexResult.Tag.Coordinates, param0: 1.1, param1: 2.2, param2: 3.3 });
    assert.deepEqual(exports.makeComplexResultComprehensive(true, false, 10, 20, 1.5, 2.5, "First", "Second", "Third"), { tag: exports.ComplexResult.Tag.Comprehensive, param0: true, param1: false, param2: 10, param3: 20, param4: 1.5, param5: 2.5, param6: "First", param7: "Second", param8: "Third" });
    assert.deepEqual(exports.makeComplexResultInfo(), { tag: exports.ComplexResult.Tag.Info });

    const urSuccess = { tag: exports.Utilities.Result.Tag.Success, param0: "Utility operation completed" };
    const urFailure = { tag: exports.Utilities.Result.Tag.Failure, param0: "Utility error occurred", param1: 500 };
    const urStatus = { tag: exports.Utilities.Result.Tag.Status, param0: true, param1: 200, param2: "Utility status OK" };

    assert.deepEqual(exports.roundtripUtilitiesResult(urSuccess), urSuccess);
    assert.deepEqual(exports.roundtripUtilitiesResult(urFailure), urFailure);
    assert.deepEqual(exports.roundtripUtilitiesResult(urStatus), urStatus);

    assert.deepEqual(exports.makeUtilitiesResultSuccess("Test"), { tag: exports.Utilities.Result.Tag.Success, param0: "Test" });
    assert.deepEqual(exports.makeUtilitiesResultSuccess("ok"), { tag: exports.Utilities.Result.Tag.Success, param0: "ok" });
    assert.deepEqual(exports.makeUtilitiesResultFailure("Error", 123), { tag: exports.Utilities.Result.Tag.Failure, param0: "Error", param1: 123 });
    assert.deepEqual(exports.makeUtilitiesResultStatus(true, 200, "OK"), { tag: exports.Utilities.Result.Tag.Status, param0: true, param1: 200, param2: "OK" });

    const nrSuccess = { tag: exports.API.NetworkingResult.Tag.Success, param0: "Network request successful" };
    const nrFailure = { tag: exports.API.NetworkingResult.Tag.Failure, param0: "Network timeout", param1: 408 };

    assert.deepEqual(exports.roundtripAPINetworkingResult(nrSuccess), nrSuccess);
    assert.deepEqual(exports.roundtripAPINetworkingResult(nrFailure), nrFailure);

    assert.deepEqual(exports.makeAPINetworkingResultSuccess("Connected"), { tag: exports.API.NetworkingResult.Tag.Success, param0: "Connected" });
    assert.deepEqual(exports.makeAPINetworkingResultFailure("Timeout", 408), { tag: exports.API.NetworkingResult.Tag.Failure, param0: "Timeout", param1: 408 });

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
    assert.equal(exports.roundTripOptionalStatus(exports.Status.Success), StatusValues.Success);
    assert.equal(exports.roundTripOptionalTheme(exports.Theme.Light), ThemeValues.Light);
    assert.equal(exports.roundTripOptionalHttpStatus(exports.HttpStatus.Ok), HttpStatusValues.Ok);
    assert.equal(exports.roundTripOptionalTSDirection(TSDirection.North), TSDirection.North);
    assert.equal(exports.roundTripOptionalTSTheme(TSTheme.Light), TSTheme.Light);
    assert.equal(exports.roundTripOptionalNetworkingAPIMethod(exports.Networking.API.Method.Get), exports.Networking.API.Method.Get);
    assert.deepEqual(exports.roundTripOptionalAPIResult(p1), p1);
    assert.deepEqual(exports.roundTripOptionalComplexResult(cl1), cl1);

    const apiSuccess = { tag: exports.APIResult.Tag.Success, param0: "test success" };
    const apiFailure = { tag: exports.APIResult.Tag.Failure, param0: 404 };
    const apiInfo = { tag: exports.APIResult.Tag.Info };

    assert.equal(exports.compareAPIResults(apiSuccess, apiFailure), "r1:success:test success,r2:failure:404");
    assert.equal(exports.compareAPIResults(null, apiInfo), "r1:nil,r2:info");
    assert.equal(exports.compareAPIResults(apiFailure, null), "r1:failure:404,r2:nil");
    assert.equal(exports.compareAPIResults(null, null), "r1:nil,r2:nil");

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

    const aor1 = { tag: APIOptionalResultValues.Tag.Success, param0: "hello world" };
    const aor2 = { tag: APIOptionalResultValues.Tag.Success, param0: null };
    const aor3 = { tag: APIOptionalResultValues.Tag.Failure, param0: 404, param1: true };
    const aor4 = { tag: APIOptionalResultValues.Tag.Failure, param0: 404, param1: null };
    const aor5 = { tag: APIOptionalResultValues.Tag.Failure, param0: null, param1: null };
    const aor6 = { tag: APIOptionalResultValues.Tag.Status, param0: true, param1: 200, param2: "OK" };
    const aor7 = { tag: APIOptionalResultValues.Tag.Status, param0: true, param1: null, param2: "Partial" };
    const aor8 = { tag: APIOptionalResultValues.Tag.Status, param0: null, param1: null, param2: "Zero" };
    const aor9 = { tag: APIOptionalResultValues.Tag.Status, param0: false, param1: 500, param2: null };
    const aor10 = { tag: APIOptionalResultValues.Tag.Status, param0: null, param1: 0, param2: "Zero" };

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
    assert.equal(StaticCalculatorValues.Scientific, 0);
    assert.equal(StaticCalculatorValues.Basic, 1);
    assert.equal(StaticCalculatorValues.Scientific, exports.StaticCalculator.Scientific);
    assert.equal(StaticCalculatorValues.Basic, exports.StaticCalculator.Basic);
    assert.equal(exports.StaticUtils.Nested.roundtrip("hello world"), "hello world");
    assert.equal(exports.StaticUtils.Nested.roundtrip("test"), "test");

    assert.equal(exports.Services.Graph.GraphOperations.createGraph(5), 50);
    assert.equal(exports.Services.Graph.GraphOperations.createGraph(0), 0);
    assert.equal(exports.Services.Graph.GraphOperations.nodeCount(42), 42);
    assert.equal(exports.Services.Graph.GraphOperations.nodeCount(0), 0);

    // Test default parameters
    assert.equal(exports.testStringDefault(), "Hello World");
    assert.equal(exports.testStringDefault("Custom Message"), "Custom Message");

    assert.equal(exports.testIntDefault(), 42);
    assert.equal(exports.testIntDefault(100), 100);

    assert.equal(exports.testBoolDefault(), true);
    assert.equal(exports.testBoolDefault(false), false);

    assert.equal(exports.testOptionalDefault(), null);
    assert.equal(exports.testOptionalDefault("Test"), "Test");

    assert.equal(exports.testMultipleDefaults(), "Default Title: -10 (false)");
    assert.equal(exports.testMultipleDefaults("Custom"), "Custom: -10 (false)");
    assert.equal(exports.testMultipleDefaults("Custom", 5), "Custom: 5 (false)");
    assert.equal(exports.testMultipleDefaults("Custom", undefined, true), "Custom: -10 (true)");
    assert.equal(exports.testMultipleDefaults("Custom", 5, true), "Custom: 5 (true)");

    assert.equal(exports.testSimpleEnumDefault(), exports.Status.Success);
    assert.equal(exports.testSimpleEnumDefault(exports.Status.Loading), exports.Status.Loading);

    assert.equal(exports.testDirectionDefault(), exports.Direction.North);
    assert.equal(exports.testDirectionDefault(exports.Direction.South), exports.Direction.South);

    assert.equal(exports.testRawStringEnumDefault(), exports.Theme.Light);
    assert.equal(exports.testRawStringEnumDefault(exports.Theme.Dark), exports.Theme.Dark);

    const holder = exports.testEmptyInit()
    assert.notEqual(holder, null);
    holder.release();

    const customHolder = new exports.StaticPropertyHolder();
    assert.deepEqual(exports.testEmptyInit(customHolder), customHolder);
    customHolder.release();

    assert.equal(exports.testComplexInit(), "Hello, DefaultGreeter!");
    const customGreeter = new exports.Greeter("CustomName");
    assert.equal(exports.testComplexInit(customGreeter), "Hello, CustomName!");

    customGreeter.release();

    const cd1 = new exports.ConstructorDefaults();
    assert.equal(cd1.describe(), "Default:42:true:success:nil");
    cd1.release();

    const cd2 = new exports.ConstructorDefaults("Custom");
    assert.equal(cd2.describe(), "Custom:42:true:success:nil");
    cd2.release();

    const cd3 = new exports.ConstructorDefaults("Custom", 100);
    assert.equal(cd3.describe(), "Custom:100:true:success:nil");
    cd3.release();

    const cd4 = new exports.ConstructorDefaults("Custom", undefined, false);
    assert.equal(cd4.describe(), "Custom:42:false:success:nil");
    cd4.release();

    const cd5 = new exports.ConstructorDefaults("Test", 99, false, exports.Status.Loading);
    assert.equal(cd5.describe(), "Test:99:false:loading:nil");
    cd5.release();

    testProtocolSupport(exports);
    testClosureSupport(exports);
    testArraySupport(exports);
}
/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function testClosureSupport(exports) {
    const upperTransform = (text) => text.toUpperCase();
    const processor = new exports.TextProcessor(upperTransform);

    assert.equal(processor.process("hello"), "HELLO");

    const multiParamTransform = (count, text, ratio) => {
        return `${text.toUpperCase()}-${count}-${ratio.toFixed(2)}`;
    };
    assert.equal(processor.processWithCustom("world", multiParamTransform), "WORLD-42-3.14");
    assert.equal(processor.process("test"), "TEST");

    const greeterForClosure = new exports.Greeter("World");
    const greeterCaller = new exports.Greeter("Caller");
    const customGreeting = (greeter) => `Custom greeting for ${greeter.name}: ${greeter.greet()}`;
    const greetResult = greeterCaller.greetWith(greeterForClosure, customGreeting);
    assert.equal(greetResult, "Custom greeting for World: Hello, World!");
    greeterForClosure.release();
    greeterCaller.release();

    assert.equal(exports.formatName("ada", (name) => name.toUpperCase()), "ADA");
    assert.equal(exports.formatName("grace", (name) => `Dr. ${name}`), "Dr. grace");

    const addDr = exports.makeFormatter("Dr.");
    assert.equal(addDr("Ada"), "Dr. Ada");
    assert.equal(addDr("Grace"), "Dr. Grace");

    const addProf = exports.makeFormatter("Prof.");
    assert.equal(addProf("Hopper"), "Prof. Hopper");

    const add10 = exports.makeAdder(10);
    assert.equal(add10(5), 15);
    assert.equal(add10(32), 42);

    const add100 = exports.makeAdder(100);
    assert.equal(add100(23), 123);

    const storedTransform = processor.getTransform();
    assert.equal(storedTransform("hello"), "HELLO");
    assert.equal(storedTransform("world"), "WORLD");

    const greeterForFormatter = new exports.Greeter("Formatter");
    const greeterFormatter = greeterForFormatter.makeFormatter(" [suffix]");
    assert.equal(greeterFormatter("test"), "Hello, Formatter! - test -  [suffix]");
    assert.equal(greeterFormatter("data"), "Hello, Formatter! - data -  [suffix]");
    greeterForFormatter.release();

    const greeterCreator = exports.Greeter.makeCreator("Default");
    const createdG1 = greeterCreator("Alice");
    assert.equal(createdG1.name, "Alice");
    assert.equal(createdG1.greet(), "Hello, Alice!");
    const createdG2 = greeterCreator("");
    assert.equal(createdG2.name, "Default");
    assert.equal(createdG2.greet(), "Hello, Default!");
    createdG1.release();
    createdG2.release();

    const greeterHost = new exports.Greeter("Host");
    const greeterGreeter = greeterHost.makeCustomGreeter();
    const guest1 = new exports.Greeter("Guest1");
    const guest2 = new exports.Greeter("Guest2");
    assert.equal(greeterGreeter(guest1), "Host greets Guest1: Hello, Guest1!");
    assert.equal(greeterGreeter(guest2), "Host greets Guest2: Hello, Guest2!");
    greeterHost.release();
    guest1.release();
    guest2.release();

    const greeterForMethod = new exports.Greeter("Method");
    const greeterParam = new exports.Greeter("Param");
    const methodResult = greeterForMethod.greetWith(greeterParam, (g) => {
        return `Custom: ${g.name} says ${g.greet()}`;
    });
    assert.equal(methodResult, "Custom: Param says Hello, Param!");
    greeterForMethod.release();
    greeterParam.release();

    const optResult1 = processor.processOptionalString((value) => {
        return value !== null ? `Got: ${value}` : `Got: null`;
    });
    assert.equal(optResult1, "Got: test | Got: null");

    const optResult2 = processor.processOptionalInt((value) => {
        return value !== null ? `Number: ${value}` : `Number: null`;
    });
    assert.equal(optResult2, "Number: 42 | Number: null");

    const optResult3 = processor.processOptionalGreeter((greeter) => {
        return greeter !== null ? `Greeter: ${greeter.name}` : `Greeter: null`;
    });
    assert.equal(optResult3, "Greeter: Alice | Greeter: null");

    const optFormatter = processor.makeOptionalStringFormatter();
    assert.equal(optFormatter("world"), "Got: world");
    assert.equal(optFormatter(null), "Got: nil");

    const optCreator = processor.makeOptionalGreeterCreator();
    const opt1 = optCreator();
    assert.equal(opt1, null);
    const opt2 = optCreator();
    assert.notEqual(opt2, null);
    assert.equal(opt2.name, "Greeter2");
    assert.equal(opt2.greet(), "Hello, Greeter2!");
    opt2.release();
    const opt3 = optCreator();
    assert.equal(opt3, null);
    const opt4 = optCreator();
    assert.notEqual(opt4, null);
    assert.equal(opt4.name, "Greeter4");
    opt4.release();

    const dirResult = processor.processDirection((dir) => {
        switch (dir) {
            case exports.Direction.North: return "Going North";
            case exports.Direction.South: return "Going South";
            case exports.Direction.East: return "Going East";
            case exports.Direction.West: return "Going West";
            default: return "Unknown";
        }
    });
    assert.equal(dirResult, "Going North");

    const themeResult = processor.processTheme((theme) => {
        return theme === exports.Theme.Dark ? "Dark mode" : "Light mode";
    });
    assert.equal(themeResult, "Dark mode");

    const statusResult = processor.processHttpStatus((status) => {
        return status;
    });
    assert.equal(statusResult, exports.HttpStatus.Ok);

    const apiResult = processor.processAPIResult((result) => {
        if (result.tag === exports.APIResult.Tag.Success) {
            return `API Success: ${result.param0}`;
        }
        return "API Other";
    });
    assert.equal(apiResult, "API Success: test");

    const dirChecker = processor.makeDirectionChecker();
    assert.equal(dirChecker(exports.Direction.North), true);
    assert.equal(dirChecker(exports.Direction.South), true);
    assert.equal(dirChecker(exports.Direction.East), false);
    assert.equal(dirChecker(exports.Direction.West), false);

    const themeValidator = processor.makeThemeValidator();
    assert.equal(themeValidator(exports.Theme.Dark), true);
    assert.equal(themeValidator(exports.Theme.Light), false);
    assert.equal(themeValidator(exports.Theme.Auto), false);

    const statusExtractor = processor.makeStatusCodeExtractor();
    assert.equal(statusExtractor(exports.HttpStatus.Ok), 200);
    assert.equal(statusExtractor(exports.HttpStatus.NotFound), 404);
    assert.equal(statusExtractor(exports.HttpStatus.ServerError), 500);
    assert.equal(statusExtractor(exports.HttpStatus.Unknown), -1);

    const apiHandler = processor.makeAPIResultHandler();
    assert.equal(apiHandler({ tag: exports.APIResult.Tag.Success, param0: "done" }), "Success: done");
    assert.equal(apiHandler({ tag: exports.APIResult.Tag.Failure, param0: 500 }), "Failure: 500");
    assert.equal(apiHandler({ tag: exports.APIResult.Tag.Info }), "Info");
    assert.equal(apiHandler({ tag: exports.APIResult.Tag.Flag, param0: true }), "Flag: true");
    assert.equal(apiHandler({ tag: exports.APIResult.Tag.Rate, param0: 1.5 }), "Rate: 1.5");
    assert.equal(apiHandler({ tag: exports.APIResult.Tag.Precise, param0: 3.14159 }), "Precise: 3.14159");

    const optDirResult = processor.processOptionalDirection((dir) => {
        return dir !== null ? `Dir: ${dir}` : "Dir: null";
    });
    assert.equal(optDirResult, `Dir: ${exports.Direction.North} | Dir: null`);

    const optThemeResult = processor.processOptionalTheme((theme) => {
        return theme !== null ? `Theme: ${theme}` : "Theme: null";
    });
    assert.equal(optThemeResult, `Theme: ${exports.Theme.Light} | Theme: null`);

    const optApiResult = processor.processOptionalAPIResult((result) => {
        if (result === null) return "Result: null";
        if (result.tag === exports.APIResult.Tag.Success) {
            return `Result: Success(${result.param0})`;
        }
        return "Result: other";
    });
    assert.equal(optApiResult, "Result: Success(ok) | Result: null");

    const optDirFormatter = processor.makeOptionalDirectionFormatter();
    assert.equal(optDirFormatter(exports.Direction.North), "N");
    assert.equal(optDirFormatter(exports.Direction.South), "S");
    assert.equal(optDirFormatter(exports.Direction.East), "E");
    assert.equal(optDirFormatter(exports.Direction.West), "W");
    assert.equal(optDirFormatter(null), "nil");

    processor.release();
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function testStructSupport(exports) {
    const data1 = { x: 1.5, y: 2.5, label: "Point", optCount: 42, optFlag: true };
    assert.deepEqual(exports.roundTripDataPoint(data1), data1);
    const data2 = { x: 0.0, y: 0.0, label: "", optCount: null, optFlag: null };
    assert.deepEqual(exports.roundTripDataPoint(data2), data2);

    const pointerFields1 = { raw: 1, mutRaw: 4, opaque: 1024, ptr: 65536, mutPtr: 2 };
    assert.deepEqual(exports.roundTripPointerFields(pointerFields1), pointerFields1);

    const contact1 = {
        name: "Alice",
        age: 30,
        address: { street: "123 Main St", city: "NYC", zipCode: 10001 },
        email: "alice@test.com",
        secondaryAddress: { street: "456 Oak Ave", city: "LA", zipCode: null }
    };
    assert.deepEqual(exports.roundTripContact(contact1), contact1);
    const contact2 = {
        name: "Bob",
        age: 25,
        address: { street: "789 Pine Rd", city: "SF", zipCode: null },
        email: null,
        secondaryAddress: null
    };
    assert.deepEqual(exports.roundTripContact(contact2), contact2);

    const config1 = {
        name: "prod",
        theme: exports.Theme.Dark,
        direction: exports.Direction.North,
        status: exports.Status.Success
    };
    assert.deepEqual(exports.roundTripConfig(config1), config1);
    const config2 = {
        name: "dev",
        theme: null,
        direction: null,
        status: exports.Status.Loading
    };
    assert.deepEqual(exports.roundTripConfig(config2), config2);

    const owner1 = new exports.Greeter("TestUser");
    const session1 = { id: 123, owner: owner1 };
    const resultSession1 = exports.roundTripSessionData(session1);
    assert.equal(resultSession1.id, 123);
    assert.equal(resultSession1.owner.greet(), "Hello, TestUser!");
    const session2 = { id: 456, owner: null };
    assert.deepEqual(exports.roundTripSessionData(session2), session2);
    owner1.release();
    resultSession1.owner.release();

    const report1 = {
        id: 100,
        result: { tag: exports.APIResult.Tag.Success, param0: "ok" },
        status: exports.Status.Success,
        outcome: { tag: exports.APIResult.Tag.Info }
    };
    assert.deepEqual(exports.roundTripValidationReport(report1), report1);
    const report2 = {
        id: 200,
        result: { tag: exports.APIResult.Tag.Failure, param0: 404 },
        status: null,
        outcome: null
    };
    assert.deepEqual(exports.roundTripValidationReport(report2), report2);

    const origReport = {
        id: 999,
        result: { tag: exports.APIResult.Tag.Failure, param0: 500 },
        status: exports.Status.Error,
        outcome: { tag: exports.APIResult.Tag.Info }
    };
    const updatedReport = exports.updateValidationReport(
        { tag: exports.APIResult.Tag.Success, param0: "updated" },
        origReport
    );
    assert.deepEqual(updatedReport.result, { tag: exports.APIResult.Tag.Success, param0: "updated" });
    assert.deepEqual(exports.updateValidationReport(null, origReport).result, origReport.result);

    const advancedConfig1 = {
        id: 42,
        title: "Primary",
        enabled: true,
        theme: exports.Theme.Dark,
        status: exports.Status.Success,
        result: { tag: exports.APIResult.Tag.Success, param0: "ok" },
        metadata: { note: "extra" },
        location: data1,
        defaults: { name: "base", value: 10 },
        overrideDefaults: { name: "override", value: 20 },
    };
    assert.deepEqual(exports.roundTripAdvancedConfig(advancedConfig1), advancedConfig1);

    const advancedConfig2 = {
        id: 99,
        title: "",
        enabled: false,
        theme: exports.Theme.Light,
        status: exports.Status.Loading,
        result: null,
        metadata: null,
        location: null,
        defaults: { name: "base", value: 0 },
        overrideDefaults: null,
    };
    assert.deepEqual(exports.roundTripAdvancedConfig(advancedConfig2), advancedConfig2);

    assert.equal(exports.MathOperations.subtract(10.0, 4.0), 6.0);
    const mathOps = exports.MathOperations.init();
    assert.equal(mathOps.baseValue, 0.0);
    assert.equal(mathOps.add(5.0, 3.0), 8.0);
    assert.equal(mathOps.multiply(4.0, 7.0), 28.0);

    const mathOps2 = exports.MathOperations.init(100.0);
    assert.equal(mathOps2.baseValue, 100.0);
    assert.equal(mathOps2.add(5.0, 3.0), 108.0);

    assert.equal(mathOps.add(5.0), 15.0);
    assert.equal(mathOps2.add(5.0), 115.0);

    assert.equal(exports.testStructDefault(), "1.0,2.0,default");
    const customPoint = { x: 10.0, y: 20.0, label: "custom", optCount: null, optFlag: null };
    assert.equal(exports.testStructDefault(customPoint), "10.0,20.0,custom");

    // Test @JS struct init(unsafelyCopying:) + toJSObject()
    const cart1 = { x: 123, note: "hello" };
    assert.deepEqual(exports.CopyableCart.fromJSObject(cart1), cart1);
    assert.deepEqual(exports.cartToJSObject(cart1), cart1);

    const cart2 = { x: 1 };
    assert.deepEqual(exports.CopyableCart.fromJSObject(cart2), { x: 1, note: null });
    assert.deepEqual(exports.cartToJSObject(cart2), { x: 1, note: null });

    const nestedCart1 = {
        id: 7,
        item: { sku: "ABC-123", quantity: 2 },
        shippingAddress: { street: "1 Swift Way", city: "WasmCity", zipCode: 12345 },
    };
    assert.deepEqual(exports.CopyableNestedCart.fromJSObject(nestedCart1), nestedCart1);
    assert.deepEqual(exports.nestedCartToJSObject(nestedCart1), nestedCart1);

    const nestedCart2 = {
        id: 8,
        item: { sku: "XYZ-999", quantity: 0 },
        shippingAddress: null,
    };
    assert.deepEqual(exports.CopyableNestedCart.fromJSObject(nestedCart2), nestedCart2);
    assert.deepEqual(exports.nestedCartToJSObject(nestedCart2), nestedCart2);

    const container = exports.testContainerWithStruct({ x: 5.0, y: 10.0, label: "test", optCount: null, optFlag: true });
    assert.equal(container.location.x, 5.0);
    assert.equal(container.config, null);
    container.release();

    assert.equal(exports.ConfigStruct.defaultConfig, "production");
    assert.equal(exports.ConfigStruct.maxRetries, 3);
    assert.equal(exports.ConfigStruct.computedSetting, "Config: production");
    exports.ConfigStruct.defaultConfig = "staging";
    assert.equal(exports.ConfigStruct.computedSetting, "Config: staging");
    exports.ConfigStruct.defaultConfig = "production";

    const { Precision, Ratio } = exports;
    const mc1 = {
        precision: Math.fround(Precision.Rough),
        ratio: Ratio.Golden,
        optionalPrecision: Math.fround(Precision.Fine),
        optionalRatio: Ratio.Half
    };
    assert.deepEqual(exports.roundTripMeasurementConfig(mc1), mc1);
    const mc2 = {
        precision: Math.fround(Precision.Normal),
        ratio: Ratio.Quarter,
        optionalPrecision: null,
        optionalRatio: null
    };
    assert.deepEqual(exports.roundTripMeasurementConfig(mc2), mc2);
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
async function BridgeJSRuntimeTests_runAsyncWorks(exports) {
    await exports.asyncRoundTripVoid();
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function BridgeJSRuntimeTests_runJsStructWorks(exports) {
    testStructSupport(exports);
}

function BridgeJSGlobalTests_runJsWorksGlobal() {
    assert.equal(globalThis.GlobalNetworking.API.CallMethodValues.Get, 0);
    assert.equal(globalThis.GlobalNetworking.API.CallMethodValues.Post, 1);
    assert.equal(globalThis.GlobalNetworking.API.CallMethodValues.Put, 2);
    assert.equal(globalThis.GlobalNetworking.API.CallMethodValues.Delete, 3);

    assert.equal(globalThis.GlobalConfiguration.PublicLogLevelValues.Debug, "debug");
    assert.equal(globalThis.GlobalConfiguration.PublicLogLevelValues.Info, "info");
    assert.equal(globalThis.GlobalConfiguration.PublicLogLevelValues.Warning, "warning");
    assert.equal(globalThis.GlobalConfiguration.PublicLogLevelValues.Error, "error");
    assert.equal(globalThis.GlobalConfiguration.AvailablePortValues.Http, 80);
    assert.equal(globalThis.GlobalConfiguration.AvailablePortValues.Https, 443);
    assert.equal(globalThis.GlobalConfiguration.AvailablePortValues.Development, 3000);

    assert.equal(globalThis.GlobalNetworking.APIV2.Internal.SupportedServerMethodValues.Get, 0);
    assert.equal(globalThis.GlobalNetworking.APIV2.Internal.SupportedServerMethodValues.Post, 1);

    const globalConverter = new globalThis.GlobalUtils.PublicConverter();
    assert.equal(globalConverter.toString(99), "99");
    globalConverter.release();

    const globalHttpServer = new globalThis.GlobalNetworking.API.TestHTTPServer();
    globalHttpServer.call(globalThis.GlobalNetworking.API.CallMethodValues.Get);
    globalHttpServer.release();

    const globalTestServer = new globalThis.GlobalNetworking.APIV2.Internal.TestInternalServer();
    globalTestServer.call(globalThis.GlobalNetworking.APIV2.Internal.SupportedServerMethodValues.Post);
    globalTestServer.release();

    assert.equal(globalThis.GlobalStaticPropertyNamespace.namespaceProperty, "namespace");
    assert.equal(globalThis.GlobalStaticPropertyNamespace.namespaceConstant, "constant");

    globalThis.GlobalStaticPropertyNamespace.namespaceProperty = "further modified";
    assert.equal(globalThis.GlobalStaticPropertyNamespace.namespaceProperty, "further modified");

    assert.equal(globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedProperty, 999);
    assert.equal(globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedConstant, "nested");
    assert.equal(globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedDouble, 1.414);

    globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedProperty = 2000;
    globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedDouble = 3.141;
    assert.equal(globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedProperty, 2000);
    assert.equal(globalThis.GlobalStaticPropertyNamespace.NestedProperties.nestedDouble, 3.141);
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

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function testArraySupport(exports) {
    const { Direction, Status, Theme, HttpStatus, Greeter } = exports;

    // Primitive arrays
    assert.deepEqual(exports.roundTripIntArray([1, 2, 3, -10, 2147483647]), [1, 2, 3, -10, 2147483647]);
    assert.deepEqual(exports.roundTripIntArray([]), []);
    assert.deepEqual(exports.roundTripStringArray(["Hello", "World", ""]), ["Hello", "World", ""]);
    const doubles = exports.roundTripDoubleArray([1.5, 0.0, -1.5, Infinity, NaN]);
    assert.equal(doubles[0], 1.5);
    assert(Number.isNaN(doubles[4]));
    assert.deepEqual(exports.roundTripBoolArray([true, false, true]), [true, false, true]);

    // Enum arrays
    assert.deepEqual(exports.roundTripDirectionArray([Direction.North, Direction.South]), [Direction.North, Direction.South]);
    assert.deepEqual(exports.roundTripStatusArray([Status.Loading, Status.Success]), [Status.Loading, Status.Success]);
    assert.deepEqual(exports.roundTripThemeArray([Theme.Light, Theme.Dark]), [Theme.Light, Theme.Dark]);
    assert.deepEqual(exports.roundTripHttpStatusArray([HttpStatus.Ok, HttpStatus.NotFound]), [HttpStatus.Ok, HttpStatus.NotFound]);

    // Struct arrays
    const points = [
        { x: 1.0, y: 2.0, label: "A", optCount: 10, optFlag: true },
        { x: 3.0, y: 4.0, label: "B", optCount: null, optFlag: null }
    ];
    const pointResult = exports.roundTripDataPointArray(points);
    assert.equal(pointResult[0].optCount, 10);
    assert.equal(pointResult[1].optCount, null);

    // Class arrays
    const g1 = new Greeter("Alice");
    const g2 = new Greeter("Bob");
    const gResult = exports.roundTripGreeterArray([g1, g2]);
    assert.equal(gResult[0].name, "Alice");
    assert.equal(gResult[1].greet(), "Hello, Bob!");
    g1.release(); g2.release();
    gResult.forEach(g => g.release());

    // Arrays of optional elements
    assert.deepEqual(exports.roundTripOptionalIntArray([1, null, 3]), [1, null, 3]);
    assert.deepEqual(exports.roundTripOptionalStringArray(["a", null, "b"]), ["a", null, "b"]);
    const optPoint = { x: 1.0, y: 2.0, label: "", optCount: null, optFlag: null };
    const optPoints = exports.roundTripOptionalDataPointArray([optPoint, null]);
    assert.deepEqual(optPoints[0], optPoint);
    assert.equal(optPoints[1], null);
    assert.deepEqual(exports.roundTripOptionalDirectionArray([Direction.North, null]), [Direction.North, null]);
    assert.deepEqual(exports.roundTripOptionalStatusArray([Status.Success, null]), [Status.Success, null]);

    // Optional arrays
    assert.deepEqual(exports.roundTripOptionalIntArrayType([1, 2, 3]), [1, 2, 3]);
    assert.equal(exports.roundTripOptionalIntArrayType(null), null);
    assert.deepEqual(exports.roundTripOptionalStringArrayType(["a", "b"]), ["a", "b"]);
    assert.equal(exports.roundTripOptionalStringArrayType(null), null);
    const og1 = new Greeter("OptGreeter");
    const optGreeterResult = exports.roundTripOptionalGreeterArrayType([og1]);
    assert.equal(optGreeterResult[0].name, "OptGreeter");
    assert.equal(exports.roundTripOptionalGreeterArrayType(null), null);
    og1.release();
    optGreeterResult.forEach(g => g.release());

    // Nested arrays
    assert.deepEqual(exports.roundTripNestedIntArray([[1, 2], [3]]), [[1, 2], [3]]);
    assert.deepEqual(exports.roundTripNestedIntArray([[1, 2], [], [3]]), [[1, 2], [], [3]]);
    assert.deepEqual(exports.roundTripNestedStringArray([["a", "b"], ["c"]]), [["a", "b"], ["c"]]);
    assert.deepEqual(exports.roundTripNestedDoubleArray([[1.5], [2.5]]), [[1.5], [2.5]]);
    assert.deepEqual(exports.roundTripNestedBoolArray([[true], [false]]), [[true], [false]]);
    const nestedPoint = { x: 1.0, y: 2.0, label: "A", optCount: null, optFlag: null };
    assert.deepEqual(exports.roundTripNestedDataPointArray([[nestedPoint]])[0][0], nestedPoint);
    assert.deepEqual(exports.roundTripNestedDirectionArray([[Direction.North], [Direction.South]]), [[Direction.North], [Direction.South]]);
    const ng1 = new Greeter("Nested1");
    const ng2 = new Greeter("Nested2");
    const nestedGreeters = exports.roundTripNestedGreeterArray([[ng1], [ng2]]);
    assert.equal(nestedGreeters[0][0].name, "Nested1");
    assert.equal(nestedGreeters[1][0].greet(), "Hello, Nested2!");
    ng1.release(); ng2.release();
    nestedGreeters.forEach(row => row.forEach(g => g.release()));

    // UnsafePointer-family arrays
    const pointerValues = [1, 4, 1024, 65536, 2147483647];
    assert.deepEqual(exports.roundTripUnsafeRawPointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripUnsafeMutableRawPointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripOpaquePointerArray(pointerValues), pointerValues);
    assert.deepEqual(exports.roundTripUnsafeRawPointerArray([]), []);

    // Default values
    assert.equal(exports.arrayWithDefault(), 6);
    assert.equal(exports.arrayWithDefault([10, 20]), 30);
    assert.equal(exports.arrayWithOptionalDefault(), -1);
    assert.equal(exports.arrayWithOptionalDefault(null), -1);
    assert.equal(exports.arrayWithOptionalDefault([5, 5]), 10);
    assert.equal(exports.arrayMixedDefaults(), "Sum: 30!");
    assert.equal(exports.arrayMixedDefaults("Total"), "Total: 30!");
    assert.equal(exports.arrayMixedDefaults("Total", [1, 2, 3]), "Total: 6!");
    assert.equal(exports.arrayMixedDefaults("Val", [100], "?"), "Val: 100?");
    assert.equal(exports.arrayMixedDefaults(undefined, [5, 5]), "Sum: 10!");
    assert.equal(exports.arrayMixedDefaults(undefined, undefined, "?"), "Sum: 30?");

    const helper1 = new exports.Greeter("Helper1");
    const jsProcessor1 = {
        count: 1, name: "Processor1", optionalTag: null, optionalCount: null,
        direction: null, optionalTheme: null, httpStatus: null, apiResult: null,
        helper: helper1, optionalHelper: null,
        increment(by) { this.count += by; },
        getValue() { return this.count; },
        setLabelElements(a, b) { }, getLabel() { return ""; },
        isEven() { return this.count % 2 === 0; },
        processGreeter(g) { return ""; }, createGreeter() { return new exports.Greeter("P1"); },
        processOptionalGreeter(g) { return ""; }, createOptionalGreeter() { return null; },
        handleAPIResult(r) { }, getAPIResult() { return null; }
    };

    const consumeResult = exports.consumeDataProcessorArrayType([jsProcessor1]);
    assert.equal(consumeResult, 1);

    const processors = [jsProcessor1];
    const result = exports.roundTripDataProcessorArrayType(processors);

    assert.equal(result.length, 1);
    assert.equal(result[0], jsProcessor1);
    assert.equal(result[0].count, 1);

    helper1.release();
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function testProtocolSupport(exports) {
    let processorValue = 0;
    let processorLabel = "";
    let lastAPIResult = null;
    const jsProcessor = {
        count: 0,
        name: "JSProcessor",
        optionalTag: null,
        direction: null,
        optionalTheme: null,
        httpStatus: null,
        get apiResult() { return lastAPIResult; },
        set apiResult(value) { lastAPIResult = value; },
        helper: new exports.Greeter("JSHelper"),
        optionalHelper: null,
        optionalCount: null,
        increment(amount) { processorValue += amount; this.count += amount; },
        getValue() { return processorValue; },
        setLabelElements(labelPrefix, labelSuffix) { processorLabel = labelPrefix + labelSuffix; },
        getLabel() { return processorLabel; },
        isEven() { return processorValue % 2 === 0; },
        processGreeter(greeter) { return `JSProcessor processed: ${greeter.greet()}`; },
        createGreeter() { return new exports.Greeter("JSProcessorGreeter"); },
        processOptionalGreeter(greeter) {
            return greeter ? `JSProcessor processed optional: ${greeter.greet()}` : "JSProcessor received null";
        },
        createOptionalGreeter() { return new exports.Greeter("JSOptionalGreeter"); },
        handleAPIResult(result) { lastAPIResult = result; },
        getAPIResult() { return lastAPIResult; }
    };

    const successResult = { tag: exports.Utilities.Result.Tag.Success, param0: "Operation completed" };
    const failureResult = { tag: exports.Utilities.Result.Tag.Failure, param0: 500 };

    const jsManager = new exports.DataProcessorManager(jsProcessor);

    jsManager.incrementByAmount(4);
    assert.equal(jsManager.getCurrentValue(), 4);
    assert.equal(jsProcessor.count, 4);

    jsManager.setProcessorLabel("Test", "Label");
    assert.equal(jsManager.getProcessorLabel(), "TestLabel");

    assert.equal(jsManager.isProcessorEven(), true);
    jsManager.incrementByAmount(1);
    assert.equal(jsManager.isProcessorEven(), false);

    assert.equal(jsManager.getProcessorOptionalTag(), null);
    jsManager.setProcessorOptionalTag("test-tag");
    assert.equal(jsManager.getProcessorOptionalTag(), "test-tag");
    jsManager.setProcessorOptionalTag("another-tag");
    assert.equal(jsManager.getProcessorOptionalTag(), "another-tag");
    jsManager.setProcessorOptionalTag(null);
    assert.equal(jsManager.getProcessorOptionalTag(), null);

    // Test direct property access for optionalTag
    jsProcessor.optionalTag = "direct-tag";
    assert.equal(jsManager.getProcessorOptionalTag(), "direct-tag");
    assert.equal(jsProcessor.optionalTag, "direct-tag");
    jsProcessor.optionalTag = null;
    assert.equal(jsManager.getProcessorOptionalTag(), null);
    assert.equal(jsProcessor.optionalTag, null);

    assert.equal(jsManager.getProcessorDirection(), null);
    jsManager.setProcessorDirection(exports.Direction.North);
    assert.equal(jsManager.getProcessorDirection(), exports.Direction.North);
    jsManager.setProcessorDirection(exports.Direction.East);
    assert.equal(jsManager.getProcessorDirection(), exports.Direction.East);
    jsManager.setProcessorDirection(null);
    assert.equal(jsManager.getProcessorDirection(), null);

    assert.equal(jsManager.getProcessorTheme(), null);
    jsManager.setProcessorTheme(exports.Theme.Light);
    assert.equal(jsManager.getProcessorTheme(), exports.Theme.Light);
    jsManager.setProcessorTheme(exports.Theme.Dark);
    assert.equal(jsManager.getProcessorTheme(), exports.Theme.Dark);
    jsManager.setProcessorTheme(null);
    assert.equal(jsManager.getProcessorTheme(), null);

    assert.equal(jsManager.getProcessorHttpStatus(), null);
    jsManager.setProcessorHttpStatus(exports.HttpStatus.Ok);
    assert.equal(jsManager.getProcessorHttpStatus(), exports.HttpStatus.Ok);
    jsManager.setProcessorHttpStatus(exports.HttpStatus.NotFound);
    assert.equal(jsManager.getProcessorHttpStatus(), exports.HttpStatus.NotFound);
    jsManager.setProcessorHttpStatus(null);
    assert.equal(jsManager.getProcessorHttpStatus(), null);

    jsProcessor.handleAPIResult(successResult);
    assert.deepEqual(jsProcessor.getAPIResult(), successResult);

    jsProcessor.handleAPIResult(failureResult);
    assert.deepEqual(jsProcessor.getAPIResult(), failureResult);

    jsProcessor.apiResult = successResult;
    assert.deepEqual(jsProcessor.apiResult, successResult);
    jsProcessor.apiResult = null;
    assert.equal(jsProcessor.apiResult, null);
    assert.equal(jsManager.getProcessorAPIResult(), null);

    assert.equal(jsProcessor.helper.name, "JSHelper");
    const newHelper = new exports.Greeter("UpdatedHelper");
    jsProcessor.helper = newHelper;
    assert.equal(jsProcessor.helper.name, "UpdatedHelper");
    assert.equal(jsProcessor.helper.greet(), "Hello, UpdatedHelper!");

    assert.equal(jsProcessor.optionalHelper, null);
    const optHelper = new exports.Greeter("OptHelper");
    jsProcessor.optionalHelper = optHelper;
    assert.equal(jsProcessor.optionalHelper.name, "OptHelper");
    assert.equal(jsProcessor.optionalHelper.greet(), "Hello, OptHelper!");
    jsProcessor.optionalHelper = null;
    assert.equal(jsProcessor.optionalHelper, null);

    assert.equal(jsManager.getProcessorOptionalCount(), null);
    jsManager.setProcessorOptionalCount(42);
    assert.equal(jsManager.getProcessorOptionalCount(), 42);
    jsManager.setProcessorOptionalCount(0);
    assert.equal(jsManager.getProcessorOptionalCount(), 0);
    jsManager.setProcessorOptionalCount(-100);
    assert.equal(jsManager.getProcessorOptionalCount(), -100);
    jsManager.setProcessorOptionalCount(null);
    assert.equal(jsManager.getProcessorOptionalCount(), null);

    assert.equal(jsProcessor.optionalCount, null);
    jsProcessor.optionalCount = 42;
    assert.equal(jsProcessor.optionalCount, 42);
    assert.equal(jsManager.getProcessorOptionalCount(), 42);
    jsProcessor.optionalCount = 0;
    assert.equal(jsProcessor.optionalCount, 0);
    jsProcessor.optionalCount = null;
    assert.equal(jsProcessor.optionalCount, null);

    newHelper.release();
    optHelper.release();
    jsManager.release();

    const swiftProcessor = new exports.SwiftDataProcessor();
    const swiftManager = new exports.DataProcessorManager(swiftProcessor);

    swiftManager.incrementByAmount(10);
    assert.equal(swiftManager.getCurrentValue(), 10);

    swiftManager.setProcessorLabel("Swift", "Label");
    assert.equal(swiftManager.getProcessorLabel(), "SwiftLabel");

    assert.equal(swiftManager.isProcessorEven(), true);
    swiftManager.incrementByAmount(1);
    assert.equal(swiftManager.isProcessorEven(), false);

    assert.equal(swiftManager.getProcessorDirection(), null);
    swiftManager.setProcessorDirection(exports.Direction.South);
    assert.equal(swiftManager.getProcessorDirection(), exports.Direction.South);
    swiftManager.setProcessorDirection(exports.Direction.West);
    assert.equal(swiftManager.getProcessorDirection(), exports.Direction.West);
    swiftManager.setProcessorDirection(null);
    assert.equal(swiftManager.getProcessorDirection(), null);

    assert.equal(swiftManager.getProcessorTheme(), null);
    swiftProcessor.optionalTheme = exports.Theme.Light;
    assert.equal(swiftManager.getProcessorTheme(), exports.Theme.Light);
    swiftManager.setProcessorTheme(exports.Theme.Auto);
    assert.equal(swiftManager.getProcessorTheme(), exports.Theme.Auto);
    swiftManager.setProcessorTheme(exports.Theme.Light);
    assert.equal(swiftManager.getProcessorTheme(), exports.Theme.Light);
    swiftManager.setProcessorTheme(null);
    assert.equal(swiftManager.getProcessorTheme(), null);

    assert.equal(swiftManager.getProcessorHttpStatus(), null);
    swiftManager.setProcessorHttpStatus(exports.HttpStatus.ServerError);
    assert.equal(swiftManager.getProcessorHttpStatus(), exports.HttpStatus.ServerError);
    swiftManager.setProcessorHttpStatus(exports.HttpStatus.Ok);
    assert.equal(swiftManager.getProcessorHttpStatus(), exports.HttpStatus.Ok);
    swiftManager.setProcessorHttpStatus(null);
    assert.equal(swiftManager.getProcessorHttpStatus(), null);

    swiftProcessor.handleAPIResult(successResult);
    assert.deepEqual(swiftProcessor.getAPIResult(), successResult);
    assert.deepEqual(swiftManager.getProcessorAPIResult(), successResult);

    swiftProcessor.handleAPIResult(failureResult);
    assert.deepEqual(swiftProcessor.getAPIResult(), failureResult);
    assert.deepEqual(swiftManager.getProcessorAPIResult(), failureResult);
    swiftManager.setProcessorAPIResult(successResult);
    assert.deepEqual(swiftProcessor.getAPIResult(), successResult);

    swiftManager.release();
    swiftProcessor.release();

    let backupValue = 100;
    const backupProcessor = {
        count: 100,
        name: "BackupProcessor",
        optionalTag: null,
        direction: null,
        optionalTheme: null,
        httpStatus: null,
        apiResult: null,
        helper: new exports.Greeter("BackupHelper"),
        optionalHelper: null,
        optionalCount: null,
        increment(amount) { backupValue += amount; this.count += amount; },
        getValue() { return backupValue; },
        setLabelElements(labelPrefix, labelSuffix) { },
        getLabel() { return "backup"; },
        isEven() { return backupValue % 2 === 0; },
        processGreeter(greeter) { return ""; },
        createGreeter() { return new exports.Greeter("BackupGreeter"); },
        processOptionalGreeter(greeter) { return ""; },
        createOptionalGreeter() { return null; },
        handleAPIResult(result) { },
        getAPIResult() { return { tag: exports.APIResult.Tag.Info }; }
    };

    let mainValue = 0;
    const mainProcessor = {
        count: 0,
        name: "MainProcessor",
        optionalTag: null,
        direction: null,
        optionalTheme: null,
        httpStatus: null,
        apiResult: null,
        helper: new exports.Greeter("MainHelper"),
        optionalHelper: null,
        optionalCount: null,
        increment(amount) { mainValue += amount; this.count += amount; },
        getValue() { return mainValue; },
        setLabelElements(labelPrefix, labelSuffix) { },
        getLabel() { return "main"; },
        isEven() { return mainValue % 2 === 0; },
        processGreeter(greeter) { return ""; },
        createGreeter() { return new exports.Greeter("MainGreeter"); },
        processOptionalGreeter(greeter) { return ""; },
        createOptionalGreeter() { return null; },
        handleAPIResult(result) { },
        getAPIResult() { return { tag: exports.APIResult.Tag.Info }; }
    };

    const managerWithOptional = new exports.DataProcessorManager(mainProcessor);

    assert.equal(managerWithOptional.backupProcessor, null);
    assert.equal(managerWithOptional.hasBackup(), false);
    assert.equal(managerWithOptional.getBackupValue(), null);

    managerWithOptional.backupProcessor = backupProcessor;
    assert.notEqual(managerWithOptional.backupProcessor, null);
    assert.equal(managerWithOptional.hasBackup(), true);

    managerWithOptional.incrementBoth();
    assert.equal(managerWithOptional.getCurrentValue(), 1);
    assert.equal(managerWithOptional.getBackupValue(), 101);

    managerWithOptional.incrementBoth();
    assert.equal(managerWithOptional.getCurrentValue(), 2);
    assert.equal(managerWithOptional.getBackupValue(), 102);

    managerWithOptional.backupProcessor = null;
    assert.equal(managerWithOptional.backupProcessor, null);
    assert.equal(managerWithOptional.hasBackup(), false);

    managerWithOptional.incrementBoth();
    assert.equal(managerWithOptional.getCurrentValue(), 3);
    assert.equal(managerWithOptional.getBackupValue(), null);

    const swiftBackup = new exports.SwiftDataProcessor();
    managerWithOptional.backupProcessor = swiftBackup;

    assert.equal(managerWithOptional.hasBackup(), true);
    assert.equal(managerWithOptional.getBackupValue(), 0);

    managerWithOptional.incrementBoth();
    assert.equal(managerWithOptional.getCurrentValue(), 4);
    assert.equal(managerWithOptional.getBackupValue(), 1);

    managerWithOptional.release();
    swiftBackup.release();
}
