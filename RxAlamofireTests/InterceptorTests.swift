//
//  ValidateTests.swift
//  ValidateTests
//
//  Created by Nicolas Verinaud on 07/02/18.
//  Copyright © 2018 Ryfacto. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import Alamofire
import OHHTTPStubs

@testable import RxAlamofire

class InterceptorTests: XCTestCase {
    
    private struct Dummy {
        static let DataJSONContent = "{\"hello\":\"world\", \"foo\":\"bar\", \"zero\": 0}"
        static let DataJSON = DataJSONContent.data(using: String.Encoding.utf8)!
    }
    
    override func setUp() {
        super.setUp()
        
        _ = stub(condition: isHost("data.xyz")) { _ in
            return HTTPStubsResponse(data: Dummy.DataJSON, statusCode: 200, headers: ["Content-Type":"application/json"])
        }
        
        _ = stub(condition: isHost("401.xyz")) { _ in
            return HTTPStubsResponse(data: Dummy.DataJSON, statusCode: 401, headers: ["Content-Type":"application/json"])
        }
    }
    
    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
    }
   
    final class TestInterceptor: RequestInterceptor {
        let expectation: XCTestExpectation
        let retryFulfillment:Bool
        init(expectation: XCTestExpectation, retryFulfillment:Bool = false) {
            self.expectation = expectation
            self.retryFulfillment = retryFulfillment
        }

        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
            completion(.success(urlRequest))
            expectation.fulfill()
        }

        func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
            completion(RetryResult.doNotRetry)
            if retryFulfillment {
                expectation.fulfill()
            }
        }
    }
    
    // MARK: session interceptor tests
   
    func testInterceptorForSessionsWork() {
        let expectation = self.expectation(description: "testInterceptorForSessionsWork")
        
        let testInterceptor = TestInterceptor(expectation: expectation)
        let manager = Alamofire.Session(startRequestsImmediately: false,
                                        interceptor: testInterceptor)
        
        _ =  manager.rx.responseString(HTTPMethod.get, "http://data.xyz")
            .subscribe()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInterceptorForSessionsRetryWork() {
        let expectation = self.expectation(description: "testInterceptorForSessionsRetryWork")
        expectation.expectedFulfillmentCount = 3

        let testInterceptor = TestInterceptor(expectation: expectation,
                                              retryFulfillment: true)
        let manager = Alamofire.Session(startRequestsImmediately: true,
                                        interceptor: testInterceptor)

        _ = manager.rx.request(HTTPMethod.get, "http://401.xyz" as URLConvertible)
            //retry will call twice and one for adaption due to:
            //  https://github.com/Alamofire/Alamofire/issues/2562#issuecomment-553962884
            .validate(statusCode: 200..<300)
            .responseData()
            .subscribe()
        waitForExpectations(timeout: 5, handler: nil)
    }
  
    // MARK: session interceptor tests
    
    func testInterceptorForRequestFunction() {
        let expectation = self.expectation(description: "testInterceptorForRequestFunction")
        
        let testInterceptor = TestInterceptor(expectation: expectation)
        let manager = Alamofire.Session(startRequestsImmediately: false)
        
        _ = manager.rx
            .request(HTTPMethod.get, "http://data.xyz" as URLConvertible,
                     interceptor: testInterceptor)
            .subscribe()
        
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestModifierForRequestFunction() {
          let expectation = self.expectation(description: "testInterceptorForRequestFunction")
          
          let manager = Alamofire.Session(startRequestsImmediately: false)
          
          _ = manager.rx
              .request(HTTPMethod.get,
                       "http://data.xyz" as URLConvertible){ (req) in
                        expectation.fulfill()
          }.subscribe()
          
          
          waitForExpectations(timeout: 5, handler: nil)
    }
}

