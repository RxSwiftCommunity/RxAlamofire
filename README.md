RxAlamofire
===

RxAlamofire is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper around the elegant HTTP networking in Swift [Alamofire](https://github.com/Alamofire/Alamofire).

[![CircleCI](https://circleci.com/gh/RxSwiftCommunity/RxAlamofire.svg?style=svg)](https://circleci.com/gh/RxSwiftCommunity/RxAlamofire)
[![Version](https://img.shields.io/cocoapods/v/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![License](https://img.shields.io/cocoapods/l/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)
[![Platform](https://img.shields.io/cocoapods/p/RxAlamofire.svg?style=flat)](http://cocoapods.org/pods/RxAlamofire)

## Getting Started

Wrapping RxSwift around Alamofire makes working with network requests a smoother and nicer task. Alamofire is a very powerful framework and RxSwift add the ability to compose responses in a simple and effective way.

A basic usage is (considering a simple currency converter):

```swift
let formatter = NSNumberFormatter()
formatter.numberStyle = .CurrencyStyle
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
github "RxSwiftCommunity/RxAlamofire" "master"
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
                     from: "4.0.0"),
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

RxAlamofire requires Swift 4.0 and dedicated versions of Alamofire (4.5.1) and RxSwift (4.0.0-beta.0).
