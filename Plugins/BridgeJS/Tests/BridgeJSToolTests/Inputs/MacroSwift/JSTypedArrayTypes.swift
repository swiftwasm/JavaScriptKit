import JavaScriptKit

// Using typealiases
@JS func processBytes(_ data: JSUint8Array) -> JSUint8Array {
    return data
}

@JS func processFloats(_ data: JSFloat32Array) -> JSFloat32Array {
    return data
}

// Using generic form directly
@JS func processGenericDoubles(_ data: JSTypedArray<Double>) -> JSTypedArray<Double> {
    return data
}

@JS func processGenericInts(_ data: JSTypedArray<Int32>) -> JSTypedArray<Int32> {
    return data
}
