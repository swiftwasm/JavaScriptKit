# JavaScriptKit

![Run unit tests](https://github.com/swiftwasm/JavaScriptKit/workflows/Run%20unit%20tests/badge.svg?branch=main)

Swift framework to interact with JavaScript through WebAssembly.

## Getting started

This JavaScript code

```javascript
const alert = window.alert;
const document = window.document;

const divElement = document.createElement("div");
divElement.innerText = "Hello, world";
const body = document.body;
body.appendChild(divElement);

const pet = {
  age: 3,
  owner: {
    name: "Mike",
  },
};

alert("JavaScript is running on browser!");
```

Can be written in Swift using JavaScriptKit

```swift
import JavaScriptKit

let document = JSObject.global.document

var divElement = document.createElement("div")
divElement.innerText = "Hello, world"
_ = document.body.appendChild(divElement)

struct Owner: Codable {
  let name: String
}

struct Pet: Codable {
  let age: Int
  let owner: Owner
}

let jsPet = JSObject.global.pet
let swiftPet: Pet = try JSValueDecoder().decode(from: jsPet)

JSObject.global.alert!("Swift is running in the browser!")
```

### `async`/`await`

Starting with SwiftWasm 5.5 you can use `async`/`await` with `JSPromise` objects. This requires
a few additional steps though (you can skip these steps if your app depends on
[Tokamak](https://tokamak.dev)):

1. Make sure that your target depends on `JavaScriptEventLoop` in your `Packages.swift`:

```swift
.target(
    name: "JavaScriptKitExample",
    dependencies: [
        "JavaScriptKit",
        .product(name: "JavaScriptEventLoop", package: "JavaScriptKit")
    ]
)
```

2. Add an explicit import in the code that executes **before* you start using `await` and/or `Task`
APIs (most likely in `main.swift`):

```swift
import JavaScriptEventLoop
```

3. Run this function **before* you start using `await` and/or `Task` APIs (again, most likely in
`main.swift`):

```swift
JavaScriptEventLoop.installGlobalExecutor()
```

## Requirements 

### For developers

- macOS 11 and Xcode 13.0. *Xcode 13.1 is currently not supported.*
- [Swift 5.4 or later](https://swift.org/download/) and Ubuntu 18.04 if you'd like to use Linux.
  Other Linux distributions are currently not supported.

### For users of apps depending 

Any recent browser that [supports WebAssembly](https://caniuse.com/#feat=wasm) and required 
JavaScript features should work, which currently includes:

- Edge 84+
- Firefox 79+
- Chrome 84+
- Desktop Safari 14.1+
- Mobile Safari 14.8+

If you need to support older browser versions, you'll have to build with
`JAVASCRIPTKIT_WITHOUT_WEAKREFS` flag, passing `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` flags
when compiling. This should lower browser requirements to these versions:

- Edge 16+
- Firefox 61+
- Chrome 66+
- (Mobile) Safari 12+

Not all of these versions are tested on regular basis though, compatibility reports are very welcome!

## Usage in a browser application

The easiest way to get started with JavaScriptKit in your browser app is with [the `carton`
bundler](https://carton.dev).

As a part of these steps
you'll install `carton` via [Homebrew](https://brew.sh/) on macOS (you can also use the
[`ghcr.io/swiftwasm/carton`](https://github.com/orgs/swiftwasm/packages/container/package/carton)
Docker image if you prefer to run the build steps on Linux). Assuming you already have Homebrew
installed, you can create a new app that uses JavaScriptKit by following these steps:

1. Install `carton`:

```
brew install swiftwasm/tap/carton
```

If you had `carton` installed before this, make sure you have version 0.6.1 or greater:

```
carton --version
```

2. Create a directory for your project and make it current:

```
mkdir SwiftWasmApp && cd SwiftWasmApp
```

3. Initialize the project from a template with `carton`:

```
carton init --template basic
```

4. Build the project and start the development server, `carton dev` can be kept running
   during development:

```
carton dev
```

5. Open [http://127.0.0.1:8080/](http://127.0.0.1:8080/) in your browser and a developer console
   within it. You'll see `Hello, world!` output in the console. You can edit the app source code in
   your favorite editor and save it, `carton` will immediately rebuild the app and reload all
   browser tabs that have the app open.

You can also build your project with webpack.js and a manually installed SwiftWasm toolchain. Please
see the following sections and the [Example](https://github.com/swiftwasm/JavaScriptKit/tree/main/Example)
directory for more information in this more advanced use case.

## Manual toolchain installation

This library only supports [`swiftwasm/swift`](https://github.com/swiftwasm/swift) toolchain distribution.
The toolchain can be installed via [`swiftenv`](https://github.com/kylef/swiftenv), in
the same way as the official Swift nightly toolchain.

You have to install the toolchain manually when working on the source code of JavaScriptKit itself,
especially if you change anything in the JavaScript runtime parts. This is because the runtime parts are
embedded in `carton` and currently can't be replaced dynamically with the JavaScript code you've
updated locally.

Just pass a toolchain archive URL for [the latest SwiftWasm 5.5
release](https://github.com/swiftwasm/swift/releases) appropriate for your platform:

```sh
$ swiftenv install https://github.com/swiftwasm/swift/releases/download/swift-wasm-5.5.0-RELEASE/swift-wasm-5.5.0-RELEASE-macos_x86_64.pkg
```

You can also use the `install-toolchain.sh` helper script that uses a hardcoded toolchain snapshot:

```sh
$ ./scripts/install-toolchain.sh
$ swift --version
Swift version 5.5 (swiftlang-5.5.0)
Target: arm64-apple-darwin20.6.0
```
