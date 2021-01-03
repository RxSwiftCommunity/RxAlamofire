#!/usr/bin/env bash

set -euo pipefail
rm -rf xcarchives/*
rm -rf RxAlamofire.xcframework

xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire iOS" -sdk iphoneos -archivePath "xcarchives/RxAlamofire-iOS" clean
# xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire iOS" -sdk iphonesimulator  -archivePath "xcarchives/RxAlamofire-iOS-Simulator" 
xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire tvOS" -sdk appletvos -archivePath "xcarchives/RxAlamofire-tvOS" clean
# xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire tvOS" -sdk appletvsimulator -archivePath "xcarchives/RxAlamofire-tvOS-Simulator" 
xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire macOS" -sdk macosx -archivePath "xcarchives/RxAlamofire-macOS" clean
xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire watchOS" -sdk watchos -archivePath "xcarchives/RxAlamofire-watchOS" clean 
# xcodebuild archive -project RxAlamofire.xcodeproj -scheme "RxAlamofire watchOS" -sdk watchsimulator -archivePath "xcarchives/RxAlamofire-watchOS-Simulator" 

xcodebuild -create-xcframework \
-framework "xcarchives/RxAlamofire-iOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-iOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-tvOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-tvOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-macOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-macOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-watchOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-watchOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-output "RxAlamofire.xcframework" 

zip -r RxAlamofire.xcframework.zip RxAlamofire.xcframework
rm -rf xcarchives/*
rm -rf RxAlamofire.xcframework