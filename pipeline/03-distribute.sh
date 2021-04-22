#!/usr/bin/env bash

set -eo pipefail

# Travis CI switches back to an old Ruby version for deployments. See:
# https://docs.travis-ci.com/user/deployment/script/#Deployment-is-executed-by-Ruby-1.9.3
echo "start distribute"
# source ~/.rvm/scripts/rvm
# rvm use default
echo "cocoapods gem version: $(pod --version)"
artifact_version=$(grep "version.*=" Kushki.podspec | cut -d "'" -f 2)
tag_name="v$artifact_version"
found_tag=$(git tag | grep "^$tag_name$" || true)
echo "tag_name: $tag_name"
echo "found_tag: $found_tag"
echo "artifact_version: $artifact_version"

if [ ! -z "$found_tag" ]; then
  echo "Version $artifact_version already exists. Skipping deployment."
  exit 0
fi
	
pod trunk push