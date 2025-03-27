import JavaScriptEventLoop
import JavaScriptKit

// Simple full-text search service
actor SearchService {
    struct Error: Swift.Error, CustomStringConvertible {
        let message: String

        var description: String {
            return self.message
        }
    }

    let serialExecutor: OwnedExecutor

    // Simple in-memory index: word -> positions
    var index: [String: [Int]] = [:]
    var originalContent: String = ""
    lazy var console: JSValue = {
        JSObject.global.console
    }()

    nonisolated var unownedExecutor: UnownedSerialExecutor {
        return self.serialExecutor.unownedExecutor
    }

    init(serialExecutor: OwnedExecutor) {
        self.serialExecutor = serialExecutor
    }

    // Utility function for fetch
    func fetch(_ url: String) -> JSPromise {
        let jsFetch = JSObject.global.fetch.function!
        return JSPromise(jsFetch(url).object!)!
    }

    func fetchAndIndex(url: String) async throws {
        let response = try await fetch(url).value()
        if response.status != 200 {
            throw Error(message: "Failed to fetch content")
        }
        let text = try await JSPromise(response.text().object!)!.value()
        let content = text.string!
        index(content)
    }

    func index(_ contents: String) {
        self.originalContent = contents
        self.index = [:]

        // Simple tokenization and indexing
        var position = 0
        let words = contents.lowercased().split(whereSeparator: { !$0.isLetter && !$0.isNumber })

        for word in words {
            let wordStr = String(word)
            if wordStr.count > 1 {  // Skip single-character words
                if index[wordStr] == nil {
                    index[wordStr] = []
                }
                index[wordStr]?.append(position)
            }
            position += 1
        }

        _ = console.log("Indexing complete with", index.count, "unique words")
    }

    func search(_ query: String) -> [SearchResult] {
        let queryWords = query.lowercased().split(whereSeparator: { !$0.isLetter && !$0.isNumber })

        if queryWords.isEmpty {
            return []
        }

        var results: [SearchResult] = []

        // Start with the positions of the first query word
        guard let firstWord = queryWords.first,
            let firstWordPositions = index[String(firstWord)]
        else {
            return []
        }

        for position in firstWordPositions {
            // Extract context around this position
            let words = originalContent.lowercased().split(whereSeparator: {
                !$0.isLetter && !$0.isNumber
            })
            var contextWords: [String] = []

            // Get words for context (5 words before, 10 words after)
            let contextStart = max(0, position - 5)
            let contextEnd = min(position + 10, words.count - 1)

            if contextStart <= contextEnd && contextStart < words.count {
                for i in contextStart...contextEnd {
                    if i < words.count {
                        contextWords.append(String(words[i]))
                    }
                }
            }

            let context = contextWords.joined(separator: " ")
            results.append(SearchResult(position: position, context: context))
        }

        return results
    }
}

struct SearchResult {
    let position: Int
    let context: String
}

@MainActor
final class App {
    private let document = JSObject.global.document
    private let alert = JSObject.global.alert.function!

    // UI elements
    private let container: JSValue
    private let urlInput: JSValue
    private let indexButton: JSValue
    private let searchInput: JSValue
    private let searchButton: JSValue
    private let statusElement: JSValue
    private let resultsElement: JSValue

    // Search service
    private let service: SearchService

    init(service: SearchService) {
        self.service = service
        container = document.getElementById("container")
        urlInput = document.getElementById("urlInput")
        indexButton = document.getElementById("indexButton")
        searchInput = document.getElementById("searchInput")
        searchButton = document.getElementById("searchButton")
        statusElement = document.getElementById("status")
        resultsElement = document.getElementById("results")
        setupEventHandlers()
    }

    private func setupEventHandlers() {
        indexButton.onclick = .object(
            JSClosure { [weak self] _ in
                guard let self else { return .undefined }
                self.performIndex()
                return .undefined
            }
        )

        searchButton.onclick = .object(
            JSClosure { [weak self] _ in
                guard let self else { return .undefined }
                self.performSearch()
                return .undefined
            }
        )
    }

    private func performIndex() {
        let url = urlInput.value.string!

        if url.isEmpty {
            alert("Please enter a URL")
            return
        }

        updateStatus("Downloading and indexing content...")

        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.service.fetchAndIndex(url: url)
                await MainActor.run {
                    self.updateStatus("Indexing complete!")
                }
            } catch {
                await MainActor.run {
                    self.updateStatus("Error: \(error)")
                }
            }
        }
    }

    private func performSearch() {
        let query = searchInput.value.string!

        if query.isEmpty {
            alert("Please enter a search query")
            return
        }

        updateStatus("Searching...")

        Task { [weak self] in
            guard let self else { return }
            let searchResults = await self.service.search(query)
            await MainActor.run {
                self.displaySearchResults(searchResults)
            }
        }
    }

    private func updateStatus(_ message: String) {
        statusElement.innerText = .string(message)
    }

    private func displaySearchResults(_ results: [SearchResult]) {
        statusElement.innerText = .string("Search complete! Found \(results.count) results.")
        resultsElement.innerHTML = .string("")

        if results.isEmpty {
            let noResults = document.createElement("p")
            noResults.innerText = .string("No results found.")
            _ = resultsElement.appendChild(noResults)
        } else {
            // Display up to 10 results
            for (index, result) in results.prefix(10).enumerated() {
                let resultItem = document.createElement("div")
                resultItem.style = .string(
                    "padding: 10px; margin: 5px 0; background: #f5f5f5; border-left: 3px solid blue;"
                )
                resultItem.innerHTML = .string(
                    "<strong>Result \(index + 1):</strong> \(result.context)"
                )
                _ = resultsElement.appendChild(resultItem)
            }
        }
    }
}

/// The fallback executor actor is used when the dedicated worker is not available.
actor FallbackExecutorActor {}

enum OwnedExecutor {
    case dedicated(WebWorkerDedicatedExecutor)
    case fallback(FallbackExecutorActor)

    var unownedExecutor: UnownedSerialExecutor {
        switch self {
        case .dedicated(let executor):
            return executor.asUnownedSerialExecutor()
        case .fallback(let x):
            return x.unownedExecutor
        }
    }
}

@main struct Main {
    @MainActor static var app: App?

    static func main() {
        JavaScriptEventLoop.installGlobalExecutor()
        WebWorkerTaskExecutor.installGlobalExecutor()
        let useDedicatedWorker = !(JSObject.global.disableDedicatedWorker.boolean ?? false)

        Task {
            let ownedExecutor: OwnedExecutor
            if useDedicatedWorker {
                // Create dedicated worker
                let dedicatedWorker = try await WebWorkerDedicatedExecutor()
                ownedExecutor = .dedicated(dedicatedWorker)
            } else {
                // Fallback to main thread executor
                let fallbackExecutor = FallbackExecutorActor()
                ownedExecutor = .fallback(fallbackExecutor)
            }
            // Create the service and app
            let service = SearchService(serialExecutor: ownedExecutor)
            app = App(service: service)
        }
    }
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
