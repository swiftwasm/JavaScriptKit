# Introducing BridgeJS

Faster, easier Swift–JavaScript bridging for WebAssembly.

## Overview

**BridgeJS** is a layer underneath JavaScriptKit that makes Swift–JavaScript interop **faster and easier**: you declare the shape of the API in Swift (or in TypeScript, which generates Swift), and the tool generates glue code.

Benefits over the dynamic `JSObject` / `JSValue` APIs include:

- **Performance** - Generated code is specialized per interface, so crossing the bridge typically costs less than using generic dynamic APIs.
- **Type safety** - Mistakes are caught at compile time instead of at runtime.
- **Easier integration** - Declarative annotations and optional TypeScript input replace manual boilerplate (closures, serializers, cached strings).

You can still use the dynamic APIs when you need them; BridgeJS is an additional option for boundaries where you want strong typing and better performance.

## Two directions

BridgeJS supports both directions of the bridge:

1. **Export Swift to JavaScript** - Expose Swift functions, classes, and types to JavaScript using the ``JS(namespace:enumStyle:)`` macro. JavaScript can then call into your Swift code. See <doc:Exporting-Swift-to-JavaScript>.
2. **Import JavaScript into Swift** - Make JavaScript APIs (functions, classes, globals like `document` or `console`) callable from Swift with macros such as ``JSClass(jsName:from:)``. Start with <doc:Importing-JavaScript-into-Swift>. You can also generate the same bindings from a TypeScript file; see <doc:Generating-from-TypeScript>.

Many apps use both: import DOM or host APIs into Swift, and export an entry point or callbacks to JavaScript.

## Getting started

- To **call Swift from JavaScript**: <doc:Exporting-Swift-to-JavaScript>
- To **call JavaScript from Swift**: <doc:Importing-JavaScript-into-Swift>
- To **generate bindings from TypeScript**: <doc:Generating-from-TypeScript>

All require the same package and build setup; see <doc:Setting-up-BridgeJS> for configuration.
