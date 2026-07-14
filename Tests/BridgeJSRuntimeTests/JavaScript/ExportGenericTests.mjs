// @ts-check

import assert from 'node:assert';
import { BridgeTypes } from '../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.js';

/** @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports */
export function runExportGenericTests(exports) {
    // The import-direction tests sweep every supported T through the same codecs;
    // the export direction checks representatives of each codec family.
    assert.equal(exports.exportGenericIdentity(42, BridgeTypes.Int), 42);
    assert.equal(exports.exportGenericIdentity(-7, BridgeTypes.Int), -7);
    assert.equal(exports.exportGenericIdentity(true, BridgeTypes.Bool), true);
    assert.equal(exports.exportGenericIdentity(3000000000, BridgeTypes.UInt32), 3000000000);
    assert.equal(exports.exportGenericIdentity(-9000000000n, BridgeTypes.Int64), -9000000000n);
    assert.equal(exports.exportGenericIdentity(Math.fround(1.25), BridgeTypes.Float), Math.fround(1.25));
    assert.equal(exports.exportGenericIdentity(3.5, BridgeTypes.Double), 3.5);
    assert.equal(exports.exportGenericIdentity("hi", BridgeTypes.String), "hi");
    assert.equal(exports.exportGenericIdentity("", BridgeTypes.String), "");

    assert.equal(exports.exportGenericIdentity(3.5, BridgeTypes.JSValue), 3.5);
    assert.equal(exports.exportGenericIdentity("hey", BridgeTypes.JSValue), "hey");
    assert.equal(exports.exportGenericIdentity(true, BridgeTypes.JSValue), true);
    assert.equal(exports.exportGenericIdentity(null, BridgeTypes.JSValue), null);
    assert.equal(exports.exportGenericIdentity(undefined, BridgeTypes.JSValue), undefined);
    const jsValueObject = exports.exportGenericIdentity({ tag: 5 }, BridgeTypes.JSValue);
    assert.equal(jsValueObject.tag, 5);

    assert.equal(exports.exportGenericIdentity(0, BridgeTypes.GenericRTColor), 0);
    assert.equal(exports.exportGenericIdentity(2, BridgeTypes.GenericRTColor), 2);
    assert.equal(exports.exportGenericIdentity("dark", BridgeTypes.GenericRTMode), "dark");
    assert.equal(exports.exportGenericIdentity(9, BridgeTypes.GenericRTLevel), 9);

    const outcome = exports.makeExportGenericOutcome(42);
    const sameOutcome = exports.exportGenericIdentity(outcome, BridgeTypes.ExportGenericOutcome);
    assert.equal(exports.exportGenericOutcomeValue(sameOutcome), 42);

    const point = exports.exportGenericIdentity({ x: 1, y: 2 }, BridgeTypes.ExportGenericPoint);
    assert.equal(point.x, 1);
    assert.equal(point.y, 2);

    assert.equal(exports.exportGenericEcho(9, 0, BridgeTypes.Int), 9);
    assert.equal(exports.exportGenericEcho(-3, 1, BridgeTypes.Int), -3);
    assert.equal(exports.exportGenericEcho("tagged", 5, BridgeTypes.String), "tagged");

    const echoedPoint = exports.exportGenericEcho({ x: 4, y: 5 }, 7, BridgeTypes.ExportGenericPoint);
    assert.equal(echoedPoint.x, 4);
    assert.equal(echoedPoint.y, 5);

    assert.equal(exports.exportGenericPickFirst(1, 2, BridgeTypes.Int), 1);
    assert.equal(exports.exportGenericPickSecond(1, 2, BridgeTypes.Int), 2);

    assert.deepEqual(exports.exportGenericArrayIdentity([1, 2, 3], BridgeTypes.Int), [1, 2, 3]);
    assert.deepEqual(exports.exportGenericArrayIdentity(["a", "b"], BridgeTypes.String), ["a", "b"]);
    assert.deepEqual(exports.exportGenericArrayIdentity([], BridgeTypes.Int), []);
    assert.equal(exports.exportGenericOptionalIdentity(7, BridgeTypes.Int), 7);
    assert.equal(exports.exportGenericOptionalIdentity(null, BridgeTypes.Int), null);
    assert.equal(exports.exportGenericOptionalIdentity("hi", BridgeTypes.String), "hi");
    assert.deepEqual(exports.exportGenericDictIdentity({ x: 1, y: 2 }, BridgeTypes.Int), { x: 1, y: 2 });

    // Stack ordering with side effects: struct + scalar + generic, across a scalar and a struct value.
    assert.equal(exports.exportGenericWrapPointAndTag({ x: 1, y: 1 }, 7, "z", BridgeTypes.String), "z");
    assert.equal(exports.lastTag(), 7);
    assert.equal(exports.lastWrappedPointX(), 1);
    assert.equal(exports.lastWrappedPointY(), 1);

    const wrappedStruct = exports.exportGenericWrapPointAndTag({ x: 5, y: 6 }, 8, { x: 7, y: 8 }, BridgeTypes.ExportGenericPoint);
    assert.equal(wrappedStruct.x, 7);
    assert.equal(wrappedStruct.y, 8);
    assert.equal(exports.lastWrappedPointX(), 5);
    assert.equal(exports.lastWrappedPointY(), 6);
    assert.equal(exports.lastTag(), 8);

    // Multiple distinct generic parameters: T and U cross independently via their own codecs.
    assert.equal(exports.exportGenericCombineFirst(7, "hello", BridgeTypes.Int, BridgeTypes.String), 7);
    assert.equal(exports.exportGenericCombineSecond(7, "hello", BridgeTypes.Int, BridgeTypes.String), "hello");

    // Swapped concrete types prove the type ids and codecs are not mixed up.
    assert.equal(exports.exportGenericCombineFirst("hello", 7, BridgeTypes.String, BridgeTypes.Int), "hello");
    assert.equal(exports.exportGenericCombineSecond("hello", 7, BridgeTypes.String, BridgeTypes.Int), 7);

    // Struct as one of the generics mixed with a scalar.
    const combinedStructFirst = exports.exportGenericCombineFirst(
        { x: 1, y: 2 },
        9,
        BridgeTypes.ExportGenericPoint,
        BridgeTypes.Int
    );
    assert.equal(combinedStructFirst.x, 1);
    assert.equal(combinedStructFirst.y, 2);
    assert.equal(exports.exportGenericCombineSecond({ x: 1, y: 2 }, 9, BridgeTypes.ExportGenericPoint, BridgeTypes.Int), 9);

    // T and U are the SAME concrete type but distinct values: ensure no swap.
    assert.equal(exports.exportGenericCombineFirst(1, 2, BridgeTypes.Int, BridgeTypes.Int), 1);
    assert.equal(exports.exportGenericCombineSecond(1, 2, BridgeTypes.Int, BridgeTypes.Int), 2);

    // Three distinct generic parameters prove the nested-open chain.
    assert.equal(
        exports.exportGenericCombineTripleLast(11, "two", true, BridgeTypes.Int, BridgeTypes.String, BridgeTypes.Bool),
        true
    );

    const box = new exports.ExportGenericBox(123);
    assert.equal(box.get(), 123);
    const sameBox = exports.exportGenericIdentity(box, BridgeTypes.ExportGenericBox);
    assert.equal(sameBox.get(), 123);
    sameBox.release();

    const firstBox = new exports.ExportGenericBox(7);
    const secondBox = new exports.ExportGenericBox(9);
    const pickedFirstBox = exports.exportGenericPickFirst(firstBox, secondBox, BridgeTypes.ExportGenericBox);
    assert.equal(pickedFirstBox.get(), 7);
    const pickedSecondBox = exports.exportGenericPickSecond(firstBox, secondBox, BridgeTypes.ExportGenericBox);
    assert.equal(pickedSecondBox.get(), 9);
    pickedFirstBox.release();
    pickedSecondBox.release();
    firstBox.release();
    secondBox.release();
    box.release();

    const methodBox = new exports.ExportGenericMethodBox();
    assert.equal(methodBox.echo(42, BridgeTypes.Int), 42);
    assert.equal(methodBox.echo(-7, BridgeTypes.Int), -7);
    assert.equal(methodBox.echo("hi", BridgeTypes.String), "hi");
    assert.equal(methodBox.echo(true, BridgeTypes.Bool), true);
    assert.equal(methodBox.echo(false, BridgeTypes.Bool), false);

    const methodOutcome = exports.makeExportGenericOutcome(77);
    const echoedOutcome = methodBox.echo(methodOutcome, BridgeTypes.ExportGenericOutcome);
    assert.equal(exports.exportGenericOutcomeValue(echoedOutcome), 77);

    assert.equal(methodBox.combine(7, "hello", BridgeTypes.Int, BridgeTypes.String), "hello");
    assert.equal(methodBox.combine("hello", 7, BridgeTypes.String, BridgeTypes.Int), 7);
    methodBox.release();

    assert.deepEqual(exports.ExportGenericMethodBox.wrapArray(5, BridgeTypes.Int), [5]);
    assert.deepEqual(exports.ExportGenericMethodBox.wrapArray("x", BridgeTypes.String), ["x"]);
    assert.deepEqual(exports.ExportGenericMethodBox.wrapArray(true, BridgeTypes.Bool), [true]);

    const methodPair = exports.ExportGenericMethodPair.init();
    assert.equal(methodPair.first(9, BridgeTypes.Int), 9);
    assert.equal(methodPair.first("p", BridgeTypes.String), "p");
    assert.equal(methodPair.first(true, BridgeTypes.Bool), true);

    assert.equal(methodPair.maybe(42, true, BridgeTypes.Int), 42);
    assert.equal(methodPair.maybe(42, false, BridgeTypes.Int), null);
    assert.equal(methodPair.maybe("present", true, BridgeTypes.String), "present");
    assert.equal(methodPair.maybe("present", false, BridgeTypes.String), null);

    assert.deepEqual(methodPair.dict(7, BridgeTypes.Int), { value: 7 });
    assert.deepEqual(methodPair.dict("d", BridgeTypes.String), { value: "d" });

    assert.deepEqual(exports.ExportGenericMethodPair.wrap(3, BridgeTypes.Int), [3]);
    assert.deepEqual(exports.ExportGenericMethodPair.wrap("q", BridgeTypes.String), ["q"]);

    assert.equal(exports.ExportGenericMethodFactory.one(11, BridgeTypes.Int), 11);
    assert.equal(exports.ExportGenericMethodFactory.one("e", BridgeTypes.String), "e");
    assert.equal(exports.ExportGenericMethodFactory.one(false, BridgeTypes.Bool), false);

    assert.equal(exports.ExportGenericMethodNamespace.make(13, BridgeTypes.Int), 13);
    assert.equal(exports.ExportGenericMethodNamespace.make("n", BridgeTypes.String), "n");
    assert.equal(exports.ExportGenericMethodNamespace.make(true, BridgeTypes.Bool), true);
}
