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
import RxAlamofire

@testable import Alamofire

class ValidateSpec: XCTestCase {
    
    private struct Dummy {
        static let DataJSONContent = "{\"hello\":\"world\", \"foo\":\"bar\", \"zero\": 0}"
        static let DataJSON = DataJSONContent.data(using: String.Encoding.utf8)!
    }
    
    var manager: SessionManager!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        manager = SessionManager()
        
        _ = stub(condition: isHost("200.xyz")) { _ in
            return OHHTTPStubsResponse(data: Dummy.DataJSON, statusCode: 200, headers: ["Content-Type":"application/json"])
        }
        
        _ = stub(condition: isHost("401.xyz")) { _ in
            return OHHTTPStubsResponse(data: Dummy.DataJSON, statusCode: 401, headers: ["Content-Type":"text/xml"])
        }
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testShouldThrowWhenValidateFails() {
        do {
            _ = try request(.get, "http://401.xyz").validate().responseJSON().toBlocking().first()!
            XCTFail("Should throw")
        } catch {
        }
    }
    
    func testShouldNotThrowWhenValidateSucceeds() {
        do {
            _ = try request(.get, "http://200.xyz").validate().responseJSON().toBlocking().first()!
        } catch {
            XCTFail("Should not throw, but did with \(error)")
        }
    }
    
    func testShouldThrowWhenValidateStatusCodeFails() {
        do {
            _ = try request(.get, "http://401.xyz").validate(statusCode: 200..<300).responseJSON().toBlocking().first()!
            XCTFail("Should throw when status code is invalid")
        } catch {
        }
    }
    
    func testShouldNotThrowWhenValidateStatusCodeSucceeds() {
        do {
            _ = try request(.get, "http://200.xyz").validate(statusCode: 200..<300).responseJSON().toBlocking().first()!
        } catch {
            XCTFail("Should not throw when status code is valid, but did with \(error)")
        }
    }
    
    func testShouldThrowWhenValidateContentTypeFails() {
        do {
            _ = try request(.get, "http://401.xyz").validate(contentType: [ "application/json" ]).responseJSON().toBlocking().first()!
            XCTFail("Should throw when content type is invalid")
        } catch {
        }
    }
    
    func testShouldNotThrowWhenValidateContentTypeSucceeds() {
        do {
            _ = try request(.get, "http://200.xyz").validate(contentType: [ "application/json" ]).responseJSON().toBlocking().first()!
        } catch {
            XCTFail("Should not throw when content type is valid, but did with \(error)")
        }
    }
    
    func testShouldThrowWhenValidateWithCustomValidationFails() {
        do {
            _ = try request(.get, "http://401.xyz").validate({ (_, res, _) in
                return self.validateResponseIs200(res)
            }).responseJSON().toBlocking().first()!
            XCTFail("Should throw when validation fails")
        } catch {
        }
    }
    
    func testShouldNotThrowWhenValidateWithCustomValidationSucceeds() {
        do {
            _ = try request(.get, "http://200.xyz").validate({ (_, res, _) in
                return self.validateResponseIs200(res)
            }).responseJSON().toBlocking().first()!
        } catch {
            XCTFail("Should not throw when validation succeeds, but did with \(error)")
        }
    }
    
    private func validateResponseIs200(_ response: HTTPURLResponse) -> Request.ValidationResult {
        if response.statusCode == 200 {
            return .success
        }
        
        return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.statusCode)))
    }
}

