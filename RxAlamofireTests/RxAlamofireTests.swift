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
import RxBlocking
import Alamofire
import OHHTTPStubs
import RxAlamofire

private struct Dummy {
    static let DataStringContent = "Hello World"
    static let DataStringData = DataStringContent.data(using: String.Encoding.utf8)!
    static let DataJSONContent = "{\"hello\":\"world\", \"foo\":\"bar\", \"zero\": 0}"
    static let DataJSON = DataJSONContent.data(using: String.Encoding.utf8)!
    static let GithubURL = "http://github.com/RxSwiftCommunity"
}

class RxAlamofireSpec: XCTestCase {
    
    var manager: SessionManager!
    
    let testError = NSError(domain: "RxAlamofire Test Error", code: -1, userInfo: nil)
    let disposeBag = DisposeBag()
    
    //MARK: Configuration
    override func setUp() {
        super.setUp()
        manager = SessionManager(configuration: .default)
        
        _ = stub(condition: isHost("mywebservice.com")) { _ in
            return OHHTTPStubsResponse(data: Dummy.DataStringData, statusCode:200, headers:nil)
        }
        
        _ = stub(condition: isHost("myjsondata.com")) { _ in
            return OHHTTPStubsResponse(data: Dummy.DataJSON, statusCode:200, headers:["Content-Type":"application/json"])
        }
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    //MARK: Tests
    func testBasicRequest() {
        if let (result, string) = try! requestString(HTTPMethod.get, "http://mywebservice.com").toBlocking().first() {
            XCTAssertEqual(result.statusCode, 200)
            XCTAssertEqual(string, Dummy.DataStringContent)
        } else {
            XCTFail("Basic Request Failed")
        }
    }
    
    func testJSONRequest() {
        if let (result, json) = try! requestJSON(HTTPMethod.get, "http://myjsondata.com").toBlocking().first() {
            XCTAssertEqual(result.statusCode, 200)
            let dict = json as! Dictionary<String, Any>
            XCTAssertEqual(dict["hello"] as! String, "world")
        } else {
            XCTFail("Basic Request Failed")
        }
    }
}
