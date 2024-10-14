enum LibraryFeatures {
    static let weakRefs: Int32 = 1 << 0
}

@_cdecl("_library_features")
func _library_features() -> Int32 {
    var features: Int32 = 0
#if !JAVASCRIPTKIT_WITHOUT_WEAKREFS
    features |= LibraryFeatures.weakRefs
#endif
    return features
}

#if compiler(>=6.0) && hasFeature(Embedded)
// cdecls currently don't work in embedded, and expose for wasm only works >=6.0
@_expose(wasm, "swjs_library_features")
public func _swjs_library_features() -> Int32 { _library_features() }
#endif