#!/bin/bash

yarn build
cp config.churchtools.json webapp/config.json
echo $1 > webapp/version
zip -r element-web-$1.zip webapp
