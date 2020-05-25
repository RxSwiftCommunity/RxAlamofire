# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### 1.0.1 (2020-05-25)

## 5.2.0 (2020-04-18)

#### Updated
* Uses Alamafire 5.1.0
* Uses RxSwift 5.1.0
* Upgrade project to Swift 5.1

## 5.1.0

#### Updated

* Add response methods for `Observable<DownloadRequest>`.

#### Fixed

* Fixed exchange rate api error in example project

## 5.0.0

#### Updated
* Support macOS and watchOS through Carthage 
* Added Example projects for macOS and watchOS 
* Uses RxSwift 5.0.0
* Upgrade project to Swift 5.0

## 4.5.0

#### Fixed
*  Minimum Swift version is 4.2 (More details in #144)

## 4.4.1

#### Updated
* RxSwift updated to 4.5.0 to officially support Xcode 10.2.

## 4.4.0

#### Updated
* Example project now compatible with Swift 5.0.

## 4.3.0

#### Updated
* Project updated to Xcode 10.0.
* Example project now compatible with Swift 4.2.

#### Fixed

## 4.2.0

#### Updated
* Project updated to Xcode 9.3.

#### Fixed
* Fix progress() to correctly support all request types.

## 4.1.0

#### Updated

* Rename `RxProgress.totalBytesWritten` to `RxProgress.bytesRemaining`.
* Rename `RxProgress.totalBytesExpectedToWrite` to `RxProgress.totalBytes`.
* Convert `RxProgress.bytesRemaining` from a stored- to a computed-property.
* Convert `RxProgress.floatValue` from a function to a computed-property.
* Add `Equatable` conformation to `RxProgress`.
* Add Swift Package Manager support.
* Add helper methods for validation to `Observable<DataRequest>`.
* Add helper methods for common response types to `Observable<DataRequest>`.

#### Fixed

* Fix SPM Support
* Unify download and upload progress handling.
* Fix `Reactive<DataRequest>.progress` logic so it actually completes.
