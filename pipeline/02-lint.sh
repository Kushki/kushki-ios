#!/usr/bin/env bash

set -e
echo "cocoapods gem version: $(pod --version)"
echo "GITHUB_TOKEN: $GITHUB_TOKEN"
pod lib lint
