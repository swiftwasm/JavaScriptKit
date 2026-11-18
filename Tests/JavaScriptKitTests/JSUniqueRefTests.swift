@_spi(BridgeJS) import JavaScriptKit
import Testing

@_extern(wasm, module: "JavaScriptKitTests", name: "retainUnique")
@_extern(c)
func retainUnique(_ ref: Int32) -> Int32

@_extern(wasm, module: "JavaScriptKitTests", name: "referenceCount")
@_extern(c)
func referenceCount(_ ref: Int32) -> Int32

@Suite struct JSUniqueRefTests {
    @Test func droppingReleasesTheReference() {
        let object = JSObject()
        let ref = Self.uniqueRef(to: object)
        let id = ref.id
        #expect(referenceCount(id) == 1)
        _ = consume ref
        #expect(referenceCount(id) == 0)
    }

    @Test func convertingReturnsTheObjectSwiftHolds() {
        let object = JSObject()
        let ref = Self.uniqueRef(to: object)
        let uniqueID = ref.id
        let converted = JSObject(ref)
        #expect(converted == object)
        #expect(referenceCount(uniqueID) == 0)
        #expect(referenceCount(Int32(bitPattern: object.id)) == 2)
    }

    @Test func convertingAValueOnlyJavaScriptHoldsKeepsItsReference() {
        let holder: JSObject = ["value": JSObject().jsValue]
        let ref = Self.uniqueRef(to: holder.value.object!)
        let uniqueID = ref.id
        let converted = JSObject(ref)
        #expect(Int32(bitPattern: converted.id) == uniqueID)
        #expect(referenceCount(uniqueID) == 1)
        #expect(holder.value.object! == converted)
    }

    private static func uniqueRef(to object: JSObject) -> JSUniqueRef {
        JSUniqueRef(adopting: retainUnique(Int32(bitPattern: object.id)))
    }
}
