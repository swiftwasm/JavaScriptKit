import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.installGlobalExecutor()
WebWorkerTaskExecutor.installGlobalExecutor()

protocol CanvasRenderer {
    func render(canvas: JSObject, size: Int) async throws
}

struct BackgroundRenderer: CanvasRenderer {
    func render(canvas: JSObject, size: Int) async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let transferringCanvas = JSObject.transfer(canvas)
        let renderingTask = Task(executorPreference: executor) {
            let canvas = try await transferringCanvas.receive()
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
        try await renderAnimation(canvas: canvas, size: size)
    }
}

// FPS Counter for CSS animation
func startFPSMonitor() {
    let fpsCounterElement = JSObject.global.document.getElementById("fps-counter").object!

    var lastTime = JSObject.global.performance.now().number!
    var frames = 0

    // Create a frame counter function
    func countFrame() {
        frames += 1
        let currentTime = JSObject.global.performance.now().number!
        let elapsed = currentTime - lastTime

        if elapsed >= 1000 {
            let fps = Int(Double(frames) * 1000 / elapsed)
            fpsCounterElement.textContent = .string("FPS: \(fps)")
            frames = 0
            lastTime = currentTime
        }

        // Request next frame
        _ = JSObject.global.requestAnimationFrame!(
            JSClosure { _ in
                countFrame()
                return .undefined
            })
    }

    // Start counting
    countFrame()
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
    startFPSMonitor()

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
        })

    _ = cancelButtonElement.addEventListener!(
        "click",
        JSClosure { _ in
            renderingTask?.cancel()
            return JSValue.undefined
        })
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
