import JavaScriptEventLoop
@_spi(Experimental) import JavaScriptKit

@JSClass struct JSHTMLCanvasElement {
    @JSFunction func getContext(_ contextId: String) throws(JSException) -> JSCanvasRenderingContext2D
}

@JSClass struct JSCanvasRenderingContext2D {
    @JSSetter func setFillStyle(_ style: String) throws(JSException)
    @JSSetter(jsName: "fillStyle") func setFillStyleWithObject(_ style: JSObject) throws(JSException)
    @JSSetter func setStrokeStyle(_ style: String) throws(JSException)
    @JSSetter func setLineWidth(_ width: Double) throws(JSException)

    @JSFunction func beginPath() throws(JSException)
    @JSFunction func moveTo(_ x: Double, _ y: Double) throws(JSException)
    @JSFunction func lineTo(_ x: Double, _ y: Double) throws(JSException)
    @JSFunction func arc(_ x: Double, _ y: Double, _ radius: Double, _ startAngle: Double, _ endAngle: Double) throws(JSException)
    @JSFunction func fillRect(_ x: Double, _ y: Double, _ width: Double, _ height: Double) throws(JSException)
    @JSFunction func fill() throws(JSException)
    @JSFunction func stroke() throws(JSException)
    @JSFunction func createRadialGradient(_ x0: Double, _ y0: Double, _ r0: Double, _ x1: Double, _ y1: Double, _ r1: Double) throws(JSException) -> JSCanvasGradient
}

@JSClass struct JSCanvasGradient {
    @JSFunction func addColorStop(_ offset: Double, _ color: String) throws(JSException)
}

@JSClass struct JSWindow {
    @JSFunction func requestAnimationFrame(_ callback: JSTypedClosure<() -> Void>) throws(JSException)
}

@JSGetter(from: .global) var window: JSWindow

@JSClass struct JSPerformance {
    @JSFunction func now() throws(JSException) -> Double
}

@JSGetter(from: .global) var performance: JSPerformance

@JSFunction(from: .global) func setTimeout(_ callback: JSTypedClosure<() -> Void>, _ milliseconds: Int) throws(JSException)

@JSClass struct JSDocument {
    @JSFunction func getElementById(_ id: String) throws(JSException) -> JSObject
}

@JSGetter(from: .global) var document: JSDocument

JavaScriptEventLoop.installGlobalExecutor()

protocol CanvasRenderer {
    func render(canvas: JSObject, size: Int) async throws
}

struct BackgroundRenderer: CanvasRenderer {
    func render(canvas: JSObject, size: Int) async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let transfer = JSSending.transfer(canvas)
        let renderingTask = Task(executorPreference: executor) {
            let canvas = try await JSHTMLCanvasElement(unsafelyWrapping: transfer.receive())
            try await renderAnimation(canvas: canvas, size: size)
        }
        await withTaskCancellationHandler {
            try? await renderingTask.value
        } onCancel: {
            renderingTask.cancel()
        }
        executor.terminate()
    }
}

struct MainThreadRenderer: CanvasRenderer {
    func render(canvas: JSObject, size: Int) async throws {
        try await renderAnimation(canvas: JSHTMLCanvasElement(unsafelyWrapping: canvas), size: size)
    }
}

// FPS Counter for CSS animation
func startFPSMonitor(window: JSWindow, performance: JSPerformance) throws {
    let fpsCounterElement = try document.getElementById("fps-counter")

    var lastTime = try performance.now()
    var frames = 0

    // Create a frame counter function
    func countFrame() throws {
        frames += 1
        let currentTime = try performance.now()
        let elapsed = currentTime - lastTime

        if elapsed >= 1000 {
            let fps = Int(Double(frames) * 1000 / elapsed)
            fpsCounterElement.textContent = .string("FPS: \(fps)")
            frames = 0
            lastTime = currentTime
        }

        // Request next frame
        try window.requestAnimationFrame(JSTypedClosure<() -> Void> {
            try! countFrame()
        })
    }

    // Start counting
    try countFrame()
}

@MainActor
func onClick(renderer: CanvasRenderer) async throws {
    let document = JSObject.global.document

    let canvasContainerElement = document.getElementById("canvas-container").object!

    // Remove all child elements from the canvas container
    for i in 0..<Int(canvasContainerElement.children.length.number!) {
        let child = canvasContainerElement.children[i]
        _ = canvasContainerElement.removeChild!(child)
    }

    let canvasElement = document.createElement("canvas").object!
    _ = canvasContainerElement.appendChild!(canvasElement)

    let size = 800
    canvasElement.width = .number(Double(size))
    canvasElement.height = .number(Double(size))

    let offscreenCanvas = canvasElement.transferControlToOffscreen!().object!
    try await renderer.render(canvas: offscreenCanvas, size: size)
}

func main() async throws {
    let renderButtonElement = JSObject.global.document.getElementById("render-button").object!
    let cancelButtonElement = JSObject.global.document.getElementById("cancel-button").object!
    let rendererSelectElement = JSObject.global.document.getElementById("renderer-select").object!

    var renderingTask: Task<Void, Error>? = nil

    // Start the FPS monitor for CSS animations
    try startFPSMonitor(window: window, performance: performance)

    _ = renderButtonElement.addEventListener!(
        "click",
        JSClosure { _ in
            renderingTask?.cancel()
            renderingTask = Task {
                let selectedValue = rendererSelectElement.value.string!
                let renderer: CanvasRenderer =
                    selectedValue == "main" ? MainThreadRenderer() : BackgroundRenderer()
                try await onClick(renderer: renderer)
            }
            return JSValue.undefined
        }
    )

    _ = cancelButtonElement.addEventListener!(
        "click",
        JSClosure { _ in
            renderingTask?.cancel()
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
