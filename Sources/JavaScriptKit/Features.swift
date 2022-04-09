enum LibraryFeatures {
    static let weakRefs: Int32 = 1 << 0
    static let bigInts: Int32 = 1 << 1
}

@_cdecl("_library_features")
func _library_features() -> Int32 {
    var features: Int32 = 0
#if !JAVASCRIPTKIT_WITHOUT_WEAKREFS
    features |= LibraryFeatures.weakRefs
#endif
#if !JAVASCRIPTKIT_WITHOUT_BIGINTS
    features |= LibraryFeatures.bigInts
#endif
    return features
}
