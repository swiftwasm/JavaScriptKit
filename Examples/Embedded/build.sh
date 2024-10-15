#!/bin/bash
package_dir="$(cd "$(dirname "$0")" && pwd)"
JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM=true swift build --package-path "$package_dir" -c release --product EmbeddedApp \
  --triple wasm32-unknown-none-wasm  \
  -Xswiftc -enable-experimental-feature -Xswiftc Embedded \
  -Xswiftc -enable-experimental-feature -Xswiftc Extern \
  -Xcc -D__Embedded -Xcc -fdeclspec \
  -Xlinker --export-if-defined=__main_argc_argv \
  -Xlinker --export-if-defined=swjs_call_host_function \
  -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor
