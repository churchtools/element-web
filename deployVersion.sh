#!/bin/bash

yarn build
cp config.churchtools.json config.json
zip -r element-web-$1.zip webapp
