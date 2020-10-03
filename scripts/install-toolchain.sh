#!/bin/bash
set -eu

scripts_dir="$(cd "$(dirname $0)" && pwd)"

swift_version="$(cat $scripts_dir/../.swift-version)"
swift_tag="swift-$swift_version"

if [ -z "$(which swiftenv)" ]; then
  echo "swiftenv not installed, please install it before this script."
  exit 1
fi

if [ ! -z "$(swiftenv versions | grep $swift_version)" ]; then
  echo "$swift_version is already installed."
  exit 0
fi

case $(uname -s) in
  Darwin)
    toolchain_download="$swift_tag-osx.tar.gz"
  ;;
  Linux)
    if [ $(grep RELEASE /etc/lsb-release) == "DISTRIB_RELEASE=18.04" ]; then
      toolchain_download="$swift_tag-ubuntu18.04.tar.gz"
    elif [ $(grep RELEASE /etc/lsb-release) == "DISTRIB_RELEASE=20.04" ]; then
      toolchain_download="$swift_tag-ubuntu20.04.tar.gz"
    else
      echo "Unknown Ubuntu version"
      exit 1
    fi
  ;;
  *)
    echo "Unrecognised platform $(uname -s)"
    exit 1
  ;;
esac

toolchain_download_url="https://github.com/swiftwasm/swift/releases/download/$swift_tag/$toolchain_download"

swiftenv install "$toolchain_download_url"
