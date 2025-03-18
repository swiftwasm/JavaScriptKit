enum LibraryFeatures {
    static let weakRefs: Int32 = 1 << 0
}

@_expose(wasm, "swjs_library_features")
@_cdecl("_swjs_library_features")
@available(*, unavailable)
public func _swjs_library_features() -> Int32 {
    var features: Int32 = 0
#if !JAVASCRIPTKIT_WITHOUT_WEAKREFS
    features |= LibraryFeatures.weakRefs
#endif
    return features
}
