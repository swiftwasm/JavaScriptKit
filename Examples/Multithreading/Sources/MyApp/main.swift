import ChibiRay
import JavaScriptEventLoop
@_spi(Experimental) import JavaScriptKit

JavaScriptEventLoop.installGlobalExecutor()

@JSClass struct JSCanvasContext2D {
    @JSFunction func createImageData(_ width: Int, _ height: Int) throws -> JSImageData
    @JSFunction func putImageData(_ imageData: JSImageData, _ dx: Int, _ dy: Int) throws -> Void
}

@JSClass struct JSImageData {
    @JSGetter var data: JSObject
}


@JSFunction func assignImageDataPixel(
    _ data: JSObject,
    _ index: Int,
    _ red: Double, _ green: Double, _ blue: Double, _ alpha: Double
) throws -> Void

@JSFunction(from: .global) func setInterval(_ callback: JSTypedClosure<() -> Void>, _ delay: Int) throws -> Int
@JSFunction(from: .global) func clearInterval(_ interval: Int) throws -> Void

@JSClass struct JSElement {
    @JSSetter func setTextContent(_ text: String) throws -> Void
}

func renderInCanvas(ctx: JSCanvasContext2D, image: ImageView) throws {
    let imageData = try ctx.createImageData(image.width, image.height)
    let data = try imageData.data

    for y in 0..<image.height {
        for x in 0..<image.width {
            let index = (y * image.width + x) * 4
            let pixel = image[x, y]
            try assignImageDataPixel(data, index, Double(pixel.red), Double(pixel.green), Double(pixel.blue), 1.0)
        }
    }
    try ctx.putImageData(imageData, 0, 0)
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
    ctx: JSCanvasContext2D,
    renderTimeElement: JSElement,
    concurrency: Int,
    executor: (some TaskExecutor)?
) async throws {

    let imageBuffer = UnsafeMutableBufferPointer<Color>.allocate(capacity: scene.width * scene.height)
    // Initialize the buffer with black color
    imageBuffer.initialize(repeating: .black)
    let imageView = ImageView(width: scene.width, height: scene.height, buffer: imageBuffer)

    let clock = ContinuousClock()
    let start = clock.now

    func updateRenderTime() throws {
        let renderSceneDuration = clock.now - start
        try renderTimeElement.setTextContent("Render time: \(renderSceneDuration)")
    }

    var checkTimer: Int?
    checkTimer = try setInterval(
        JSTypedClosure {
            print("Checking thread work...")
            try! renderInCanvas(ctx: ctx, image: imageView)
            try! updateRenderTime()
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

    try clearInterval(checkTimer!)
    checkTimer = nil

    try renderInCanvas(ctx: ctx, image: imageView)
    try updateRenderTime()
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

    try await render(
        scene: scene,
        ctx: JSCanvasContext2D(unsafelyWrapping: ctx),
        renderTimeElement: JSElement(unsafelyWrapping: renderTimeElement),
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
