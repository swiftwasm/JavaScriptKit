#!/usr/bin/env bash

set -euo pipefail

EXCLUDED_EXAMPLES=()

for example in Examples/*; do
    skip_example=false
    if ((${#EXCLUDED_EXAMPLES[@]})); then
        for excluded in "${EXCLUDED_EXAMPLES[@]}"; do
            if [[ "$example" == *"$excluded"* ]]; then
                skip_example=true
                break
            fi
        done
    fi
    if [ "$skip_example" = true ]; then
        echo "Skipping $example"
        continue
    fi

    if [ -d "$example" ] && [ -f "$example/build.sh" ]; then
        echo "Building $example"
        set -x
        (cd "$example" && ./build.sh release)
        { set +x; } 2>/dev/null
    fi
done
