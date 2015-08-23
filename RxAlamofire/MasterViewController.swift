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

class MasterViewController: UIViewController {
    
    let sourceStringURL = "http://api.fixer.io/latest?base=EUR&symbols=USD"
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    
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
        Alamofire.request(.GET, sourceStringURL).rx_responseJSON()
            .observeOn(MainScheduler.sharedInstance)
            .subscribeNext() { json in
                if let dict = json as? [String: AnyObject] {
                    let formatter = NSNumberFormatter()
                    formatter.numberStyle = .CurrencyStyle
                    formatter.currencyCode = "USD"
                    let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                    let value = valDict["USD"] as? Float
                    let fromValue = NSNumberFormatter().numberFromString(self.fromTextField.text!)?.floatValue
                    
                    if let v = value, let fv = fromValue {
                        self.toTextField?.text = formatter.stringFromNumber(v*fv)!
                    }
                }
            }.subscribeError() { (e: NSError) in
                self.displayError(e)
            }
    }
    
    // MARK: - Utils
    
    func displayError(error: NSError?) {
        if let e = error {
            let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}

