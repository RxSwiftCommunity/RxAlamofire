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

class MasterViewController: UIViewController, UITextFieldDelegate {
    
    let sourceStringURL = "http://api.fixer.io/latest?base=EUR&symbols=USD"
    
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
    }
    
    @IBAction func getDummyDataPressed(sender: UIButton) {
        let dummyPostURLString = "http://jsonplaceholder.typicode.com/posts/1"
        let dummyCommentsURLString = "http://jsonplaceholder.typicode.com/posts/1/comments"
        
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

