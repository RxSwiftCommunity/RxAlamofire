RxAlamofire
===

RxAlamofire is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper around the elegant HTTP networking in Swift [Alamofire](https://github.com/Alamofire/Alamofire).

[![CircleCI](https://img.shields.io/circleci/project/github/RxSwiftCommunity/RxAlamofire/master.svg)](https://circleci.com/gh/RxSwiftCommunity/RxAlamofire/tree/master)
[![Version](https://img.shields.io/cocoapods/v/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![License](https://img.shields.io/cocoapods/l/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![Platform](https://img.shields.io/cocoapods/p/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Getting Started

Wrapping RxSwift around Alamofire makes working with network requests a smoother and nicer task. Alamofire is a very powerful framework and RxSwift add the ability to compose responses in a simple and effective way.

A basic usage is (considering a simple currency converter):

```swift
let formatter = NSNumberFormatter()
formatter.numberStyle = .currencyStyle
formatter.currencyCode = "USD"
if let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!) {

RxAlamofire.requestJSON(.get, sourceStringURL)
                .debug()
                .subscribe(onNext: { [weak self] (r, json) in
                    if let dict = json as? [String: AnyObject] {
                        let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                        if let conversionRate = valDict["USD"] as? Float {
                            self?.toTextField.text = formatter
                                .string(from: NSNumber(value: conversionRate * fromValue))
                        }
                    }
                    }, onError: { [weak self] (error) in
                        self?.displayError(error as NSError)
                })
                .disposed(by: disposeBag)

} else {
    self.toTextField.text = "Invalid Input!"
}
```

## Example Usages

Currently, the library features the following extensions:

```swift
let stringURL = ""

// MARK: URLSession simple and fast
let session = URLSession.shared()

_ = session.rx
    .json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

_ = session.rx
    .data(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// MARK: With Alamofire engine

_ = json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// validation
_ = request(.get, stringURL)
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
    .responseJSON()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// progress
_ = request(.get, stringURL)
    .progress()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// just fire upload and display progress
_ = upload(Data(), urlRequest: try! RxAlamofire.urlRequest(.get, stringURL))
    .progress()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// progress and final result
// uploading files with progress showing is processing intensive operation anyway, so
// this doesn't add much overhead
_ = request(.get, stringURL)
    .flatMap { request -> Observable<(Data?, RxProgress)> in
        let dataPart = request.rx
            .data()
            .map { d -> Data? in d }
            .startWith(nil as Data?)
        let progressPart = request.rx.progress()
        return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }


// MARK: Alamofire manager
// same methods with any alamofire manager

let manager = SessionManager.default

// simple case
_ = manager.rx.json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + JSON
_ = manager.rx.responseJSON(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + String
_ = manager.rx.responseString(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + JSON
_ = manager.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/json"])
    .json()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + URLHTTPResponse + JSON
_ = manager.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/json"])
    .responseJSON()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + URLHTTPResponse + String + Progress
_ = manager.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/something"])
    .flatMap { request -> Observable<(String?, RxProgress)> in
        let stringPart = request.rx
            .string()
            .map { d -> String? in d }
            .startWith(nil as String?)
        let progressPart = request.rx.progress()
        return Observable.combineLatest(stringPart, progressPart) { ($0, $1) }
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }
```

## Installation

There are three ways to install RxAlamofire

### CocoaPods

Just add to your project's `Podfile`:

```
pod 'RxAlamofire'
```

### Carthage

Add following to `Cartfile`:

```
github "RxSwiftCommunity/RxAlamofire" ~> 5.0
```

### Swift Package manager

Create a `Package.swift`  file

```
// swift-tools-version:4.0

import PackageDescription

let package = Package(
        name: "TestRxAlamofire",

        dependencies: [
            .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git",
                     from: "4.4.1"),
        ],

        targets: [
            .target(
                    name: "TestRxAlamofire",
                    dependencies: ["RxAlamofire"])
        ]
)

```

### Manually

To manual install this extension you should get the `RxAlamofire/Source/RxAlamofire.swift` imported into your project, alongside RxSwift and Alamofire.

## Requirements

RxAlamofire requires Swift 5.0 and dedicated versions of Alamofire (4.8.2) and RxSwift (5.0.0).

For the last Swift 4.2 support, please use RxAlamofire 4.5.0.



RxAlamofire (Korean)
===

RxAlamofire는 Swift [Alamofire](https://github.com/Alamofire/Alamofire)의 우아한 HTTP 네트워킹을 중심으로 한 RxSwift 기반의 라이브러리입니다.

[![CircleCI](https://img.shields.io/circleci/project/github/RxSwiftCommunity/RxAlamofire/master.svg)](https://circleci.com/gh/RxSwiftCommunity/RxAlamofire/tree/master)
[![Version](https://img.shields.io/cocoapods/v/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![License](https://img.shields.io/cocoapods/l/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![Platform](https://img.shields.io/cocoapods/p/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## 시작하기

Alamofire라이브러리에 RxSwift를 적용하는 것은 네트워크 요청을 더욱 더 유연하고 멋있게 수행할 수 있도록 해줍니다.
Alamofire는 가장 강력한 프레임워크이며 RxSwift를 사용함으로써 더욱 더 단순하고 효과적인 방법으로 응답을 구성할 수 있게 됩니다.

기본적인 사용법은 다음과 같습니다.
(considering a simple currency converter):

```swift
let formatter = NSNumberFormatter()
formatter.numberStyle = .currencyStyle
formatter.currencyCode = "USD"
if let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!) {

RxAlamofire.requestJSON(.get, sourceStringURL)
                .debug()
                .subscribe(onNext: { [weak self] (r, json) in
                    if let dict = json as? [String: AnyObject] {
                        let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                        if let conversionRate = valDict["USD"] as? Float {
                            self?.toTextField.text = formatter
                                .string(from: NSNumber(value: conversionRate * fromValue))
                        }
                    }
                    }, onError: { [weak self] (error) in
                        self?.displayError(error as NSError)
                })
                .disposed(by: disposeBag)

} else {
    self.toTextField.text = "Invalid Input!"
}
```

## 사용 예제

현재 이 라이브러리는 다음과 같은 기능을 제공하고 있습니다.

```swift
let stringURL = ""

// MARK: URLSession simple and fast
let session = URLSession.shared()

_ = session.rx
    .json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

_ = session.rx
    .data(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// MARK: With Alamofire engine

_ = json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// validation
_ = request(.get, stringURL)
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
    .responseJSON()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// progress
_ = request(.get, stringURL)
    .progress()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// just fire upload and display progress
_ = upload(Data(), urlRequest: try! RxAlamofire.urlRequest(.get, stringURL))
    .progress()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// progress and final result
// uploading files with progress showing is processing intensive operation anyway, so
// this doesn't add much overhead
_ = request(.get, stringURL)
    .flatMap { request -> Observable<(Data?, RxProgress)> in
        let dataPart = request.rx
            .data()
            .map { d -> Data? in d }
            .startWith(nil as Data?)
        let progressPart = request.rx.progress()
        return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }


// MARK: Alamofire manager
// same methods with any alamofire manager

let manager = SessionManager.default

// simple case
_ = manager.rx.json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + JSON
_ = manager.rx.responseJSON(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + String
_ = manager.rx.responseString(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + JSON
_ = manager.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/json"])
    .json()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + URLHTTPResponse + JSON
_ = manager.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/json"])
    .responseJSON()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + URLHTTPResponse + String + Progress
_ = manager.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/something"])
    .flatMap { request -> Observable<(String?, RxProgress)> in
        let stringPart = request.rx
            .string()
            .map { d -> String? in d }
            .startWith(nil as String?)
        let progressPart = request.rx.progress()
        return Observable.combineLatest(stringPart, progressPart) { ($0, $1) }
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }
```

## 설치하기

3가지 방법으로 RxAlamofire를 설치할 수 있습니다.

### CocoaPods

여러분의 프로젝트 폴더 내의 `Podfile`에 다음을 추가하십시오.

```
pod 'RxAlamofire'
```

### Carthage

프로젝트 폴더 내의 `Cartfile`에 다음을 추가하십시오.

```
github "RxSwiftCommunity/RxAlamofire" ~> 5.0
```

### Swift Package manager

`Package.swift`  파일을 생성하십시오.

```
// swift-tools-version:4.0

import PackageDescription

let package = Package(
        name: "TestRxAlamofire",

        dependencies: [
            .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git",
                     from: "4.4.1"),
        ],

        targets: [
            .target(
                    name: "TestRxAlamofire",
                    dependencies: ["RxAlamofire"])
        ]
)

```

### 직접 설치하기(수동)

이 확장을 수동으로 설치하려면 RxSwift 및 Alamofire와 함께 프로젝트에 `RxAlamofire/Source/RxAlamofire.swift`를 가져와야합니다.

## 요구 사항

RxAlamofire에는 Swift 5.0과 Alamofire (4.8.2) 및 RxSwift (5.0.0) 버전이 필요합니다.

Swift 4.2 버전을 사용하고 계신다면, RxAlamofire 4.5.0버전을 사용해주시기 바랍니다.
