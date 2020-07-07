# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [5.6.0](https://github.com/RxSwiftCommunity/RxAlamofire/branches/compare/v5.6.0%0Dv5.5.0) (2020-07-07)


### Features

* **#186:** Create Rx extensions mapping to Alamofire response method ([c04ea5b](https://github.com/RxSwiftCommunity/RxAlamofire/commits/c04ea5bfb0f0f7306742f266e24c5f09a12d0f9e)), closes [#186](https://github.com/RxSwiftCommunity/RxAlamofire/issues/186)

## [5.5.0](https://github.com/RxSwiftCommunity/RxAlamofire/branches/compare/v5.5.0%0Dv5.4.0) (2020-06-22)


### Features

* **#183:** Upload extensions ([4db992c](https://github.com/RxSwiftCommunity/RxAlamofire/commits/4db992c6ff1179d957075687f407fcf9e8a28845)), closes [#183](https://github.com/RxSwiftCommunity/RxAlamofire/issues/183)

## [5.4.0](https://github.com/RxSwiftCommunity/RxAlamofire/branches/compare/v5.4.0%0Dv5.3.2) (2020-06-21)


### Features

* **#185:** Support Alamofire Interceptor ([f059d88](https://github.com/RxSwiftCommunity/RxAlamofire/commits/f059d88212e4191ef16567211fdcd3632215c819)), closes [#185](https://github.com/RxSwiftCommunity/RxAlamofire/issues/185)

### [5.3.2](https://github.com/RxSwiftCommunity/RxAlamofire/branches/compare/v5.3.2%0Dv5.3.1) (2020-06-10)


### Bug Fixes

* indentation ([e475215](https://github.com/RxSwiftCommunity/RxAlamofire/commits/e47521554cb501e4a935459da70b63af28f51200))
* To include tag version in buildflow ([de1058d](https://github.com/RxSwiftCommunity/RxAlamofire/commits/de1058d827b131273505d115b3d4404a33887c78))

### [5.3.1](https://github.com/RxSwiftCommunity/RxAlamofire/branches/compare/v5.3.1%0Dv5.3.0) (2020-05-25)

## 5.3.0 (2020-05-25)


### Features

* **#173:** Implement danger and improve PR pipeline ([c75b0ef](https://github.com/RxSwiftCommunity/RxAlamofire/commits/c75b0efd37cd0ae90b465d4f7772ff4ee276b5b3)), closes [#173](https://github.com/RxSwiftCommunity/RxAlamofire/issues/173)
* **#173:** Regenerate project ([ebbfdbe](https://github.com/RxSwiftCommunity/RxAlamofire/commits/ebbfdbe588aa26a1a4b0623e4e68a41c4857d5d5)), closes [#173](https://github.com/RxSwiftCommunity/RxAlamofire/issues/173)
* **#174:** Build pipeline to run on feature and PR ([78115aa](https://github.com/RxSwiftCommunity/RxAlamofire/commits/78115aac1941852ab1f4b8a3d369782948acaf68)), closes [#174](https://github.com/RxSwiftCommunity/RxAlamofire/issues/174)

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
