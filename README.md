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

_ = JSObject.global.alert!("Swift is running in the browser!")
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
        .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
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

Then you can `await` on the `value` property of `JSPromise` instances, like in the example below:

```swift
import JavaScriptKit
import JavaScriptEventLoop

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

private let jsFetch = JSObject.global.fetch.function!
func fetch(_ url: String) -> JSPromise {
    JSPromise(jsFetch(url).object!)!
}

JavaScriptEventLoop.installGlobalExecutor()

struct Response: Decodable {
    let uuid: String
}

var asyncButtonElement = document.createElement("button")
asyncButtonElement.innerText = "Fetch UUID demo"
asyncButtonElement.onclick = .object(JSClosure { _ in
    Task {
        do {
            let response = try await fetch("https://httpbin.org/uuid").value
            let json = try await JSPromise(response.json().object!)!.value
            let parsedResponse = try JSValueDecoder().decode(Response.self, from: json)
            alert(parsedResponse.uuid)
        } catch {
            print(error)
        }
    }

    return .undefined
})

_ = document.body.appendChild(asyncButtonElement)
```

### `JavaScriptEventLoop` activation in XCTest suites

If you need to execute Swift async functions that can be resumed by JS event loop in your XCTest suites, please add `JavaScriptEventLoopTestSupport` to your test target dependencies.

```diff
 .testTarget(
   name: "MyAppTests",
   dependencies: [
     "MyApp",
+    "JavaScriptEventLoopTestSupport",
   ]
 )
```

Linking this module automatically activates JS event loop based global executor by calling `JavaScriptEventLoop.installGlobalExecutor()`


## Requirements 

### For developers

- macOS 11 and Xcode 13.2 or later versions, which support Swift Concurrency back-deployment. 
To use earlier versions of Xcode on macOS 11 you'll have to 
add `.unsafeFlags(["-Xfrontend", "-disable-availability-checking"])` in `Package.swift` manifest of
your package that depends on JavaScriptKit. You can also use Xcode 13.0 and 13.1 on macOS Monterey,
since this OS does not need back-deployment.
- [Swift 5.5 or later](https://swift.org/download/) and Ubuntu 18.04 if you'd like to use Linux.
  Other Linux distributions are currently not supported.

### For users of apps depending on JavaScriptKit

Any recent browser that [supports WebAssembly](https://caniuse.com/#feat=wasm) and required 
JavaScript features should work, which currently includes:

- Edge 84+
- Firefox 79+
- Chrome 84+
- Desktop Safari 14.1+
- Mobile Safari 14.8+

If you need to support older browser versions, you'll have to build with
the `JAVASCRIPTKIT_WITHOUT_WEAKREFS` flag, passing `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` flags
when compiling. This should lower browser requirements to these versions:

- Edge 16+
- Firefox 61+
- Chrome 66+
- (Mobile) Safari 12+

Not all of these versions are tested on regular basis though, compatibility reports are very welcome!

## Usage in a browser application

The easiest way to get started with JavaScriptKit in your browser app is with [the `carton`
bundler](https://carton.dev). Add carton to your swift package dependencies:

```diff
dependencies: [
+    .package(url: "https://github.com/swiftwasm/carton", from: "1.0.0"),
],
```

Now you can activate the package dependency through swift:

```
swift run carton dev
```

If you have multiple products in your package, you can also used the product flag:

```
swift run carton dev --product MyApp
```

> [!WARNING]
> - If you already use `carton` before 0.x.x versions via Homebrew, you can remove it with `brew uninstall carton` and install the new version as a SwiftPM dependency.
> - Also please remove the old `.build` directory before using the new `carton`

<details><summary>Legacy Installation</summary>

---

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

---

</details>

Open [http://127.0.0.1:8080/](http://127.0.0.1:8080/) in your browser and a developer console
within it. You'll see `Hello, world!` output in the console. You can edit the app source code in
your favorite editor and save it, `carton` will immediately rebuild the app and reload all
browser tabs that have the app open.

You can also build your project with webpack.js and a manually installed SwiftWasm toolchain. Please
see the following sections and the [Example](https://github.com/swiftwasm/JavaScriptKit/tree/main/Example)
directory for more information in this more advanced use case.

## Sponsoring

[Become a gold or platinum sponsor](https://github.com/sponsors/swiftwasm/) and contact maintainers to add your logo on our README on Github with a link to your site.


<a href="https://www.emergetools.com/">
  <img src="https://github.com/swiftwasm/swift/raw/swiftwasm-distribution/assets/sponsors/emergetools.png" width="30%">
</a>
