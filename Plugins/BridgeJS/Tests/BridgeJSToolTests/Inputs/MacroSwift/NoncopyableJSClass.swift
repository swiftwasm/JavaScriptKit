@JSClass struct NoncopyableObject: ~Copyable {
    @JSFunction init(_ start: Int) throws(JSException)
    @JSFunction func value() throws(JSException) -> Int
    @JSGetter var name: String
}

@JSClass struct NoncopyableObjectRoundtrip: ~Copyable {
    @JSFunction func take(_ object: borrowing NoncopyableObject) throws(JSException) -> Int
    @JSFunction func adopt(_ object: consuming NoncopyableObject) throws(JSException) -> Int
    @JSFunction func make(_ start: Int) throws(JSException) -> NoncopyableObject
    @JSFunction func find(_ start: Int) throws(JSException) -> NoncopyableObject?
    @JSFunction func takeOptional(_ object: borrowing NoncopyableObject?) throws(JSException) -> Int
    @JSGetterFunction func child() throws(JSException) -> NoncopyableObject
    @JSSetter func setChild(_ object: borrowing NoncopyableObject) throws(JSException)
    @JSFunction func forEach(_ body: JSTypedClosure<(borrowing NoncopyableObject) -> Void>) throws(JSException)
    @JSFunction func load(_ start: Int) async throws(JSException) -> NoncopyableObject
    @JSFunction func takeAll(_ objects: borrowing UniqueArray<NoncopyableObject>) throws(JSException) -> Int
    @JSFunction func makeAll(_ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject>
    @JSFunction func makeMaybe(_ count: Int) throws(JSException) -> UniqueArray<NoncopyableObject>?
    @JSFunction func raw(_ start: Int) throws(JSException) -> JSUniqueRef
}

@JSFunction func makeNoncopyableObject(_ start: Int) throws(JSException) -> NoncopyableObject

@JS func useNoncopyableObject(_ object: borrowing NoncopyableObject) -> Int {
    (try? object.value()) ?? -1
}

@JS func makeNoncopyableObjectInSwift(_ start: Int) -> NoncopyableObject {
    try! NoncopyableObject(start)
}

@JS func findNoncopyableObjectInSwift(_ start: Int) -> NoncopyableObject? {
    nil
}

@JS func countNoncopyableObjects(_ objects: borrowing UniqueArray<NoncopyableObject>) -> Int {
    objects.count
}

@JS func countNoncopyableObjectsWith(_ body: (borrowing UniqueArray<NoncopyableObject>) -> Int) -> Int {
    0
}

@JS func loadNoncopyableObject(_ start: Int) async -> NoncopyableObject {
    try! NoncopyableObject(start)
}

@JS func loadNoncopyableObjects(_ count: Int) async -> UniqueArray<NoncopyableObject> {
    UniqueArray()
}

@JS class NoncopyableObjectBox {
    @JS var object: NoncopyableObject

    @JS init(_ start: Int) {
        object = try! NoncopyableObject(start)
    }
}

@JS protocol NoncopyableObjectSource {
    func name() -> String
    #if compiler(>=6.4)
    func makeAll(_ count: Int) -> UniqueArray<NoncopyableObject>
    #endif
}
