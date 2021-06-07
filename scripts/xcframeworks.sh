#!/usr/bin/env bash

set -euo pipefail
rm -rf RxAlamofire-SPM.xcodeproj
rm -rf xcarchives/*
rm -rf RxAlamofire.xcframework.zip
rm -rf RxAlamofire.xcframework

brew bundle

xcodegen --spec project-spm.yml

xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire iOS" -destination "generic/platform=iOS" -archivePath "xcarchives/RxAlamofire-iOS" SKIP_INSTALL=NO SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire iOS" -destination "generic/platform=iOS Simulator" -archivePath "xcarchives/RxAlamofire-iOS-Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire tvOS" -destination "generic/platform=tvOS" -archivePath "xcarchives/RxAlamofire-tvOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire tvOS" -destination "generic/platform=tvOS Simulator"  -archivePath "xcarchives/RxAlamofire-tvOS-Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire macOS" -destination "generic/platform=macOS" -archivePath "xcarchives/RxAlamofire-macOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire watchOS" -destination "generic/platform=watchOS" -archivePath "xcarchives/RxAlamofire-watchOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple
xcodebuild archive -quiet -project RxAlamofire-SPM.xcodeproj -configuration Release -scheme "RxAlamofire watchOS" -destination "generic/platform=watchOS Simulator" -archivePath "xcarchives/RxAlamofire-watchOS-Simulator" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE="bitcode" ENABLE_BITCODE=YES | xcpretty --color --simple

xcodebuild -create-xcframework \
-framework "xcarchives/RxAlamofire-iOS-Simulator.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-iOS-Simulator.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-iOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-iOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-tvOS-Simulator.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-tvOS-Simulator.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-tvOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-tvOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-macOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-macOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-watchOS-Simulator.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-watchOS-Simulator.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-framework "xcarchives/RxAlamofire-watchOS.xcarchive/Products/Library/Frameworks/RxAlamofire.framework" \
-debug-symbols ""$(pwd)"/xcarchives/RxAlamofire-watchOS.xcarchive/dSYMs/RxAlamofire.framework.dSYM" \
-output "RxAlamofire.xcframework" 

zip -r RxAlamofire.xcframework.zip RxAlamofire.xcframework
rm -rf xcarchives/*
rm -rf RxAlamofire.xcframework
rm -rf RxAlamofire-SPM.xcodeproj
