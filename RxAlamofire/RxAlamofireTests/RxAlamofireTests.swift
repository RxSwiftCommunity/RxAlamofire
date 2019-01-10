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

@testable import Alamofire

private struct Dummy {
	static let DataStringContent = "Hello World"
	static let DataStringData = DataStringContent.data(using: String.Encoding.utf8)!
	static let DataJSONContent = "{\"hello\":\"world\", \"foo\":\"bar\", \"zero\": 0}"
	static let DataJSON = DataJSONContent.data(using: String.Encoding.utf8)!
	static let GithubURL = "http://github.com/RxSwiftCommunity"
}

class RxAlamofireSpec: XCTestCase {
	
	var manager: Session!
	
	let testError = NSError(domain: "RxAlamofire Test Error", code: -1, userInfo: nil)
	let disposeBag = DisposeBag()
	
	//MARK: Configuration
	override func setUp() {
		super.setUp()
		manager = Session()
		
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
        do {
            let (result, string) = try requestString(HTTPMethod.get, "http://mywebservice.com").toBlocking().first()!
            XCTAssertEqual(result.statusCode, 200)
            XCTAssertEqual(string, Dummy.DataStringContent)
        } catch {
            XCTFail("\(error)")
        }
	}
	
	func testJSONRequest() {
        do {
            let (result, obj) = try requestJSON(HTTPMethod.get, "http://myjsondata.com").toBlocking().first()!
            let json = obj as! [String : Any]
            XCTAssertEqual(result.statusCode, 200)
            XCTAssertEqual(json["hello"] as! String, "world")
        } catch {
            XCTFail("\(error)")
        }
	}
    
    var session: Session?
    func testProgress() {
        OHHTTPStubs.setEnabled(true)
        let stubPath = OHPathForFile("Rx_Logo_M.png", type(of: self))
        let imageStub: OHHTTPStubsDescriptor = stub(condition: isExtension("png")) { _ in
            return fixture(filePath: stubPath!, headers: ["Content-Type":"image/png"])
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedEDGE)
        }
        imageStub.name = "Image stub"
        do {
            let progressObservable = AF
                .request("https://demo.com/Rx_Logo_M.png")
                .rx.progress().share(replay: 100, scope: .forever)
            
            let requestCompleted = expectation(description: "Wait for request to complete")
            requestCompleted.isInverted = true
            let _ = progressObservable.subscribe { }
            waitForExpectations(timeout: 2.0, handler: nil)
            
            
            let actualEvents = try progressObservable.toBlocking().toArray()
            let expectedEvents = [
                RxProgress(bytesWritten: 0, totalBytes: 0),
                RxProgress(bytesWritten: 4000, totalBytes: 39044),
                RxProgress(bytesWritten: 8000, totalBytes: 39044),
                RxProgress(bytesWritten: 12000, totalBytes: 39044),
                RxProgress(bytesWritten: 16000, totalBytes: 39044),
                RxProgress(bytesWritten: 20000, totalBytes: 39044),
                RxProgress(bytesWritten: 24000, totalBytes: 39044),
                RxProgress(bytesWritten: 28000, totalBytes: 39044),
                RxProgress(bytesWritten: 32000, totalBytes: 39044),
                RxProgress(bytesWritten: 36000, totalBytes: 39044),
                RxProgress(bytesWritten: 39044, totalBytes: 39044)
            ]
            
            XCTAssertEqual(actualEvents.count, expectedEvents.count)
            for i in 0..<actualEvents.count {
                XCTAssertEqual(actualEvents[i], expectedEvents[i])
            }
        } catch {
            XCTFail("\(error)")
        }
        
        OHHTTPStubs.setEnabled(false)
    }

    func testRxProgress() {
        let subject = RxProgress(bytesWritten: 1000, totalBytes: 4000)
        XCTAssertEqual(subject.bytesRemaining, 3000)
        XCTAssertEqual(subject.completed, 0.25, accuracy: 0.000000001)
        let similar = RxProgress(bytesWritten: 1000, totalBytes: 4000)
        XCTAssertEqual(subject, similar)
        let different = RxProgress(bytesWritten: 2000, totalBytes: 4000)
        XCTAssertNotEqual(subject, different)
    }
}
