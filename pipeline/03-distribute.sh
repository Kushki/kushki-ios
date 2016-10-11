#!/usr/bin/env bash
set -eo pipefail

artifact_version=$(grep "version.*=" kushki-ios.podspec | cut -d "'" -f 2)
found_tag=$(git tag | grep "^v$artifact_version$" || true)

if [ -z "$found_tag" ]; then
  git tag --annotate "v$artifact_version" -m "Release for version $artifact_version"
  git push --tags
  bundle exec pod trunk push
else
  echo "Version $artifact_version already exists, therefore not deploying."
fi
