#!/usr/bin/env bash

set -eo pipefail
xcodebuild test -workspace Example/kushki-ios.xcworkspace -scheme kushki-ios-Example
  -destination 'platform=iOS Simulator,name=iPhone XR,OS=12.1' -sdk iphonesimulator \
  ONLY_ACTIVE_ARCH=NO | xcpretty -c 
