#!/usr/bin/env bash

set -e
echo "cocoapods gem version: $(pod --version)"
pod lib lint