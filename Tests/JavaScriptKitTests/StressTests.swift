import JavaScriptKit
import XCTest

final class StressTests: XCTestCase {
    
    func testJSObjectMemoryExhaustion() async throws {
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }

        // Push JSObject allocation to stress memory management
        // This tests reference counting and cleanup under heavy load
        let maxIterations = 25_000
        var objects: [JSObject] = []
        var lastSuccessfulCount = 0
        
        do {
            for i in 0..<maxIterations {
                let obj = JSObject()
                // Add properties to increase memory pressure
                obj["index"] = JSValue.number(Double(i))
                obj["data"] = JSValue.string(String(repeating: "x", count: 1000)) // 1KB string per object
                
                // Create nested objects to stress the reference graph
                let nested = JSObject()
                nested["parent_ref"] = obj.jsValue // Circular reference
                obj["nested"] = nested.jsValue
                
                objects.append(obj)
                lastSuccessfulCount = i
                
                // Aggressive GC every 1000 objects to test cleanup under pressure
                if i % 1000 == 0 {
                    gc()
                    try await Task.sleep(for: .milliseconds(0))
                }
            }
        } catch {
            // Expected to eventually fail due to memory pressure
            print("JSObject stress test stopped at \(lastSuccessfulCount) objects: \(error)")
        }
        
        // Verify objects are still accessible after memory pressure
        let sampleCount = min(1000, objects.count)
        for i in 0..<sampleCount {
            XCTAssertEqual(objects[i]["index"], JSValue.number(Double(i)))
            XCTAssertNotNil(objects[i]["nested"].object)
        }
        
        // Force cleanup
        objects.removeAll()
        for _ in 0..<20 {
            gc()
            try await Task.sleep(for: .milliseconds(10))
        }
    }
    
    func testJSClosureMemoryPressureWithoutFinalizationRegistry() async throws {
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }

        // Test heavy closure allocation to stress Swift heap management  
        // Focus on scenarios where FinalizationRegistry is not used
        let maxClosures = 15_000
        var closures: [JSClosure] = []
        var successCount = 0
        
        do {
            for i in 0..<maxClosures {
                // Create closures that capture significant data
                let capturedData = Array(0..<100).map { "item_\($0)_\(i)" }
                let closure = JSClosure { arguments in
                    // Force usage of captured data to prevent optimization
                    let result = capturedData.count + Int(arguments.first?.number ?? 0)
                    return JSValue.number(Double(result))
                }
                
                closures.append(closure)
                successCount = i + 1
                
                // Test closure immediately to ensure it works under memory pressure
                let result = closure([JSValue.number(10)])
                XCTAssertEqual(result.number, 110.0) // 100 (capturedData.count) + 10
                
                // More frequent GC to stress the system
                if i % 500 == 0 {
                    gc()
                    try await Task.sleep(for: .milliseconds(0))
                }
            }
        } catch {
            print("JSClosure stress test stopped at \(successCount) closures: \(error)")
        }
        
        // Test random closures still work after extreme memory pressure
        for _ in 0..<min(100, closures.count) {
            let randomIndex = Int.random(in: 0..<closures.count)
            let result = closures[randomIndex]([JSValue.number(5)])
            XCTAssertTrue(result.number! > 5) // Should be 5 + capturedData.count (100+)
        }
        
        #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
        for closure in closures {
            closure.release()
        }
        #endif
        
        closures.removeAll()
        for _ in 0..<20 {
            gc()
            try await Task.sleep(for: .milliseconds(10))
        }
    }
    
    func testMixedAllocationMemoryBoundaries() async throws {
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }

        // Test system behavior at memory boundaries with mixed object types
        let cycles = 200
        var totalObjects = 0
        var totalClosures = 0
        
        for cycle in 0..<cycles {
            var cycleObjects: [JSObject] = []
            var cycleClosure: [JSClosure] = []
            
            // Exponentially increase allocation pressure each cycle
            let objectsThisCycle = min(100 + cycle, 1000)
            let closuresThisCycle = min(50 + cycle / 2, 500)
            
            do {
                // Allocate objects
                for i in 0..<objectsThisCycle {
                    let obj = JSObject()
                    // Create memory-intensive properties
                    obj["large_array"] = JSObject.global.Array.function!.from!(
                        (0..<1000).map { JSValue.number(Double($0)) }.jsValue
                    ).jsValue
                    obj["metadata"] = [
                        "cycle": cycle,
                        "index": i,
                        "timestamp": Int(Date().timeIntervalSince1970)
                    ].jsValue
                    
                    cycleObjects.append(obj)
                    totalObjects += 1
                }
                
                // Allocate closures with increasing complexity
                for i in 0..<closuresThisCycle {
                    let heavyData = String(repeating: "data", count: cycle + 100)
                    let closure = JSClosure { arguments in
                        // Force retention of heavy data
                        return JSValue.string(heavyData.prefix(10).description)
                    }
                    cycleClosure.append(closure)
                    totalClosures += 1
                }
                
            } catch {
                print("Memory boundary reached at cycle \(cycle): \(error)")
                print("Total objects created: \(totalObjects), closures: \(totalClosures)")
                break
            }
            
            // Test system still works under extreme pressure
            if !cycleObjects.isEmpty {
                XCTAssertNotNil(cycleObjects[0]["large_array"].object)
            }
            if !cycleClosure.isEmpty {
                let result = cycleClosure[0](arguments: [])
                XCTAssertNotNil(result.string)
            }
            
            #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
            for closure in cycleClosure {
                closure.release()
            }
            #endif
            
            cycleObjects.removeAll()
            cycleClosure.removeAll()
            
            // Aggressive cleanup every 10 cycles
            if cycle % 10 == 0 {
                for _ in 0..<10 {
                    gc()
                    try await Task.sleep(for: .milliseconds(1))
                }
            }
        }
        
        print("Stress test completed: \(totalObjects) objects, \(totalClosures) closures allocated")
    }
    
    func testHeapFragmentationRecovery() async throws {
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }

        // Test system recovery from heap fragmentation by creating/destroying
        // patterns that stress the memory allocator
        let fragmentationCycles = 100
        
        for cycle in 0..<fragmentationCycles {
            var shortLivedObjects: [JSObject] = []
            var longLivedObjects: [JSObject] = []
            
            // Create fragmentation pattern: many short-lived, few long-lived
            for i in 0..<1000 {
                let obj = JSObject()
                obj["data"] = JSValue.string(String(repeating: "fragment", count: 100))
                
                if i % 10 == 0 {
                    // Long-lived objects
                    longLivedObjects.append(obj)
                } else {
                    // Short-lived objects
                    shortLivedObjects.append(obj)
                }
            }
            
            // Immediately release short-lived objects to create fragmentation
            shortLivedObjects.removeAll()
            
            // Force GC to reclaim fragmented memory
            for _ in 0..<5 {
                gc()
                try await Task.sleep(for: .milliseconds(1))
            }
            
            // Test system can still allocate efficiently after fragmentation
            var recoveryTest: [JSObject] = []
            for i in 0..<500 {
                let obj = JSObject()
                obj["recovery_test"] = JSValue.number(Double(i))
                recoveryTest.append(obj)
            }
            
            // Verify recovery objects work correctly
            for (i, obj) in recoveryTest.enumerated() {
                XCTAssertEqual(obj["recovery_test"], JSValue.number(Double(i)))
            }
            
            recoveryTest.removeAll()
            longLivedObjects.removeAll()
            
            if cycle % 20 == 0 {
                for _ in 0..<10 {
                    gc()
                    try await Task.sleep(for: .milliseconds(5))
                }
            }
        }
    }
}