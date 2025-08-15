# BridgeJSTool (Merged Sources)

This directory contains symlinked sources from `Plugins/BridgeJS` to provide a merged version of the BridgeJSTool for the root Package.swift.

## Source Merging via Symlinks

This module uses symlinks to merge multiple modules into a single compilation unit. Compiling multiple modules separately is much slower than compiling them as one merged module.

Since BridgeJSTool runs during Swift package builds via the BridgeJS plugin, fast compilation is critical for developer experience. The source modules use `#if canImport` directives to work both standalone and when merged here.