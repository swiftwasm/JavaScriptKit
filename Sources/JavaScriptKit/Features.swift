enum LibraryFeatures {
    static let weakRefs: Int32 = 1 << 0
}

@_cdecl("_library_features")
public func _library_features() -> Int32 { // FIXME: it's public because _cdecl isn't visible outside in Embedded Swift
    var features: Int32 = 0
#if !JAVASCRIPTKIT_WITHOUT_WEAKREFS
    features |= LibraryFeatures.weakRefs
#endif
    return features
}
