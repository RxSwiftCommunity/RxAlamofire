RxAlamofire
===

RxAlamofire is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper around the elegant HTTP networking in Swift [Alamofire](https://github.com/Alamofire/Alamofire).

## Getting Started

Wrapping RxSwift around Alamofire makes working with network requests a smoother and nicer task. Alamofire is a very powerful framework and RxSwift add the ability to compose responses in a simple and effective way.

A basic usage is:

```swift
let formatter = NSNumberFormatter()
formatter.numberStyle = .CurrencyStyle
formatter.currencyCode = "USD"
if let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!) {
    
    let observable = Alamofire.request(Method.GET, sourceStringURL).rx_responseJSON()
    observable.observeOn(MainScheduler.sharedInstance)
              .subscribe(next: { json -> Void in
                
                    if let dict = json as? [String: AnyObject] {
                        let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                        if let conversionRate = valDict["USD"] as? Float {
                            self.toTextField?.text = formatter.stringFromNumber(conversionRate * fromValue.floatValue)!
                        }
                    }
                    
                    }, error: { (e) -> Void in
                        self.displayError(e as NSError)
                        
              })

} else {
    self.toTextField.text = "Invalid Input!"
}
```

Composing two requests is also a simple task:

```swift
let postObservable = Alamofire.request(Method.GET, dummyPostURLString).rx_responseJSON()
let commentsObservable = Alamofire.request(Method.GET, dummyCommentsURLString).rx_responseJSON()
self.dummyDataTextView.text = "Loading..."
zip(postObservable, commentsObservable) { postJSON, commentsJSON in
        return (postJSON, commentsJSON)
    }.observeOn(MainScheduler.sharedInstance).subscribe(next: { postJSON, commentsJSON in
        
        let postInfo = NSMutableString()
        if let postDict = postJSON as? [String: AnyObject], let commentsArray = commentsJSON as? Array<[String: AnyObject]> {
            postInfo.appendString("Title: ")
            postInfo.appendString(postDict["title"] as! String)
            postInfo.appendString("\n\n")
            postInfo.appendString(postDict["body"] as! String)
            postInfo.appendString("\n\n\nComments:\n")
            for comment in commentsArray {
                postInfo.appendString(comment["email"] as! String)
                postInfo.appendString(": ")
                postInfo.appendString(comment["body"] as! String)
                postInfo.appendString("\n\n")
            }
        }
        
        self.dummyDataTextView.text = String(postInfo)
    }, error:{ e in
        self.dummyDataTextView.text = "An Error Occurred"
        self.displayError(e as NSError)
    })

```

The previous code will update `dummyDataTextView` only when the 2 requests are completed, if one of them fails, the error will be prompted.

## Status

Currently, the library features the following extensions:

```swift 
// Request - Common Response Handlers
func rx_response(cancelOnDispose: Bool = false) -> Observable<NSData> {}
func rx_responseString(encoding: NSStringEncoding? = nil, cancelOnDispose: Bool = false) -> Observable<String> {}
func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments, cancelOnDispose: Bool = false) -> Observable<AnyObject> {}
func rx_responsePropertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions(), cancelOnDispose: Bool = false) -> Observable<AnyObject> {}

// Upload and Download progress
func rx_progress() -> Observable<(Int64, Int64, Int64)> {}
```

## Installation

There are two ways to install RxAlamofire

### Cocoapods

Just add to your project's `Podfile`:

```
pod 'RxAlamofire'
```

### Manually

To manual install this extension you should get the `RxAlamofire/Source/RxAlamofire.swift` imported into your project, alongside RxSwift and Alamofire.

## Requirements

RxAlamofire requires Swift 2.0 and dedicated versions of Alamofire (2.0) and RxSwift (2.0.0-alpha).