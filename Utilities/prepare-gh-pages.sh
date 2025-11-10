#!/usr/bin/env bash

mkdir -p ./_site
# Copy all files from ./Examples to ./_site, excluding specified path patterns
rsync -av --progress ./Examples/ ./_site/ --exclude=".build"
cat <<EOF > _site/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="refresh" content="0; url=https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit">
    <title>Redirecting...</title>
</head>
<body>
    <p>If you are not redirected automatically, follow this <a href="https://swiftpackageindex.com/swiftwasm/JavaScriptKit/documentation/javascriptkit">link to JavaScriptKit documentation</a>.</p>
</body>
</html>
EOF

