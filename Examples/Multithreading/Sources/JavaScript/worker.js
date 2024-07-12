import { instantiate } from "./instantiate.js"

self.onmessage = async (event) => {
  const { module, memory, tid, startArg, configuration } = event.data;
  const { instance, wasi, swiftRuntime } = await instantiate({
    module,
    threadChannel: {
      postMessageToMainThread: (message) => {
        // Send the job to the main thread
        postMessage(message);
      },
      listenMessageFromMainThread: (listener) => {
        self.onmessage = (event) => listener(event.data);
      }
    },
    addToImports(importObject) {
      importObject["env"] = { memory }
      importObject["wasi"] = {
        "thread-spawn": () => { throw new Error("Cannot spawn a new thread from a worker thread"); }
      };
    },
    configuration
  });

  swiftRuntime.setInstance(instance);
  wasi.inst = instance;
  swiftRuntime.startThread(tid, startArg);
}
