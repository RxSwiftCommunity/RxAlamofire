import Alamofire
import OHHTTPStubs
import RxAlamofire
import RxBlocking
import RxCocoa
import RxSwift
import XCTest

private enum Dummy {
  static let DataStringContent = "Hello World"
  static let DataStringData = DataStringContent.data(using: String.Encoding.utf8)!
  static let DataJSONContent = "{\"hello\":\"world\", \"foo\":\"bar\", \"zero\": 0}"
  static let DataJSON = DataJSONContent.data(using: String.Encoding.utf8)!
  static let GithubURL = "http://github.com/RxSwiftCommunity"

  struct DecodableJSON: Decodable {
    let hello: String
    let foo: String
    let zero: Int
  }
}

class RxAlamofireSpec: XCTestCase {
  private func isHost(_ host: String) -> HTTPStubsTestBlock {
    return { req in req.url?.host == host }
  }

  var manager: Session!

  let testError = NSError(domain: "RxAlamofire Test Error", code: -1, userInfo: nil)
  let disposeBag = DisposeBag()

  // MARK: Configuration
  override func setUp() {
    super.setUp()
    manager = Session()

    _ = HTTPStubs.stubRequests(passingTest: isHost("mywebservice.com"), withStubResponse: { _ in
      HTTPStubsResponse(data: Dummy.DataStringData, statusCode: 200, headers: nil)
    })

    _ = HTTPStubs.stubRequests(passingTest: isHost("myjsondata.com"), withStubResponse: { _ in
      HTTPStubsResponse(data: Dummy.DataJSON, statusCode: 200, headers: ["Content-Type": "application/json"])
    })

    _ = HTTPStubs.stubRequests(passingTest: isHost("interceptor.com"), withStubResponse: { request in
      guard request.url?.path != "/retry" else {
        return HTTPStubsResponse(data: Dummy.DataJSON, statusCode: 401, headers: ["Content-Type": "application/json"])
      }

      return HTTPStubsResponse(data: Dummy.DataJSON, statusCode: 200, headers: ["Content-Type": "application/json"])
    })
  }

  override func tearDown() {
    super.tearDown()
    HTTPStubs.removeAllStubs()
  }

  // MARK: Tests
  func testBasicRequest() {
    do {
      let result = try requestResponse(HTTPMethod.get, "http://mywebservice.com").toBlocking().first()!
      XCTAssertEqual(result.statusCode, 200)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testStringRequest() {
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
      guard let (result, obj) = try requestJSON(HTTPMethod.get, "http://myjsondata.com").toBlocking().first(),
            let json = obj as? [String: Any],
            let res = json["hello"] as? String
      else {
        XCTFail("errored out")
        return
      }
      XCTAssertEqual(result.statusCode, 200)
      XCTAssertEqual(res, "world")
    } catch {
      XCTFail("\(error)")
    }
  }

  // TODO: In Alamofire 5 progress became immutable. Test logic should be completely changed.
//    func testProgress() {
//        do {
//            let dataRequest = try request(HTTPMethod.get, "http://myjsondata.com").toBlocking().first()!
//            let progressObservable = dataRequest.rx.progress().share(replay: 100, scope: .forever)
//            let _ = progressObservable.subscribe { }
//            let delegate = dataRequest.delegate as! DataTaskDelegate
//            let progressHandler = delegate.progressHandler!
//            [(1000, 4000), (4000, 4000)].forEach { completed, total in
//                let progress = Alamofire.Progress()
//                progress.completedUnitCount = Int64(completed)
//                progress.totalUnitCount = Int64(total)
//                progressHandler.closure(progress)
//            }
//            let actualEvents = try progressObservable.toBlocking().toArray()
//            let expectedEvents = [
//                RxProgress(bytesWritten: 0, totalBytes: 0),
//                RxProgress(bytesWritten: 1000, totalBytes: 4000),
//                RxProgress(bytesWritten: 4000, totalBytes: 4000),
//            ]
//            XCTAssertEqual(actualEvents.count, expectedEvents.count)
//            for i in 0..<actualEvents.count {
//                XCTAssertEqual(actualEvents[i], expectedEvents[i])
//            }
//        } catch {
//            XCTFail("\(error)")
//        }
//    }

  func testRxProgress() {
    let subject = RxProgress(bytesWritten: 1000, totalBytes: 4000)
    XCTAssertEqual(subject.bytesRemaining, 3000)
    XCTAssertEqual(subject.completed, 0.25, accuracy: 0.000000001)
    let similar = RxProgress(bytesWritten: 1000, totalBytes: 4000)
    XCTAssertEqual(subject, similar)
    let different = RxProgress(bytesWritten: 2000, totalBytes: 4000)
    XCTAssertNotEqual(subject, different)
  }

  func testDownloadResponse() {
    do {
      let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      let fileURL = temporaryDirectory.appendingPathComponent("\(UUID().uuidString).json")
      let myUrl = try "http://myjsondata.com".asURL()

      let destination: DownloadRequest.Destination = { _, _ in (fileURL, []) }
      let request = download(URLRequest(url: myUrl),
                             to: destination)

      let testDownloadResponseExpectation = expectation(description: "testDownloadResponse expectation")

      _ = request
        .map {
          $0.response { downloadResponse in
            XCTAssertEqual(downloadResponse.response?.statusCode, 200)
            XCTAssertNotNil(downloadResponse.fileURL)
            testDownloadResponseExpectation.fulfill()
          }
        }
        .subscribe(onDisposed: {})

      wait(for: [testDownloadResponseExpectation], timeout: 5)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testDownloadResponseSerialized() {
    do {
      let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      let fileURL = temporaryDirectory.appendingPathComponent("\(UUID().uuidString).json")
      let myUrl = try "http://myjsondata.com".asURL()

      let destination: DownloadRequest.Destination = { _, _ in (fileURL, []) }
      let request = download(URLRequest(url: myUrl),
                             to: destination)

      let testDownloadResponseExpectation = expectation(description: "testDownloadResponse expectation")

      _ = request
        .map {
          $0.responseJSON { jsonResponse in
            guard let json = jsonResponse.value as? [String: Any] else { XCTFail("Bad Response"); return }
            XCTAssertEqual(json["hello"] as? String, "world")
            testDownloadResponseExpectation.fulfill()
          }
        }
        .subscribe(onDisposed: {})

      wait(for: [testDownloadResponseExpectation], timeout: 5)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testRequestDecodable() {
    do {
      let response: (HTTPURLResponse, Dummy.DecodableJSON)? = try requestDecodable(.get, "http://myjsondata.com").toBlocking().first()

      XCTAssertEqual(response?.0.statusCode, 200)
      XCTAssertEqual(response?.1.hello, "world")
      XCTAssertEqual(response?.1.foo, "bar")
      XCTAssertEqual(response?.1.zero, 0)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testRequestDecodableURLRequest() {
    do {
      let urlRequest = try URLRequest(url: "http://myjsondata.com", method: .get)
      let response: (HTTPURLResponse, Dummy.DecodableJSON)? = try requestDecodable(urlRequest).toBlocking().first()

      XCTAssertEqual(response?.0.statusCode, 200)
      XCTAssertEqual(response?.1.hello, "world")
      XCTAssertEqual(response?.1.foo, "bar")
      XCTAssertEqual(response?.1.zero, 0)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testDecodable() {
    do {
      let obj: Dummy.DecodableJSON? = try decodable(.get, "http://myjsondata.com").toBlocking().first()

      XCTAssertEqual(obj?.hello, "world")
      XCTAssertEqual(obj?.foo, "bar")
      XCTAssertEqual(obj?.zero, 0)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testInterceptorAdapt() {
    do {
      let interceptor = TestInterceptor()
      let result = try requestData(HTTPMethod.get, "http://interceptor.com", interceptor: interceptor)
        .toBlocking().first()!
      XCTAssertEqual(result.0.statusCode, 200)
      XCTAssertEqual(interceptor.adapt, 1)
      XCTAssertEqual(interceptor.retry, 0)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testInterceptorRetry() {
    do {
      let interceptor = TestInterceptor()
      let result = try request(HTTPMethod.get, "http://interceptor.com/retry", interceptor: interceptor)
        .validate()
        .responseData()
        .toBlocking().last()!
      XCTAssertEqual(result.0.statusCode, 200)
      XCTAssertEqual(interceptor.adapt, 2)
      XCTAssertEqual(interceptor.retry, 1)
    } catch {
      XCTFail("\(error)")
    }
  }

  var allTests = [
    "testBasicRequest": testBasicRequest,
    "testJSONRequest": testJSONRequest,
    "testRxProgress": testRxProgress,
    "testDownloadResponse": testDownloadResponse,
    "testDownloadResponseSerialized": testDownloadResponseSerialized
  ]
}

final class TestInterceptor: RequestInterceptor {
  private(set) var retry = 0
  private(set) var adapt = 0
  private var hasRetried = false

  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    if hasRetried {
      var request = URLRequest(url: URL(string: "http://interceptor.com")!)
      request.method = urlRequest.method
      request.headers = urlRequest.headers
      completion(.success(request))
    } else {
      completion(.success(urlRequest))
    }

    adapt += 1
  }

  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    completion(hasRetried ? .doNotRetry : .retry)
    hasRetried = true
    retry += 1
  }
}
