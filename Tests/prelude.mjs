// @ts-check

import {
    DirectionValues, StatusValues, ThemeValues, HttpStatusValues, TSDirection, TSTheme, APIResultValues, ComplexResultValues, APIOptionalResultValues, StaticCalculatorValues, StaticPropertyEnumValues, PrecisionValues, TypedPayloadResultValues, AllTypesResultValues, OptionalAllTypesResultValues
} from '../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.js';
import { ImportedFoo } from './BridgeJSRuntimeTests/JavaScript/Types.mjs';
import { runJsOptionalSupportTests } from './BridgeJSRuntimeTests/JavaScript/OptionalSupportTests.mjs';
import { getImports as getClosureSupportImports } from './BridgeJSRuntimeTests/JavaScript/ClosureSupportTests.mjs';
import { getImports as getSwiftClassSupportImports } from './BridgeJSRuntimeTests/JavaScript/SwiftClassSupportTests.mjs';
import { getImports as getOptionalSupportImports } from './BridgeJSRuntimeTests/JavaScript/OptionalSupportTests.mjs';
import { getImports as getArraySupportImports, ArrayElementObject } from './BridgeJSRuntimeTests/JavaScript/ArraySupportTests.mjs';
import { getImports as getDictionarySupportImports } from './BridgeJSRuntimeTests/JavaScript/DictionarySupportTests.mjs';
import { getImports as getDefaultArgumentImports } from './BridgeJSRuntimeTests/JavaScript/DefaultArgumentTests.mjs';
import { getImports as getJSClassSupportImports, JSClassWithArrayMembers } from './BridgeJSRuntimeTests/JavaScript/JSClassSupportTests.mjs';

/** @type {import('../.build/plugins/PackageToJS/outputs/PackageTests/test.d.ts').SetupOptionsFn} */
export async function setupOptions(options, context) {
    Error.stackTraceLimit = 100;
    setupTestGlobals(globalThis);

    class StaticBox {
        constructor(value) {
            this._value = value;
        }
        value() {
            return this._value;
        }
        static create(value) {
            return new StaticBox(value);
        }
        static value() {
            return 99;
        }
        static makeDefault() {
            return new StaticBox(0);
        }
        static ["with-dashes"]() {
            return new StaticBox(7);
        }
    }

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
                "jsRoundTripJSValue": (v) => {
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
                "jsEchoJSValue": (v) => {
                    return v;
                },
                "$jsWeirdFunction": () => {
                    return 42;
                },
                ArrayElementObject,
                JSClassWithArrayMembers,
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
                StaticBox,
                Foo: ImportedFoo,
                runAsyncWorks: async () => {
                    const exports = importsContext.getExports();
                    if (!exports) {
                        throw new Error("No exports!?");
                    }
                    BridgeJSRuntimeTests_runAsyncWorks(exports);
                    return;
                },
                jsTranslatePoint: (point, dx, dy) => {
                    return { x: (point.x | 0) + (dx | 0), y: (point.y | 0) + (dy | 0) };
                },
                roundTripArrayMembers: (value) => {
                    return value;
                },
                runJsOptionalSupportTests: () => {
                    const exports = importsContext.getExports();
                    if (!exports) { throw new Error("No exports!?"); }
                    runJsOptionalSupportTests(exports);
                },
                ClosureSupportImports: getClosureSupportImports(importsContext),
                SwiftClassSupportImports: getSwiftClassSupportImports(importsContext),
                OptionalSupportImports: getOptionalSupportImports(importsContext),
                ArraySupportImports: getArraySupportImports(importsContext),
                DictionarySupportImports: getDictionarySupportImports(importsContext),
                DefaultArgumentImports: getDefaultArgumentImports(importsContext),
                JSClassSupportImports: getJSClassSupportImports(importsContext),
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
    const dict = { a: 1, b: 2 };
    assert.deepEqual(exports.roundTripDictionaryExport(dict), dict);
    const optDict = { hello: "world" };
    assert.deepEqual(exports.roundTripOptionalDictionaryExport(optDict), optDict);
    assert.equal(exports.roundTripOptionalDictionaryExport(null), null);
    const arrayStruct = { ints: [1, 2, 3], optStrings: ["a", "b"] };
    const arrayStructRoundTrip = exports.roundTripArrayMembers(arrayStruct);
    assert.deepEqual(arrayStructRoundTrip.ints, [1, 2, 3]);
    assert.deepEqual(arrayStructRoundTrip.optStrings, ["a", "b"]);
    assert.equal(exports.arrayMembersSum(arrayStruct, [10, 20]), 30);
    assert.equal(exports.arrayMembersFirst(arrayStruct, ["x", "y"]), "x");
    const jsValueArray = [true, 42, "ok", { nested: 1 }, null, undefined];
    assert.deepEqual(exports.roundTripOptionalJSValueArray(jsValueArray), jsValueArray);
    assert.equal(exports.roundTripOptionalJSValueArray(null), null);

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

    // release should be idempotent
    const g3 = new exports.Greeter("Idempotent");
    g3.release();
    g3.release();

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

    const symbolValue = Symbol("roundTrip");
    const bigIntValue = 12345678901234567890n;
    const objectValue = { nested: true };
    const jsValues = [true, 42, "hello", objectValue, null, undefined, symbolValue, bigIntValue];
    for (const value of jsValues) {
        const result = exports.roundTripJSValue(value);
        assert.strictEqual(result, value);
    }

    assert.strictEqual(exports.roundTripOptionalJSValue(null), null);
    assert.strictEqual(exports.roundTripOptionalJSValue(undefined), null);
    assert.strictEqual(exports.roundTripOptionalJSValue(objectValue), objectValue);
    assert.strictEqual(exports.roundTripOptionalJSValue(symbolValue), symbolValue);

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
    assert.equal(converter.precision, 2);
    converter.precision = 5;
    assert.equal(converter.precision, 5);
    assert.equal(converter.toString(42), "42");
    assert.equal(converter.toString(123), "123");
    converter.release();

    const createdConverter = exports.createConverter();
    assert.equal(createdConverter.toString(99), "99");
    assert.equal(exports.useConverter(createdConverter, 55), "55");
    createdConverter.release();

    const uuid = exports.createUUID("11111111-2222-3333-4444-555555555555");
    assert.equal(uuid.uuidString(), "11111111-2222-3333-4444-555555555555");
    const roundTrippedUUID = exports.roundTripUUID(uuid);
    assert.equal(roundTrippedUUID.uuidString(), "11111111-2222-3333-4444-555555555555");
    roundTrippedUUID.release();
    uuid.release();

    const createdServer = exports.createHTTPServer();
    createdServer.call(exports.Networking.API.Method.Get);
    createdServer.release();

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

    // TypedPayloadResult — rawValueEnum and caseEnum as associated value payloads
    assert.equal(exports.Precision.Rough, 0.1);
    assert.equal(exports.Precision.Fine, 0.001);

    const tpr_precision = { tag: exports.TypedPayloadResult.Tag.Precision, param0: Math.fround(0.1) };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_precision), tpr_precision);

    const tpr_direction = { tag: exports.TypedPayloadResult.Tag.Direction, param0: exports.Direction.North };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_direction), tpr_direction);

    const tpr_dirSouth = { tag: exports.TypedPayloadResult.Tag.Direction, param0: exports.Direction.South };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_dirSouth), tpr_dirSouth);

    const tpr_optPrecisionSome = { tag: exports.TypedPayloadResult.Tag.OptPrecision, param0: Math.fround(0.001) };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_optPrecisionSome), tpr_optPrecisionSome);

    const tpr_optPrecisionNull = { tag: exports.TypedPayloadResult.Tag.OptPrecision, param0: null };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_optPrecisionNull), tpr_optPrecisionNull);

    const tpr_optDirectionSome = { tag: exports.TypedPayloadResult.Tag.OptDirection, param0: exports.Direction.East };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_optDirectionSome), tpr_optDirectionSome);

    const tpr_optDirectionNull = { tag: exports.TypedPayloadResult.Tag.OptDirection, param0: null };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_optDirectionNull), tpr_optDirectionNull);

    const tpr_empty = { tag: exports.TypedPayloadResult.Tag.Empty };
    assert.deepEqual(exports.roundTripTypedPayloadResult(tpr_empty), tpr_empty);

    // AllTypesResult — struct, class, JSObject, nested enum, array as associated value payloads
    const atr_struct = { tag: AllTypesResultValues.Tag.StructPayload, param0: { street: "100 Main St", city: "Boston", zipCode: 2101 } };
    assert.deepEqual(exports.roundTripAllTypesResult(atr_struct), atr_struct);

    const atr_class = { tag: AllTypesResultValues.Tag.ClassPayload, param0: new exports.Greeter("EnumUser") };
    const atr_class_result = exports.roundTripAllTypesResult(atr_class);
    assert.equal(atr_class_result.tag, AllTypesResultValues.Tag.ClassPayload);
    assert.equal(atr_class_result.param0.name, "EnumUser");

    const atr_jsObject = { tag: AllTypesResultValues.Tag.JsObjectPayload, param0: { custom: "data", value: 42 } };
    const atr_jsObject_result = exports.roundTripAllTypesResult(atr_jsObject);
    assert.equal(atr_jsObject_result.tag, AllTypesResultValues.Tag.JsObjectPayload);
    assert.equal(atr_jsObject_result.param0.custom, "data");
    assert.equal(atr_jsObject_result.param0.value, 42);

    const atr_nestedEnum = { tag: AllTypesResultValues.Tag.NestedEnum, param0: { tag: APIResultValues.Tag.Success, param0: "nested!" } };
    assert.deepEqual(exports.roundTripAllTypesResult(atr_nestedEnum), atr_nestedEnum);

    const atr_array = { tag: AllTypesResultValues.Tag.ArrayPayload, param0: [10, 20, 30] };
    assert.deepEqual(exports.roundTripAllTypesResult(atr_array), atr_array);

    const atr_jsClass = { tag: AllTypesResultValues.Tag.JsClassPayload, param0: new ImportedFoo("enumFoo") };
    const atr_jsClass_result = exports.roundTripAllTypesResult(atr_jsClass);
    assert.equal(atr_jsClass_result.tag, AllTypesResultValues.Tag.JsClassPayload);
    assert.equal(atr_jsClass_result.param0.value, "enumFoo");

    const atr_empty = { tag: AllTypesResultValues.Tag.Empty };
    assert.deepEqual(exports.roundTripAllTypesResult(atr_empty), atr_empty);

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

    testProtocolSupport(exports);
}

/** @param {import('./../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
function testStructSupport(exports) {
    const data1 = { x: 1.5, y: 2.5, label: "Point", optCount: 42, optFlag: true };
    assert.deepEqual(exports.roundTripDataPoint(data1), data1);
    const data2 = { x: 0.0, y: 0.0, label: "", optCount: null, optFlag: null };
    assert.deepEqual(exports.roundTripDataPoint(data2), data2);

    const publicPoint = { x: 9, y: -3 };
    assert.deepEqual(exports.roundTripPublicPoint(publicPoint), publicPoint);

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
    assert.equal(exports.MathOperations.subtract(10.0), 5.0);
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

    // Struct with JSObject field
    const containerObj1 = { value: "hello", nested: { x: 1 } };
    const containerObj2 = { items: [1, 2, 3] };
    const container1 = { object: containerObj1, optionalObject: containerObj2 };
    const containerResult1 = exports.roundTripJSObjectContainer(container1);
    assert.equal(containerResult1.object, containerObj1);
    assert.equal(containerResult1.optionalObject, containerObj2);

    const container2 = { object: containerObj1, optionalObject: null };
    const containerResult2 = exports.roundTripJSObjectContainer(container2);
    assert.equal(containerResult2.object, containerObj1);
    assert.equal(containerResult2.optionalObject, null);

    // Struct with @JSClass field
    const foo1 = new ImportedFoo("first");
    const foo2 = new ImportedFoo("second");
    const fooContainer1 = { foo: foo1, optionalFoo: foo2 };
    const fooContainerResult1 = exports.roundTripFooContainer(fooContainer1);
    assert.equal(fooContainerResult1.foo.value, "first");
    assert.equal(fooContainerResult1.optionalFoo.value, "second");

    const fooContainer2 = { foo: foo1, optionalFoo: null };
    const fooContainerResult2 = exports.roundTripFooContainer(fooContainer2);
    assert.equal(fooContainerResult2.foo.value, "first");
    assert.equal(fooContainerResult2.optionalFoo, null);
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
