import ChibiRay
import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.installGlobalExecutor()
WebWorkerTaskExecutor.installGlobalExecutor()

func renderInCanvas(ctx: JSObject, image: ImageView) {
    let imageData = ctx.createImageData!(image.width, image.height).object!
    let data = imageData.data.object!

    for y in 0..<image.height {
        for x in 0..<image.width {
            let index = (y * image.width + x) * 4
            let pixel = image[x, y]
            data[index] = .number(Double(pixel.red * 255))
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

func render(
    scene: Scene,
    ctx: JSObject,
    renderTimeElement: JSObject,
    concurrency: Int,
    executor: (some TaskExecutor)?
) async {

    let imageBuffer = UnsafeMutableBufferPointer<Color>.allocate(capacity: scene.width * scene.height)
    // Initialize the buffer with black color
    imageBuffer.initialize(repeating: .black)
    let imageView = ImageView(width: scene.width, height: scene.height, buffer: imageBuffer)

    let clock = ContinuousClock()
    let start = clock.now

    func updateRenderTime() {
        let renderSceneDuration = clock.now - start
        renderTimeElement.textContent = .string("Render time: \(renderSceneDuration)")
    }

    var checkTimer: JSValue?
    checkTimer = JSObject.global.setInterval!(
        JSClosure { _ in
            print("Checking thread work...")
            renderInCanvas(ctx: ctx, image: imageView)
            updateRenderTime()
            return .undefined
        },
        250
    )

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
    updateRenderTime()
    imageBuffer.deallocate()
    print("All work done")
}

func onClick() async throws {
    let document = JSObject.global.document

    let canvasElement = document.getElementById("canvas").object!
    let renderTimeElement = document.getElementById("render-time").object!

    let concurrency = max(Int(document.getElementById("concurrency").object!.value.string!) ?? 1, 1)
    let background = document.getElementById("background").object!.checked.boolean!
    let size = Int(document.getElementById("size").object!.value.string ?? "800")!

    let ctx = canvasElement.getContext!("2d").object!

    let scene = createDemoScene(size: size)
    let executor = background ? try await WebWorkerTaskExecutor(numberOfThreads: concurrency) : nil
    canvasElement.width = .number(Double(scene.width))
    canvasElement.height = .number(Double(scene.height))

    await render(
        scene: scene,
        ctx: ctx,
        renderTimeElement: renderTimeElement,
        concurrency: concurrency,
        executor: executor
    )
    executor?.terminate()
    print("Render done")
}

func main() async throws {
    let renderButtonElement = JSObject.global.document.getElementById("render-button").object!
    let concurrencyElement = JSObject.global.document.getElementById("concurrency").object!
    concurrencyElement.value = JSObject.global.navigator.hardwareConcurrency

    _ = renderButtonElement.addEventListener!(
        "click",
        JSClosure { _ in
            Task {
                try await onClick()
            }
            return JSValue.undefined
        }
    )
}

Task {
    try await main()
}

#if canImport(wasi_pthread)
import wasi_pthread
import WASILibc

/// Trick to avoid blocking the main thread. pthread_mutex_lock function is used by
/// the Swift concurrency runtime.
@_cdecl("pthread_mutex_lock")
func pthread_mutex_lock(_ mutex: UnsafeMutablePointer<pthread_mutex_t>) -> Int32 {
    // DO NOT BLOCK MAIN THREAD
    var ret: Int32
    repeat {
        ret = pthread_mutex_trylock(mutex)
    } while ret == EBUSY
    return ret
}
#endif
