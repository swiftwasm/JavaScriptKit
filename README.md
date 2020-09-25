# JavaScriptKit

![Run unit tests](https://github.com/swiftwasm/JavaScriptKit/workflows/Run%20unit%20tests/badge.svg?branch=main)

Swift framework to interact with JavaScript through WebAssembly.

## Requirements

This library only supports [`swiftwasm/swift`](https://github.com/swiftwasm/swift) distribution toolchain. Please install Swift for WebAssembly toolchain from [Release Page](https://github.com/swiftwasm/swift/releases)

The toolchains can be installed via [`swiftenv`](https://github.com/kylef/swiftenv) like official nightly toolchain.

e.g.

```sh

$ swiftenv install https://github.com/swiftwasm/swift/releases/download/swift-wasm-5.3-SNAPSHOT-2020-08-10-a/swift-wasm-5.3-SNAPSHOT-2020-08-10-a-osx.tar.gz
$ swift --version
Swift version 5.3-dev (LLVM 09686f232a, Swift 5a196c7f13)
Target: x86_64-apple-darwin19.6.0
```

## Usage

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

let alert = JSObject.global.alert.function!
let document = JSObject.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)

struct Owner: Codable {
  let name: String
}

struct Pet: Codable {
  let age: Int
  let owner: Owner
}

let jsPet = JSObject.global.pet
let swiftPet: Pet = try JSValueDecoder().decode(from: jsPet)

alert("Swift is running on browser!")
```

Please see [Example](https://github.com/swiftwasm/JavaScriptKit/tree/main/Example) directory for more information
