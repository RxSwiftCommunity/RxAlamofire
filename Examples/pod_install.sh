#!/bin/bash

set -eo pipefail
export RELEASE_VERSION=$(git describe --abbrev=0 | tr -d '\n')
xcodegen
pod install --repo-update
open RxAlamofireDemo.xcworkspace