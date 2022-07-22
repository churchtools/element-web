#!/bin/bash

yarn build
cp config.churchtools.json webapp/config.json
echo $1 > webapp/version
cd webapp/ && zip -r ../webchat-$1.zip .
