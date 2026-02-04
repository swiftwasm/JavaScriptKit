/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["ClosureSupportImports"]}
 */
export function getImports(importsContext) {
    return {
        jsApplyVoid: (fn) => {
            fn();
        },
        jsApplyBool: (fn) => {
            return fn();
        },
        jsApplyInt: (v, fn) => {
            return fn(v);
        },
        jsApplyDouble: (v, fn) => {
            return fn(v);
        },
        jsApplyString: (v, fn) => {
            return fn(v);
        },
        jsApplyJSValue: (v, fn) => {
            return fn(v);
        },
        jsApplyJSObject: (v, fn) => {
            return fn(v);
        },
        jsApplyArrayInt: (v, fn) => {
            return fn(v);
        },
        jsApplyArrayDouble: (v, fn) => {
            return fn(v);
        },
        jsApplyArrayString: (v, fn) => {
            return fn(v);
        },
        jsApplyArrayJSValue: (v, fn) => {
            return fn(v);
        },
        jsApplyArrayJSObject: (v, fn) => {
            return fn(v);
        },
        jsMakeIntToInt: (base) => {
            return (v) => base + v;
        },
        jsMakeDoubleToDouble: (base) => {
            return (v) => base + v;
        },
        jsMakeStringToString: (prefix) => {
            return (name) => `${prefix}${name}`;
        },
        jsCallTwice: (v, fn) => {
            fn(v);
            fn(v);
            return v;
        },
        jsCallBinary: (fn) => fn(1, 2),
        jsCallTriple: (fn) => fn(1, 2, 3),
        jsCallTripleMut: (fn) => {
            fn(1, 2, 3);
            fn(4, 5, 6);
        },
        jsCallTwiceMut: (fn) => {
            fn();
            fn();
        },
        jsHeapCount: () => {
            globalThis.gc?.();
            return globalThis.swift?.memory?._heapValueById?.size ?? -1;
        },
        jsCallAfterRelease: (fn) => {
            try {
                fn();
                fn();
                return "null";
            } catch (e) {
                return e?.message ?? "error";
            }
        },
        jsOptionalInvoke: (fn) => {
            if (fn == null) { return false; }
            return fn();
        },
        jsStoreClosure: (fn) => { globalThis.__storedClosure = fn; },
        jsCallStoredClosure: () => { return globalThis.__storedClosure?.(); },

        runJsClosureSupportTests: () => {
            const exports = importsContext.getExports();
            if (!exports) { throw new Error("No exports!?"); }
            runJsClosureSupportTests(exports);
        },
    };
}

import assert from "node:assert";

/** @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
export function runJsClosureSupportTests(exports) {
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


    const intToInt = exports.ClosureSupportExports.makeIntToInt(10);
    assert.equal(intToInt(0), 10);
    assert.equal(intToInt(32), 42);

    const doubleToDouble = exports.ClosureSupportExports.makeDoubleToDouble(10.0);
    assert.equal(doubleToDouble(0.0), 10.0);
    assert.equal(doubleToDouble(32.0), 42.0);

    const stringToString = exports.ClosureSupportExports.makeStringToString("Hello, ");
    assert.equal(stringToString("world!"), "Hello, world!");

    const jsIntToInt = exports.ClosureSupportExports.makeJSIntToInt(10);
    assert.equal(jsIntToInt(0), 10);
    assert.equal(jsIntToInt(32), 42);

    const jsDoubleToDouble = exports.ClosureSupportExports.makeJSDoubleToDouble(10.0);
    assert.equal(jsDoubleToDouble(0.0), 10.0);
    assert.equal(jsDoubleToDouble(32.0), 42.0);

    const jsStringToString = exports.ClosureSupportExports.makeJSStringToString("Hello, ");
    assert.equal(jsStringToString("world!"), "Hello, world!");
}
