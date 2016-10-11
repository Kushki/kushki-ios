#!/usr/bin/env bash

set -eo pipefail
xcodebuild test -workspace Example/kushki-ios.xcworkspace -scheme kushki-ios-Example \
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=10.0' -sdk iphonesimulator10.0 \
  ONLY_ACTIVE_ARCH=NO | xcpretty
