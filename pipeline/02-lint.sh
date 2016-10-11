#!/usr/bin/env bash

set -e
bundle exec pod --version
bundle exec pod lib lint
