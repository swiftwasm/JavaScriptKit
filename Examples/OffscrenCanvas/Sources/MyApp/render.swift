import Foundation
import JavaScriptKit

func sleepOnThread(milliseconds: Int, isolation: isolated (any Actor)? = #isolation) async {
    // Use the JavaScript setTimeout function to avoid hopping back to the main thread
    await withCheckedContinuation(isolation: isolation) { continuation in
        _ = JSObject.global.setTimeout!(
            JSOneshotClosure { _ in
                continuation.resume()
                return JSValue.undefined
            },
            milliseconds
        )
    }
}

func renderAnimation(
    canvas: JSObject,
    size: Int,
    isolation: isolated (any Actor)? = #isolation
)
    async throws
{
    let ctx = canvas.getContext!("2d").object!

    // Animation state variables
    var time: Double = 0

    // Create a large number of particles
    let particleCount = 5000
    var particles: [[Double]] = []

    // Initialize particles with random positions and velocities
    for _ in 0..<particleCount {
        // [x, y, vx, vy, size, hue, lifespan, maxLife]
        let x = Double.random(in: 0..<Double(size))
        let y = Double.random(in: 0..<Double(size))
        let speed = Double.random(in: 0.2...2.0)
        let angle = Double.random(in: 0..<(2 * Double.pi))
        let vx = cos(angle) * speed
        let vy = sin(angle) * speed
        let particleSize = Double.random(in: 1.0...3.0)
        let hue = Double.random(in: 0..<360)
        let maxLife = Double.random(in: 100...300)
        particles.append([x, y, vx, vy, particleSize, hue, maxLife, maxLife])
    }

    // Create emitter positions that will generate new particles
    let emitters = 5
    var emitterPositions: [[Double]] = []
    for i in 0..<emitters {
        let angle = Double(i) * 2 * Double.pi / Double(emitters)
        let distance = Double(size) * 0.3
        let x = Double(size) / 2 + cos(angle) * distance
        let y = Double(size) / 2 + sin(angle) * distance
        emitterPositions.append([x, y])
    }

    while !Task.isCancelled {
        // Semi-transparent background for trail effect
        _ = ctx.fillStyle = .string("rgba(0, 0, 0, 0.05)")
        _ = ctx.fillRect!(0, 0, size, size)

        // Intentionally add a computationally expensive calculation for main thread demonstration
        var expensiveCalculation = 0.0
        for _ in 0..<500 {
            expensiveCalculation += sin(time) * cos(time)
        }

        // Update and render all particles
        for i in 0..<particles.count {
            // Update position
            particles[i][0] += particles[i][2]
            particles[i][1] += particles[i][3]

            // Apply slight gravity
            particles[i][3] += 0.02

            // Decrease lifespan
            particles[i][6] -= 1

            // If particle is dead, respawn it from an emitter
            if particles[i][6] <= 0 {
                let emitterIndex = Int.random(in: 0..<emitterPositions.count)
                particles[i][0] = emitterPositions[emitterIndex][0]
                particles[i][1] = emitterPositions[emitterIndex][1]

                let speed = Double.random(in: 0.5...3.0)
                let angle = Double.random(in: 0..<(2 * Double.pi))
                particles[i][2] = cos(angle) * speed
                particles[i][3] = sin(angle) * speed

                particles[i][4] = Double.random(in: 1.0...3.0)  // Size
                particles[i][5] = Double.random(in: 0..<360)  // Hue
                particles[i][6] = particles[i][7]  // Reset lifespan
            }

            // Bounce off edges
            if particles[i][0] < 0 || particles[i][0] > Double(size) {
                particles[i][2] *= -0.8
            }
            if particles[i][1] < 0 || particles[i][1] > Double(size) {
                particles[i][3] *= -0.8
            }

            // Calculate opacity based on lifespan
            let opacity = particles[i][6] / particles[i][7]

            // Get coordinates and properties
            let x = particles[i][0]
            let y = particles[i][1]
            let size = particles[i][4]
            let hue = (particles[i][5] + time * 10).truncatingRemainder(dividingBy: 360)

            // Draw particle
            _ = ctx.beginPath!()
            ctx.fillStyle = .string("hsla(\(hue), 100%, 60%, \(opacity))")
            _ = ctx.arc!(x, y, size, 0, 2 * Double.pi)
            _ = ctx.fill!()

            // Connect nearby particles with lines (only check some to save CPU)
            if i % 20 == 0 {
                for j in (i + 1)..<min(i + 20, particles.count) {
                    let dx = particles[j][0] - x
                    let dy = particles[j][1] - y
                    let dist = sqrt(dx * dx + dy * dy)

                    if dist < 30 {
                        _ = ctx.beginPath!()
                        ctx.strokeStyle = .string("rgba(255, 255, 255, \(0.1 * opacity))")
                        ctx.lineWidth = .number(0.3)
                        _ = ctx.moveTo!(x, y)
                        _ = ctx.lineTo!(particles[j][0], particles[j][1])
                        _ = ctx.stroke!()
                    }
                }
            }
        }

        // Draw emitters as glowing circles
        for i in 0..<emitterPositions.count {
            let x = emitterPositions[i][0]
            let y = emitterPositions[i][1]

            // Emitter pulse effect
            let pulseSize = 10 + 5 * sin(time * 2 + Double(i))
            let hue = (time * 50 + Double(i) * 72).truncatingRemainder(dividingBy: 360)

            // Draw glow
            let gradient = ctx.createRadialGradient!(x, y, 0, x, y, pulseSize * 2).object!
            _ = gradient.addColorStop!(0, "hsla(\(hue), 100%, 70%, 0.8)")
            _ = gradient.addColorStop!(1, "hsla(\(hue), 100%, 50%, 0)")

            _ = ctx.beginPath!()
            ctx.fillStyle = .object(gradient)
            _ = ctx.arc!(x, y, pulseSize * 2, 0, 2 * Double.pi)
            _ = ctx.fill!()

            // Center of emitter
            _ = ctx.beginPath!()
            ctx.fillStyle = .string("hsla(\(hue), 100%, 70%, 0.8)")
            _ = ctx.arc!(x, y, pulseSize * 0.5, 0, 2 * Double.pi)
            _ = ctx.fill!()
        }

        // Update time and emitter positions
        time += 0.03

        // Move emitters in circular patterns
        for i in 0..<emitterPositions.count {
            let angle = time * 0.2 + Double(i) * 2 * Double.pi / Double(emitters)
            let distance = Double(size) * 0.3 + sin(time * 0.5) * Double(size) * 0.05
            emitterPositions[i][0] = Double(size) / 2 + cos(angle) * distance
            emitterPositions[i][1] = Double(size) / 2 + sin(angle) * distance
        }

        await sleepOnThread(milliseconds: 16, isolation: isolation)
    }
}
