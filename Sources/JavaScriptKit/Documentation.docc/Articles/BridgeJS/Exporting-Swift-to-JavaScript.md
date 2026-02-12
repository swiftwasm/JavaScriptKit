# Exporting Swift to JavaScript

Learn how to make your Swift code callable from JavaScript.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS allows you to expose Swift functions, classes, and methods to JavaScript by using the ``JS(namespace:enumStyle:)`` attribute. This enables JavaScript code to call into Swift code running in WebAssembly.

Configure your package and build for JavaScript as described in <doc:Setting-up-BridgeJS>. Then use the topics below to expose Swift types and functions to JavaScript.

## Topics

- <doc:Exporting-Swift-Function>
- <doc:Exporting-Swift-Class>
- <doc:Exporting-Swift-Struct>
- <doc:Exporting-Swift-Array>
- <doc:Exporting-Swift-Enum>
- <doc:Exporting-Swift-Closure>
- <doc:Exporting-Swift-Protocols>
- <doc:Exporting-Swift-Optional>
- <doc:Exporting-Swift-Default-Parameters>
- <doc:Exporting-Swift-Static-Functions>
- <doc:Exporting-Swift-Static-Properties>
- <doc:Using-Namespace>

## See Also

- ``JS(namespace:enumStyle:)``
