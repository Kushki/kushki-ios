#!/usr/bin/env bash

set -e
echo "cocoapods gem version: $(bundle exec pod --version)"
bundle exec pod lib lint
