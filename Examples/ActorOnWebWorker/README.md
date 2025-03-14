# WebWorker + Actor example

Install Development Snapshot toolchain `DEVELOPMENT-SNAPSHOT-2024-07-08-a` or later from [swift.org/install](https://www.swift.org/install/) and run the following commands:

```sh
$ (
  set -eo pipefail; \
  V="$(swiftc --version | head -n1)"; \
  TAG="$(curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/tag-by-version.json" | jq -e -r --arg v "$V" '.[$v] | .[-1]')"; \
  curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/builds/$TAG.json" | \
  jq -r '.["swift-sdks"]["wasm32-unknown-wasip1-threads"] | "swift sdk install \"\(.url)\" --checksum \"\(.checksum)\""' | sh -x
)
$ export SWIFT_SDK_ID=$(
  V="$(swiftc --version | head -n1)"; \
  TAG="$(curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/tag-by-version.json" | jq -e -r --arg v "$V" '.[$v] | .[-1]')"; \
  curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/builds/$TAG.json" | \
  jq -r '.["swift-sdks"]["wasm32-unknown-wasip1-threads"]["id"]'
)
$ ./build.sh
$ npx serve
```
