#!/usr/bin/env bash

set -eo pipefail

if [ "$TRAVIS_PULL_REQUEST" == 'false' ]; then
  echo 'This is a pull request. Skipping deployment.'
  exit 0
fi

if [ "$TRAVIS_PULL_REQUEST" != 'master' ]; then
  echo "This is branch $TRAVIS_BRANCH, not master. Skipping deployment."
  exit 0
fi

artifact_version=$(grep "version.*=" kushki-ios.podspec | cut -d "'" -f 2)
tag_name="v$artifact_version"
found_tag=$(git tag | grep "^$tag_name$" || true)

if [ ! -z "$found_tag" ]; then
  echo "Version $artifact_version already exists. Skipping deployment."
  exit 0
fi

git config user.email j@jreyes.org
git config user.name 'Jonathan Reyes'
git remote add tags-origin "https://$GITHUB_TOKEN@github.com/Kushki/kushki-ios.git"
git tag --annotate "$tag_name" -m "Release for version $artifact_version"
git push tags-origin "$tag_name"
bundle exec pod trunk push
