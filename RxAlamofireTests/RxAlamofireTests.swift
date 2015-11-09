//
//  RxAlamofireTests.swift
//  RxAlamofireTests
//
//  Created by Junior B. on 23/08/15.
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Alamofire
import OHHTTPStubs
import RxAlamofire

private struct Dummy {
    static let ErrorStringURL = "http://test.com/error"
    static let JSONStringURL = "http://test.com/test.json"
    static let JSONRequest = NSURLRequest(URL: NSURL(string: JSONStringURL )!)
    static let JSONPath = NSBundle(forClass: RxAlamofireSpec.self).pathForResource("test", ofType: "json")!
    static let DataStringURL = "http://test.com/test.json"
    static let DataStringRequest = NSURLRequest(URL: NSURL(string: DataStringURL)!)
    static let DataStringContent = "Hello World"
    static let DataStringData = DataStringContent.dataUsingEncoding(NSUTF8StringEncoding)!
}

class RxAlamofireSpec: XCTestCase {
    
    var manager: Manager!
    
    let testError = NSError(domain: "RxAlamofire Test Error", code: -1, userInfo: nil)
    let disposeBag = DisposeBag()
    
    //MARK: Configuration
    override func setUp() {
        super.setUp()
        manager = Manager(configuration: .defaultSessionConfiguration())
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
}
