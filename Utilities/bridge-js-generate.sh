#!/usr/bin/env bash

env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package plugin --allow-writing-to-package-directory bridge-js
env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --package-path ./Benchmarks plugin --allow-writing-to-package-directory bridge-js
env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --package-path ./Examples/PlayBridgeJS plugin --allow-writing-to-package-directory bridge-js

