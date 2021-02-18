#!/bin/bash

yarn build
zip -r element-web-$1.zip webapp
