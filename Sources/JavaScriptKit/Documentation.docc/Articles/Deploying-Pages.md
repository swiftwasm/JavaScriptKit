# Deploying Pages

Deploy your applications built with JavaScriptKit to the web.

## Overview

Once you've built your application with JavaScriptKit, you'll need to deploy it to make it accessible on the web. This guide covers the deployment process, including building your application and deploying it to various hosting platforms.

## Building Your Application with Vite

Build your application using [Vite](https://vite.dev/) build tool:

```bash
# Build the Swift package for WebAssembly with release configuration
$ swift package --swift-sdk wasm32-unknown-wasi js -c release

# Create a minimal HTML file (if you don't have one)
$ cat <<EOS > index.html
<!DOCTYPE html>
<html>
<body>
  <script type="module">
    import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
    init();
  </script>
</body>
</html>
EOS

# Install Vite and add the WebAssembly output as a dependency
$ npm install -D vite .build/plugins/PackageToJS/outputs/Package

# Build optimized assets
$ npx vite build
```

This will generate optimized static assets in the `dist` directory, ready for deployment.

## Deployment Options

### GitHub Pages

1. Set up your repository for GitHub Pages in your repository settings and select "GitHub Actions" as source.
2. Create a GitHub Actions workflow to build and deploy your application:

```yaml
name: Deploy to GitHub Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches: [main]

# Sets the GITHUB_TOKEN permissions to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    container: swift:6.0.3
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - uses: actions/configure-pages@v4
        id: pages
      # Install Swift SDK for WebAssembly
      - uses: swiftwasm/setup-swiftwasm@v2
      - name: Build
        run: |
          swift package --swift-sdk wasm32-unknown-wasi js -c release
          npm install
          npx vite build --base "${{ steps.pages.outputs.base_path }}"
      - uses: actions/upload-pages-artifact@v3
        with:
          path: './dist'
      - uses: actions/deploy-pages@v4
        id: deployment
```

## Cross-Origin Isolation Requirements

When using `wasm32-unknown-wasip1-threads` target, you must enable [Cross-Origin Isolation](https://developer.mozilla.org/en-US/docs/Web/API/Window/crossOriginIsolated) by setting the following HTTP headers:

```
Cross-Origin-Embedder-Policy: require-corp
Cross-Origin-Opener-Policy: same-origin
```

These headers are required for SharedArrayBuffer support, which is used by the threading implementation.
