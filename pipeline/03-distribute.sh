#!/usr/bin/env bash

set -eo pipefail

# Travis CI switches back to an old Ruby version for deployments. See:
# https://docs.travis-ci.com/user/deployment/script/#Deployment-is-executed-by-Ruby-1.9.3
echo "start distribute"
# source ~/.rvm/scripts/rvm
rvm use default
echo "cocoapods gem version: $(pod --version)"
artifact_version=$(grep "version.*=" Kushki.podspec | cut -d "'" -f 2)
tag_name="v$artifact_version"
found_tag=$(git tag | grep "^$tag_name$" || true)

if [ ! -z "$found_tag" ]; then
  echo "Version $artifact_version already exists. Skipping deployment."
  exit 0
fi

git config --global user.email seguridad@kushkipagos.com
git config --global user.name “segKushki”
git config --global user.password "FDE5GLuQzZdrzqLLTp37"
git remote add tags-origin "https://segKushki@bitbucket.org/kushki/kushki-ios.git"
git tag --annotate "$tag_name" -m "Release for version $artifact_version"
git push tags-origin "$tag_name"	
pod trunk push
