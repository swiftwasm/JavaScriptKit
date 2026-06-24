// @ts-check
import assert from "node:assert";

export class Surface {
    constructor(label) {
        this.label = label;
    }
};

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["AliasImports"]}
 */
export function getImports(importsContext) {
    return {
        jsRoundTripTagged: (value) => {
            return value;
        },
        jsRoundTripOptionalTagged: (value) => {
            return value ?? null;
        },
        jsProduceOptionalCanvas: (label) => {
            if (label === null || label === undefined) return null;
            return new Surface(label);
        },
        jsRoundTripAliasedTags: (values) => {
            return values.map((tag) => tag ?? null);
        },
        jsRoundTripPolygon: (value) => {
            return value;
        },
        jsRoundTripCoordinate: (value) => {
            return { ...value };
        },
        jsRoundTripUserId: (value) => {
            return value;
        },
        jsRoundTripOptionalUserId: (value) => {
            return value ?? null;
        },
    };
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
export function runAliasWorks(exports) {
    runBasicRoundTrip(exports);
    runOptional(exports);
    runMethodsOnTarget(exports);
    runStaticReturn(exports);
    runMultipleAliases(exports);
    runArrays(exports);
    runThrows(exports);
    runJSValueAlias(exports);
    runScalarAlias(exports);
    runClosureWithAliasParameter(exports);
    runOptionalInArray(exports);
    runClassPropertyAndInitWithAlias(exports);
    runAssociatedValueEnumPayload(exports);
    runStructToStructAlias(exports);
    runStructToEnumAlias(exports);
    runEnumToClassAlias(exports);
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runBasicRoundTrip(exports) {
    const seed = new exports.PolygonReference([1, 2, 3], "seed");
    assert.equal(seed.vertexCount(), 3);
    assert.equal(seed.summary(), "seed(3)");

    const roundtrip = exports.roundTripPolygon(seed);
    assert.equal(roundtrip.vertexCount(), 3);
    assert.equal(roundtrip.summary(), "seed(3)");

    assert.equal(exports.polygonVertexCount(seed), 3);

    const appended = exports.appendVertex(seed, 4);
    assert.equal(appended.vertexCount(), 4);
    assert.equal(appended.summary(), "seed(4)");

    seed.release();
    roundtrip.release();
    appended.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runOptional(exports) {
    assert.equal(exports.optionalRoundTripPolygon(null), null);

    const original = new exports.PolygonReference([7, 8, 9], "opt");
    const echoed = exports.optionalRoundTripPolygon(original);
    assert.notEqual(echoed, null);
    if (echoed) {
        assert.equal(echoed.vertexCount(), 3);
        echoed.release();
    }
    original.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runMethodsOnTarget(exports) {
    const a = new exports.PolygonReference([1, 2], "a");

    const snap = a.snapshot();
    assert.equal(snap.summary(), "a(2)");

    const b = new exports.PolygonReference([3, 4, 5], "b");
    const merged = a.merge(b);
    assert.equal(merged.vertexCount(), 5);
    assert.equal(merged.summary(), "a(5)");

    a.release();
    b.release();
    snap.release();
    merged.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runStaticReturn(exports) {
    const o = exports.PolygonReference.origin("o");
    assert.equal(o.vertexCount(), 0);
    assert.equal(o.summary(), "o(0)");
    o.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runMultipleAliases(exports) {
    const tag = exports.makeTag("hello");
    assert.equal(tag.describe(), "tag:hello");
    tag.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runArrays(exports) {
    const a = new exports.PolygonReference([1], "a");
    const b = new exports.PolygonReference([2, 3], "b");
    const c = new exports.PolygonReference([4, 5, 6], "c");

    const roundtripped = exports.roundTripPolygonArray([a, b, c]);
    assert.equal(roundtripped.length, 3);
    assert.equal(roundtripped[0].vertexCount(), 1);
    assert.equal(roundtripped[1].vertexCount(), 2);
    assert.equal(roundtripped[2].vertexCount(), 3);
    assert.equal(roundtripped[0].summary(), "a(1)");
    assert.equal(roundtripped[1].summary(), "b(2)");
    assert.equal(roundtripped[2].summary(), "c(3)");

    const combined = exports.concatPolygons([a, b, c]);
    assert.equal(combined.vertexCount(), 6);
    assert.equal(combined.summary(), "concat(6)");

    const empty = exports.roundTripPolygonArray([]);
    assert.equal(empty.length, 0);

    const split = exports.splitPolygon(combined);
    assert.equal(split.length, 6);
    for (const piece of split) {
        assert.equal(piece.vertexCount(), 1);
        piece.release();
    }

    a.release();
    b.release();
    c.release();
    combined.release();
    for (const r of roundtripped) r.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runThrows(exports) {
    const valid = new exports.PolygonReference([1, 2], "v");
    const echoed = exports.validatePolygon(valid);
    assert.equal(echoed.summary(), "v(2)");
    echoed.release();
    valid.release();

    const empty = new exports.PolygonReference([], "empty");
    assert.throws(() => exports.validatePolygon(empty), /empty polygon/);
    empty.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runJSValueAlias(exports) {
    assert.equal(exports.roundTripBoxed(42), 42);
    assert.equal(exports.roundTripBoxed("hello"), "hello");
    assert.deepStrictEqual(exports.roundTripBoxed({ a: 1 }), { a: 1 });

    assert.equal(exports.roundTripOptionalBoxed(null), null);
    assert.equal(exports.roundTripOptionalBoxed("present"), "present");
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runScalarAlias(exports) {
    assert.equal(exports.roundTripUserId(42), 42);
    assert.equal(exports.roundTripUserId(-1), -1);

    assert.equal(exports.roundTripOptionalUserId(null), null);
    assert.equal(exports.roundTripOptionalUserId(0), 0);
    assert.equal(exports.roundTripOptionalUserId(7), 7);

    assert.deepStrictEqual(exports.roundTripUserIdArray([]), []);
    assert.deepStrictEqual(exports.roundTripUserIdArray([1, 2, 3]), [1, 2, 3]);
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runClosureWithAliasParameter(exports) {
    const inspector = exports.makePolygonInspector();
    const poly = new exports.PolygonReference([10, 20, 30, 40], "inspect");
    assert.equal(inspector(poly), 4);
    poly.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runOptionalInArray(exports) {
    const a = new exports.PolygonReference([1], "a");
    const b = new exports.PolygonReference([2, 3], "b");

    const echoed = exports.roundTripOptionalPolygonArray([a, null, b, null]);
    assert.equal(echoed.length, 4);
    assert.notEqual(echoed[0], null);
    assert.equal(echoed[1], null);
    assert.notEqual(echoed[2], null);
    assert.equal(echoed[3], null);
    if (echoed[0]) {
        assert.equal(echoed[0].vertexCount(), 1);
    }
    if (echoed[2]) {
        assert.equal(echoed[2].vertexCount(), 2);
    }

    a.release();
    b.release();
    for (const e of echoed) {
        if (e) {
            e.release();
        }
    }
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runClassPropertyAndInitWithAlias(exports) {
    const made = exports.makeTagHolder("origin", 1);
    assert.equal(made.describe(), "holder(origin, v1)");
    const initial = made.tag;
    assert.equal(initial.describe(), "tag:origin");

    const replacement = exports.makeTag("renamed");
    made.tag = replacement;
    assert.equal(made.describe(), "holder(renamed, v1)");
    made.version = 7;
    assert.equal(made.describe(), "holder(renamed, v7)");

    const fresh = exports.makeTag("constructed");
    const ctor = new exports.TagHolderReference(fresh, 99);
    assert.equal(ctor.describe(), "holder(constructed, v99)");

    initial.release();
    replacement.release();
    fresh.release();
    made.release();
    ctor.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runAssociatedValueEnumPayload(exports) {
    const poly = new exports.PolygonReference([1, 2, 3], "shape");
    const wrapped = exports.makeShapePolygon(poly);
    assert.equal(wrapped.tag, exports.Shape.Tag.Polygon);
    if (wrapped.tag === exports.Shape.Tag.Polygon) {
        assert.equal(wrapped.param0.vertexCount(), 3);
    }

    const echoed = exports.roundTripShape(wrapped);
    assert.equal(echoed.tag, exports.Shape.Tag.Polygon);
    if (echoed.tag === exports.Shape.Tag.Polygon) {
        assert.equal(echoed.param0.vertexCount(), 3);
        echoed.param0.release();
    }

    const empty = exports.makeShapeEmpty();
    assert.equal(empty.tag, exports.Shape.Tag.Empty);
    const emptyEcho = exports.roundTripShape(empty);
    assert.equal(emptyEcho.tag, exports.Shape.Tag.Empty);

    if (wrapped.tag === exports.Shape.Tag.Polygon) {
        wrapped.param0.release();
    }
    poly.release();
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runStructToStructAlias(exports) {
    const seed = { latitude: 45.5, longitude: -73.5 };
    const echoed = exports.roundTripCoordinate(seed);
    assert.deepStrictEqual(echoed, seed);
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runStructToEnumAlias(exports) {
    const made = exports.makeAlert(exports.Severity.Warning);
    assert.equal(made, exports.Severity.Warning);

    const echoed = exports.roundTripAlert(exports.Severity.Error);
    assert.equal(echoed, exports.Severity.Error);
}

/**
 * @param {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Exports} exports
 */
function runEnumToClassAlias(exports) {
    const seed = exports.PriorityReference.medium();
    assert.equal(seed.describe(), "medium");
    assert.equal(seed.weight(), 5);

    const echoed = exports.roundTripPriority(seed);
    assert.equal(echoed.describe(), "medium");
    assert.equal(echoed.weight(), 5);

    seed.release();
    echoed.release();
}
