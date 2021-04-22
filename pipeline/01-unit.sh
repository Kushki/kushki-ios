#!/usr/bin/env bash

set -eo pipefail
xcodebuild test -workspace Example/kushki-ios.xcworkspace -scheme kushki-ios-Example \
  -destination 'platform=iOS Simulator,name=iPhone 8,OS=14.3' -sdk iphonesimulator \
  ONLY_ACTIVE_ARCH=NO -allowProvisioningUpdates
