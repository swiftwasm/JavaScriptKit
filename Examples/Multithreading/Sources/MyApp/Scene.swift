import ChibiRay

func createDemoScene(size: Int) -> Scene {
    return Scene(
        width: size,
        height: size,
        fov: 90,
        elements: [
            .sphere(
                Sphere(
                    center: Point(x: 1.0, y: -1.0, z: -7.0),
                    radius: 1.0,
                    material: Material(
                        color: Color(red: 0.8, green: 0.2, blue: 0.4),
                        albedo: 0.6,
                        surface: .reflective(reflectivity: 0.9)
                    )
                )
            ),
            .sphere(
                Sphere(
                    center: Point(x: -2.0, y: 1.0, z: -10.0),
                    radius: 3.0,
                    material: Material(
                        color: Color(red: 1.0, green: 0.4, blue: 0.4),
                        albedo: 0.7,
                        surface: .diffuse
                    )
                )
            ),
            .sphere(
                Sphere(
                    center: Point(x: 3.0, y: 2.0, z: -5.0),
                    radius: 2.0,
                    material: Material(
                        color: Color(red: 0.4, green: 0.4, blue: 0.8),
                        albedo: 0.5,
                        surface: .refractive(index: 2, transparency: 0.9)
                    )
                )
            ),
            .plane(
                Plane(
                    origin: Point(x: 0.0, y: -2.0, z: -5.0),
                    normal: Vector3(x: 0.0, y: -1.0, z: 0.0),
                    material: Material(
                        color: Color(red: 1.0, green: 1.0, blue: 1.0),
                        albedo: 0.18,
                        surface: .reflective(reflectivity: 0.5)
                    )
                )
            ),
            .plane(
                Plane(
                    origin: Point(x: 0.0, y: 0.0, z: -20.0),
                    normal: Vector3(x: 0.0, y: 0.0, z: -1.0),
                    material: Material(
                        color: Color(red: 0.2, green: 0.3, blue: 1.0),
                        albedo: 0.38,
                        surface: .diffuse
                    )
                )
            )
        ],
        lights: [
            .spherical(
                SphericalLight(
                    position: Point(x: 5.0, y: 10.0, z: -3.0),
                    color: Color(red: 1.0, green: 1.0, blue: 1.0),
                    intensity: 16000
                )
            ),
            .spherical(
                SphericalLight(
                    position: Point(x: -3.0, y: 3.0, z: -5.0),
                    color: Color(red: 0.3, green: 0.3, blue: 1.0),
                    intensity: 1000
                )
            ),
            .directional(
                DirectionalLight(
                    direction: Vector3(x: 0.0, y: -1.0, z: -1.0),
                    color: Color(red: 0.8, green: 0.8, blue: 0.8),
                    intensity: 0.2
                )
            )
        ],
        shadowBias: 1e-13,
        maxRecursionDepth: 10
    )
}

extension Scene: @retroactive @unchecked Sendable {}
