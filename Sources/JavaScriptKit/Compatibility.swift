/// The compatibility runtime library version.
/// Notes: If you change any interface of runtime library, please increment
/// this and `SwiftRuntime.version` in `./Runtime/src/index.ts`.
@_cdecl("swjs_library_version")
func _library_version() -> Double {
    return 610
}
