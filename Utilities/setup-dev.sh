#!/usr/bin/env bash
#
# Set up a local development environment for JavaScriptKit.
#
# Steps:
#   1. Verify required tools are available (swiftly, swift, jq, npm, make, curl).
#   2. If .swift-version is present, ensure that toolchain is installed via swiftly.
#   3. Resolve a matching Wasm SDK from https://github.com/swiftwasm/swift-sdk-index
#      and install it (idempotent — skipped if already installed).
#   4. Run `make bootstrap` to install JS dependencies.
#   5. Print the SWIFT_SDK_ID so it can be exported for `make unittest`.
#
# The script runs under bash via the shebang. The final `export` instructions
# it prints work unchanged in both bash and zsh.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

INDEX_BASE="https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1"

if [[ -t 1 ]]; then
  C_BLUE=$'\033[1;34m'; C_YELLOW=$'\033[1;33m'; C_RED=$'\033[1;31m'; C_RESET=$'\033[0m'
else
  C_BLUE=''; C_YELLOW=''; C_RED=''; C_RESET=''
fi

log()  { printf '%s==>%s %s\n' "$C_BLUE"   "$C_RESET" "$*"; }
warn() { printf '%swarn:%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
fail() { printf '%serror:%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1${2:+ ($2)}"
}

log "Checking required tools..."
require_cmd curl
require_cmd jq      "install via 'brew install jq' or your package manager"
require_cmd npm     "install Node.js from https://nodejs.org"
require_cmd make
require_cmd swiftly "install from https://www.swift.org/install/macos/swiftly"
require_cmd swift   "install a Swift toolchain via swiftly"
require_cmd swiftc

# 1. Honor a .swift-version pin if the repo has one.
if [[ -f .swift-version ]]; then
  pinned="$(tr -d '[:space:]' < .swift-version)"
  if [[ -n "$pinned" ]]; then
    log "Repo pins Swift $pinned via .swift-version"
    if ! swiftly list 2>/dev/null | grep -qF "$pinned"; then
      log "Installing Swift $pinned via swiftly..."
      swiftly install "$pinned"
    fi
  fi
fi

SWIFT_VERSION_KEY="$(swiftc --version | head -n1)"
log "Active Swift: $SWIFT_VERSION_KEY"

# 2. Resolve a matching Wasm SDK.
log "Resolving Wasm SDK from swift-sdk-index..."
TAG_BY_VERSION="$(curl -fsSL "$INDEX_BASE/tag-by-version.json")"
TAG="$(jq -r --arg v "$SWIFT_VERSION_KEY" '.[$v] // [] | .[-1] // empty' <<<"$TAG_BY_VERSION")"

if [[ -z "$TAG" ]]; then
  cat >&2 <<EOF
${C_RED}error:${C_RESET} no Wasm SDK indexed for '$SWIFT_VERSION_KEY'.

This usually means swiftly resolved a patch version (e.g. 6.3.1) that the
swift-sdk-index hasn't published a Wasm SDK for yet. Try one of:

  - Pin to an indexed version. List indexed versions:
        curl -fsSL '$INDEX_BASE/tag-by-version.json' | jq 'keys'
    Then write the version to .swift-version and run 'swiftly install <ver>'.

  - Use an OSS development snapshot from https://www.swift.org/install/

See https://github.com/swiftwasm/swift-sdk-index for details.
EOF
  exit 1
fi

log "Resolved tag: $TAG"
BUILD_JSON="$(curl -fsSL "$INDEX_BASE/builds/$TAG.json")"
SDK_URL="$(jq -r '."swift-sdks"."wasm32-unknown-wasip1".url' <<<"$BUILD_JSON")"
SDK_CHECKSUM="$(jq -r '."swift-sdks"."wasm32-unknown-wasip1".checksum' <<<"$BUILD_JSON")"
SDK_ID="$(jq -r '."swift-sdks"."wasm32-unknown-wasip1".id' <<<"$BUILD_JSON")"

if swift sdk list 2>/dev/null | grep -qx "$SDK_ID"; then
  log "Wasm SDK already installed: $SDK_ID"
else
  log "Installing Wasm SDK: $SDK_ID"
  swift sdk install "$SDK_URL" --checksum "$SDK_CHECKSUM"
fi

# 3. JS dependencies.
log "Installing JS dependencies (make bootstrap)..."
make bootstrap

cat <<EOF

${C_BLUE}----${C_RESET}
Setup complete.

Run the Wasm unit tests:
    make unittest SWIFT_SDK_ID=$SDK_ID

To avoid passing SWIFT_SDK_ID every time, add the following to your shell
profile (~/.zshrc or ~/.bashrc):
    export SWIFT_SDK_ID=$SDK_ID
EOF
