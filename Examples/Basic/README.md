# Basic example

Install Development Snapshot toolchain `DEVELOPMENT-SNAPSHOT-2024-07-08-a` from [swift.org/install](https://www.swift.org/install/) and run the following commands:

```sh
$ swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-07-09-a/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-07-09-a-wasm32-unknown-wasi.artifactbundle.zip
$ ./build.sh
$ npx serve
```

## Re-generating BridgeJS code

You need to re-generate files under `Sources/Generated` when you make changes to bridged interfaces:

```sh
$ swift package plugin --allow-writing-to-package-directory bridge-js
```

