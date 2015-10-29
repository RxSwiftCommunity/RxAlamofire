//
//  MasterViewController.swift
//  RxAlamofire
//
//  Created by Junior B. on 23/08/15.
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxAlamofire

class MasterViewController: UIViewController, UITextFieldDelegate {
    
    let sourceStringURL = "http://api.fixer.io/latest?base=EUR&symbols=USD"
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var dummyDataBtn: UIButton!
    @IBOutlet weak var dummyDataTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Actions
    
    @IBAction func convertPressed(sender: UIButton) {
        fromTextField.resignFirstResponder()
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = "USD"
        if let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!) {

            RxAlamofire.requestJSON(Method.GET, sourceStringURL)
                .observeOn(MainScheduler.sharedInstance)
                .debug()
                .subscribe(onNext: { (r, json) -> Void in
                        if let dict = json as? [String: AnyObject] {
                            let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                            if let conversionRate = valDict["USD"] as? Float {
                                self.toTextField?.text = formatter.stringFromNumber(conversionRate * fromValue.floatValue)!
                            }
                        }
                        
                        }, onError: { (e) -> Void in
                            self.displayError(e as NSError)
                            
                  }).addDisposableTo(disposeBag)

        } else {
            self.toTextField.text = "Invalid Input!"
        }
    }


    func exampleUsages() {
        // MARK: NSURLSession simple and fast
        let session = NSURLSession.sharedSession()

        _ = session
            .rx_JSON(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        _ = session
            .rx_data(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // MARK: With Alamofire engine

        _ = RxAlamofire.JSON(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        _ = RxAlamofire.request(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["text/json"])
                    .rx_JSON()
            }
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // progress
        _ = RxAlamofire.request(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["text/json"])
                    .rx_progress()
            }
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // just fire upload and display progress
        _ = RxAlamofire.upload(try! URLRequest(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD"), data: NSData())
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["text/json"])
                    .rx_progress()
            }
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // progress and final result
        // uploading files with progress showing is processing intensive operation anyway, so
        // this doesn't add much overhead
        _ = RxAlamofire.request(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
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
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }


        // MARK: Alamofire manager
        // same methods with with any alamofire manager

        let manager = Manager.sharedInstance

        // simple case
        _ = manager.rx_JSON(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }


        // NSURLHTTPResponse + JSON
        _ = manager.rx_responseJSON(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // NSURLHTTPResponse + String
        _ = manager.rx_responseString(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // NSURLHTTPResponse + Validation + String
        _ = manager.rx_request(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["text/json"])
                    .rx_string()
            }
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // NSURLHTTPResponse + Validation + NSURLHTTPResponse + String
        _ = manager.rx_request(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
            .flatMap {
                $0
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["text/json"])
                    .rx_responseString()
            }
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // NSURLHTTPResponse + Validation + NSURLHTTPResponse + String + Progress
        _ = manager.rx_request(.GET, "http://api.fixer.io/latest?base=EUR&symbols=USD")
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
            .observeOn(MainScheduler.sharedInstance)
            .subscribe { print($0) }

        // MARK: wrapping of some request that isn't explicitly wrapped

        _ = manager.rx_request { manager in
            return manager.request(try URLRequest(.GET, "wonderland"))
        }.flatMap { request in
            return request.rx_responseString()
        }
    }

    @IBAction func getDummyDataPressed(sender: UIButton) {
        let dummyPostURLString = "http://jsonplaceholder.typicode.com/posts/1"
        let dummyCommentsURLString = "http://jsonplaceholder.typicode.com/posts/1/comments"

        let postObservable = RxAlamofire.JSON(Method.GET, dummyPostURLString)
        let commentsObservable = RxAlamofire.JSON(Method.GET, dummyCommentsURLString)
        self.dummyDataTextView.text = "Loading..."
        zip(postObservable, commentsObservable) { postJSON, commentsJSON in
                return (postJSON, commentsJSON)
            }
            .observeOn(MainScheduler.sharedInstance)
            .subscribe(onNext: { postJSON, commentsJSON in
                
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
            }, onError:{ e in
                self.dummyDataTextView.text = "An Error Occurred"
                self.displayError(e as NSError)
            }).addDisposableTo(disposeBag)

    }
    
    // MARK: - Utils
    
    func displayError(error: NSError?) {
        if let e = error {
            let alertController = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // do nothing...
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}

