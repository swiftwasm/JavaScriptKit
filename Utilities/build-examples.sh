#!/usr/bin/env bash

set -euo pipefail

for example in Examples/*; do
    if [ -d "$example" ] && [ -f "$example/build.sh" ]; then
        echo "Building $example"
        set -x
        (cd "$example" && ./build.sh release)
        { set +x; } 2>/dev/null
    fi
done