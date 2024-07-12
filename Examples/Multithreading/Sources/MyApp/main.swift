import ChibiRay
import JavaScriptKit
import JavaScriptEventLoop

JavaScriptEventLoop.installGlobalExecutor()
WebWorkerTaskExecutor.installGlobalExecutor()

func renderInCanvas(ctx: JSObject, image: ImageView) {
    let imageData = ctx.createImageData!(image.width, image.height).object!
    let data = imageData.data.object!
    
    for y in 0..<image.height {
        for x in 0..<image.width {
            let index = (y * image.width + x) * 4
            let pixel = image[x, y]
            data[index]     = .number(Double(pixel.red * 255))
            data[index + 1] = .number(Double(pixel.green * 255))
            data[index + 2] = .number(Double(pixel.blue * 255))
            data[index + 3] = .number(Double(255))
        }
    }
    _ = ctx.putImageData!(imageData, 0, 0)
}

struct ImageView: @unchecked Sendable {
    let width, height: Int
    let buffer: UnsafeMutableBufferPointer<Color>

    subscript(x: Int, y: Int) -> Color {
        get {
            return buffer[y * width + x]
        }
        nonmutating set {
            buffer[y * width + x] = newValue
        }
    }
}

struct Work: Sendable {
    let scene: Scene
    let imageView: ImageView
    let yRange: CountableRange<Int>

    init(scene: Scene, imageView: ImageView, yRange: CountableRange<Int>) {
        self.scene = scene
        self.imageView = imageView
        self.yRange = yRange
    }
    func run() {
        for y in yRange {
            for x in 0..<scene.width {
                let ray = Ray.createPrime(x: x, y: y, scene: scene)
                let color = castRay(scene: scene, ray: ray, depth: 0)
                imageView[x, y] = color
            }
        }
    }
}

func render(scene: Scene, ctx: JSObject, renderTime: JSObject, concurrency: Int, executor: WebWorkerTaskExecutor) async {

    let imageBuffer = UnsafeMutableBufferPointer<Color>.allocate(capacity: scene.width * scene.height)
    // Initialize the buffer with black color
    imageBuffer.initialize(repeating: .black)
    let imageView = ImageView(width: scene.width, height: scene.height, buffer: imageBuffer)

    let clock = ContinuousClock()
    let start = clock.now

    var checkTimer: JSValue?
    checkTimer = JSObject.global.setInterval!(JSClosure { _ in
        print("Checking thread work...")
        renderInCanvas(ctx: ctx, image: imageView)
        let renderSceneDuration = clock.now - start
        renderTime.textContent = .string("Render time: \(renderSceneDuration)")
        return .undefined
    }, 250)

    await withTaskGroup(of: Void.self) { group in
        let yStride = scene.height / concurrency
        for i in 0..<concurrency {
            let yRange = i * yStride..<(i + 1) * yStride
            let work = Work(scene: scene, imageView: imageView, yRange: yRange)
            group.addTask(executorPreference: executor) { work.run() }
        }
        // Remaining rows
        if scene.height % concurrency != 0 {
            let work = Work(scene: scene, imageView: imageView, yRange: (concurrency * yStride)..<scene.height)
            group.addTask(executorPreference: executor) { work.run() }
        }
    }

    _ = JSObject.global.clearInterval!(checkTimer!)
    checkTimer = nil

    renderInCanvas(ctx: ctx, image: imageView)
    imageBuffer.deallocate()
    print("All work done")
}

func main() async throws {
    let canvas = JSObject.global.document.getElementById("canvas").object!
    let renderButton = JSObject.global.document.getElementById("render-button").object!
    let concurrency = JSObject.global.document.getElementById("concurrency").object!
    concurrency.value = JSObject.global.navigator.hardwareConcurrency
    let scene = createDemoScene()
    canvas.width  = .number(Double(scene.width))
    canvas.height = .number(Double(scene.height))

    _ = renderButton.addEventListener!("click", JSClosure { _ in
        Task {
            let canvas = JSObject.global.document.getElementById("canvas").object!
            let renderTime = JSObject.global.document.getElementById("render-time").object!
            let concurrency = JSObject.global.document.getElementById("concurrency").object!
            let concurrencyValue = max(Int(concurrency.value.string!) ?? 1, 1)
            let ctx = canvas.getContext!("2d").object!
            let executor = try await WebWorkerTaskExecutor(numberOfThreads: concurrencyValue)
            await render(scene: scene, ctx: ctx, renderTime: renderTime, concurrency: concurrencyValue, executor: executor)
            executor.terminate()
            print("Render done")
        }
        return JSValue.undefined
    })
}

Task {
    try await main()
}
