#!/usr/bin/env bash

set -eo pipefail
xcodebuild test -workspace Example/kushki-ios.xcworkspace -scheme kushki-ios-Example \
  -destination 'platform=iOS Simulator,name=iPhone 11,OS=15.2' -sdk iphonesimulator \
  ONLY_ACTIVE_ARCH=NO -allowProvisioningUpdates
