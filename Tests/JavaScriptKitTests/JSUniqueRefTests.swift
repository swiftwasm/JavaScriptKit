@_spi(BridgeJS) import JavaScriptKit
import Testing

@_extern(wasm, module: "JavaScriptKitTests", name: "retainNew")
@_extern(c)
private func retainNew(_ ref: Int32) -> Int32

@_extern(wasm, module: "JavaScriptKitTests", name: "isLive")
@_extern(c)
private func isLive(_ ref: Int32) -> Bool

@Suite struct JSUniqueRefTests {
    @Test func droppingReleasesTheReference() {
        let ref = Self.uniqueRef(to: JSObject())
        let id = ref.id
        #expect(isLive(Int32(bitPattern: id)))
        _ = consume ref
        #expect(!isLive(Int32(bitPattern: id)))
    }

    @Test func unsafeTakeKeepsTheReference() {
        let ref = Self.uniqueRef(to: JSObject())
        let id = ref.unsafeTake()
        #expect(isLive(Int32(bitPattern: id)))
        _ = JSUniqueRef(adopting: id)
        #expect(!isLive(Int32(bitPattern: id)))
    }

    @Test func convertingToJSObjectTakesOverTheReference() {
        let object = JSObject()
        let ref = Self.uniqueRef(to: object)
        let id = ref.id
        var converted: JSObject? = JSObject(ref)
        #expect(converted!.id == id)
        #expect(converted! == object)
        converted = nil
        #expect(!isLive(Int32(bitPattern: id)))
        #expect(isLive(Int32(bitPattern: object.id)))
    }

    private static func uniqueRef(to object: JSObject) -> JSUniqueRef {
        JSUniqueRef(adopting: .init(bitPattern: retainNew(Int32(bitPattern: object.id))))
    }
}
