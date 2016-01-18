RxAlamofire
===

RxAlamofire is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper around the elegant HTTP networking in Swift [Alamofire](https://github.com/Alamofire/Alamofire).

## Getting Started

Wrapping RxSwift around Alamofire makes working with network requests a smoother and nicer task. Alamofire is a very powerful framework and RxSwift add the ability to compose responses in a simple and effective way.

A basic usage is (considering a simple currency converter):

```swift
let formatter = NSNumberFormatter()
formatter.numberStyle = .CurrencyStyle
formatter.currencyCode = "USD"
if let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!) {

    requestJSON(Method.GET, sourceStringURL)
        .observeOn(MainScheduler.instance)
        .debug()
        .subscribe(onNext: { (r, json) -> Void in
                if let dict = json as? [String: AnyObject] {
                    let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                    if let conversionRate = valDict["USD"] as? Float {
                        self.toTextField?.text = formatter.stringFromNumber(conversionRate * fromValue.floatValue)!
                    }
                }
                
                }, onError: { (e) -> Void in
                    self.displayError(e as? RxAlamofireError)
                    
          }).addDisposableTo(disposeBag)

} else {
    self.toTextField.text = "Invalid Input!"
}
```

## Example Usages

Currently, the library features the following extensions:

```swift 
let stringURL = ""

// MARK: NSURLSession simple and fast
let session = NSURLSession.sharedSession()

_ = session
    .rx_JSON(.GET, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

_ = session
    .rx_data(.GET, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// MARK: With Alamofire engine

_ = JSON(.GET, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

_ = request(.GET, stringURL)
    .flatMap {
        $0
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/json"])
            .rx_JSON()
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// progress
_ = request(.GET, stringURL)
    .flatMap {
        $0
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/json"])
            .rx_progress()
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// just fire upload and display progress
_ = upload(try! URLRequest(.GET, stringURL), data: NSData())
    .flatMap {
        $0
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/json"])
            .rx_progress()
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// progress and final result
// uploading files with progress showing is processing intensive operation anyway, so
// this doesn't add much overhead
_ = request(.GET, stringURL)
    .flatMap { request -> Observable<(NSData?, RxProgress)> in
        let validatedRequest = request
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/json"])
        
        let dataPart = validatedRequest
            .rx_data()
            .map { d -> NSData? in d }
            .startWith(nil as NSData?)
        let progressPart = validatedRequest.rx_progress()
        return combineLatest(dataPart, progressPart) { ($0, $1) }
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }


// MARK: Alamofire manager
// same methods with with any alamofire manager

let manager = Manager.sharedInstance

// simple case
_ = manager.rx_JSON(.GET, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }


// NSURLHTTPResponse + JSON
_ = manager.rx_responseJSON(.GET, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// NSURLHTTPResponse + String
_ = manager.rx_responseString(.GET, stringURL)
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// NSURLHTTPResponse + Validation + String
_ = manager.rx_request(.GET, stringURL)
    .flatMap {
        $0
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/json"])
            .rx_string()
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// NSURLHTTPResponse + Validation + NSURLHTTPResponse + String
_ = manager.rx_request(.GET, stringURL)
    .flatMap {
        $0
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/json"])
            .rx_responseString()
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// NSURLHTTPResponse + Validation + NSURLHTTPResponse + String + Progress
_ = manager.rx_request(.GET, stringURL)
    .flatMap { request -> Observable<(String?, RxProgress)> in
        let validatedRequest = request
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/something"])
        
        let stringPart = validatedRequest
            .rx_string()
            .map { d -> String? in d }
            .startWith(nil as String?)
        let progressPart = validatedRequest.rx_progress()
        return combineLatest(stringPart, progressPart) { ($0, $1) }
    }
    .observeOn(MainScheduler.instance)
    .subscribe { print($0) }

// MARK: wrapping of some request that isn't explicitly wrapped

_ = manager.rx_request { manager in
    return manager.request(try URLRequest(.GET, "wonderland"))
    }.flatMap { request in
        return request.rx_responseString()
}
```

## Installation

There are two ways to install RxAlamofire

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

### Manually

To manual install this extension you should get the `RxAlamofire/Source/RxAlamofire.swift` imported into your project, alongside RxSwift and Alamofire.

## Requirements

RxAlamofire requires Swift 2.0 and dedicated versions of Alamofire (2.0) and RxSwift (2.0.0-beta).
