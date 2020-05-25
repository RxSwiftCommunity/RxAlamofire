#!/bin/bash

set -eo pipefail
export LIB_VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
xcodegen
pod install --repo-update
open RxAlamofireDemo.xcworkspace