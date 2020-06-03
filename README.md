# JavaScriptKit

![Run unit tests](https://github.com/kateinoigakukun/JavaScriptKit/workflows/Run%20unit%20tests/badge.svg?branch=master)

Swift framework to interact with JavaScript through WebAssembly.

## Requirements

This library only supports [`swiftwasm/swift`](https://github.com/swiftwasm/swift) distribution toolchain. Please install Swift for WebAssembly toolchain from [Release Page](https://github.com/swiftwasm/swift/releases)

The toolchains can be installed via [`swiftenv`](https://github.com/kylef/swiftenv) like official nightly toolchain.

e.g.
```sh

$ swiftenv install https://github.com/swiftwasm/swift/releases/download/swift-wasm-DEVELOPMENT-SNAPSHOT-2020-05-10-a/swift-wasm-DEVELOPMENT-SNAPSHOT-2020-05-10-a-osx.tar.gz
$ swift --version
Swift version 5.3-dev (LLVM 47c28180d7, Swift 5f96d487e0)
Target: x86_64-apple-darwin19.3.0
```

## Usage

This JavaScript code

```javascript
const alert = window.alert
const document = window.document

const divElement = document.createElement("div")
divElement.innerText = "Hello, world"
const body = document.body
body.appendChild(divElement)

const pet = {
  age: 3,
  owner: {
    name: "Mike",
  },
}

alert("JavaScript is running on browser!")
```

Can be written in Swift using JavaScriptKit

```swift
import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!

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

let jsPet = JSObjectRef.global.pet
let swiftPet: Pet = try JSValueDecoder().decode(from: jsPet)

alert("Swift is running on browser!")
```


Please see [Example](https://github.com/kateinoigakukun/JavaScriptKit/tree/master/Example) directory for more information
