RxAlamofire
===

RxAlamofire is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper around the elegant HTTP networking in Swift [Alamofire](https://github.com/Alamofire/Alamofire).

![Create release](https://github.com/RxSwiftCommunity/RxAlamofire/workflows/Create%20release/badge.svg)
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
    .response(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

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


// MARK: Alamofire Session
// same methods with any Alamofire Session

let session = Session.default

// simple case
_ = session.rx.json(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + JSON
_ = session.rx.responseJSON(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + String
_ = session.rx.responseString(.get, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + JSON
_ = session.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/json"])
    .json()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + URLHTTPResponse + JSON
_ = session.rx.request(.get, stringURL)
    .validate(statusCode: 200 ..< 300)
    .validate(contentType: ["text/json"])
    .responseJSON()
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// URLHTTPResponse + Validation + URLHTTPResponse + String + Progress
_ = session.rx.request(.get, stringURL)
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

// Interceptor + URLHTTPResponse + Validation + JSON
let adapter = // Some RequestAdapter
let retrier = // Some RequestRetrier
let interceptor = Interceptor(adapter: adapter, retrier: retrier)
_ = session.rx.request(.get, stringURL)
    .validate()
    .validate(contentType: ["text/json"])
    .responseJSON()
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
github "RxSwiftCommunity/RxAlamofire" ~> 5.3
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
                     from: "5.3.1"),
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

RxAlamofire requires Swift 5.1 and dedicated versions of Alamofire (5.1.0) and RxSwift (5.1.0).

For the last Swift 5.0 support, please use RxAlamofire 5.1.0.

For the last Swift 4.2 support, please use RxAlamofire 4.5.0.
