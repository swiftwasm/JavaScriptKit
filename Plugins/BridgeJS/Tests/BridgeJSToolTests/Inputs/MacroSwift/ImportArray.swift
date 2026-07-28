@JSFunction func roundtrip(_ items: [Int]) throws(JSException) -> [Int]
@JSFunction func logStrings(_ items: [String]) throws(JSException)

// An optional container lowers to an `isSome` parameter *and* a stack payload,
// so it has to be ordered with the other stack-lowered parameters.
@JSFunction func optionalArrayThenArray(_ a: [Int]?, _ b: [Int]) throws(JSException) -> Int
@JSFunction func borrowedStringAroundStackParams(
    _ s: String,
    _ a: [Int]?,
    _ b: [Int]
) throws(JSException) -> Int
