import JavaScriptKit

@JS public struct Vector3D {
    public let x: Double
    public let y: Double
    public let z: Double

    @JS public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    @JS public func magnitude() -> Double {
        (x * x + y * y + z * z).squareRoot()
    }
}
