#!/bin/bash

version=$1

DIST_VERSION=$version ./scripts/package.sh
cd dist
tar -xvzf element-$version.tar.gz
cd ..
cp config.churchtools.json dist/element-$version/config.json
cd dist/element-$version && zip -r ../webchat-$version.zip .
