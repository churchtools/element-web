#!/usr/bin/env bash

set -euo pipefail

version="${1:?Usage: ./deployVersion.sh <version>}"
web_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/apps/web" && pwd)"

cd "$web_dir"

rm -rf webapp
DIST_VERSION="$version" ./scripts/package.sh

cd dist
rm -rf "element-$version"
rm -f "webchat-$version.zip"
tar -xzf "element-$version.tar.gz"
cp ../config.churchtools.json "element-$version/config.json"
cd "element-$version"
zip -r "../webchat-$version.zip" .
