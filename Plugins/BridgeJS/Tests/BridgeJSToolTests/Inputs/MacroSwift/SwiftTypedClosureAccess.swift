// Verifies that `JSTypedClosure` initializers synthesized by BridgeJS adopt the
// access level of the originating `@JSClass`/`@JSFunction` surface, so that
// downstream targets can construct typed closures for public APIs (issue #709).

@JSClass(jsName: "PublicEvent") public struct JSPublicEvent {}
@JSClass(jsName: "PackageEvent") package struct JSPackageEvent {}
@JSClass(jsName: "InternalEvent") struct JSInternalEvent {}

@JSClass(jsName: "PublicTarget") public struct JSPublicTarget {
    // A public method taking a typed closure must yield a `public` synthesized init,
    // since downstream modules may construct the closure value.
    @JSFunction public func addPublicListener(_ handler: JSTypedClosure<(JSPublicEvent) -> Void>) throws(JSException)
    // Same closure shape on an internal method — the synthesized init merges to public,
    // because at most one extension per signature is generated.
    @JSFunction func addInternalListener(_ handler: JSTypedClosure<(JSPublicEvent) -> Void>) throws(JSException)
}

@JSClass(jsName: "PackageTarget") package struct JSPackageTarget {
    // A package-level surface yields a `package` synthesized init.
    @JSFunction package func addPackageListener(_ handler: JSTypedClosure<(JSPackageEvent) -> Void>) throws(JSException)
}

@JSClass(jsName: "InternalTarget") struct JSInternalTarget {
    // No public/package surface for this signature — the synthesized init stays internal.
    @JSFunction func addInternalListener(_ handler: JSTypedClosure<(JSInternalEvent) -> Void>) throws(JSException)
}
