import Alamofire
import RxAlamofire
import RxSwift
import UIKit

enum APIError: Error {
  case invalidInput
  case badResponse

  func toNSError() -> NSError {
    let domain = "com.github.rxswiftcommunity.rxalamofire"
    switch self {
    case .invalidInput:
      return NSError(domain: domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Input should be a valid number"])
    case .badResponse:
      return NSError(domain: domain, code: -2, userInfo: [NSLocalizedDescriptionKey: "Bad response"])
    }
  }
}

class MasterViewController: UIViewController, UITextFieldDelegate {
  let disposeBag = DisposeBag()
  let exchangeRateEndpoint = "https://api.exchangeratesapi.io/latest?base=EUR&symbols=USD"

  @IBOutlet var fromTextField: UITextField!
  @IBOutlet var toTextField: UITextField!
  @IBOutlet var convertBtn: UIButton!
  @IBOutlet var dummyDataBtn: UIButton!
  @IBOutlet var dummyDataTextView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - UI Actions

  @IBAction func convertPressed(_ sender: UIButton) {
    fromTextField.resignFirstResponder()

    guard let fromText = fromTextField.text, let fromValue = Double(fromText) else {
      displayError(APIError.invalidInput.toNSError())
      return
    }

    requestJSON(.get, exchangeRateEndpoint)
      .debug()
      .flatMap { (_, json) -> Observable<Double> in
        guard
          let body = json as? [String: Any],
          let rates = body["rates"] as? [String: Any],
          let rate = rates["USD"] as? Double
        else {
          return .error(APIError.badResponse.toNSError())
        }
        return .just(rate)
      }
      .subscribe(onNext: { [weak self] rate in
        self?.toTextField.text = "\(rate * fromValue)"
      }, onError: { [weak self] e in
        self?.displayError(e as NSError)
            })
      .disposed(by: disposeBag)
  }

  func exampleUsages() {
    let stringURL = ""
    // MARK: NSURLSession simple and fast
    let session = URLSession.shared
    _ = session.rx
      .json(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    _ = session
      .rx.json(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    _ = session
      .rx.data(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // MARK: With Alamofire engine

    _ = json(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    _ = request(.get, stringURL)
      .flatMap { request in
        request.validate(statusCode: 200..<300)
          .validate(contentType: ["text/json"])
          .rx.json()
      }
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // progress
    _ = request(.get, stringURL)
      .flatMap {
        $0
          .validate(statusCode: 200..<300)
          .validate(contentType: ["text/json"])
          .rx.progress()
      }
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // just fire upload and display progress
    if let urlRequest = try? urlRequest(.get, stringURL) {
      _ = upload(Data(), urlRequest: urlRequest)
        .flatMap {
          $0
            .validate(statusCode: 200..<300)
            .validate(contentType: ["text/json"])
            .rx.progress()
        }
        .observeOn(MainScheduler.instance)
        .subscribe { print($0) }
    }

    // progress and final result
    // uploading files with progress showing is processing intensive operation anyway, so
    // this doesn't add much overhead
    _ = request(.get, stringURL)
      .flatMap { request -> Observable<(Data?, RxProgress)> in
        let validatedRequest = request
          .validate(statusCode: 200..<300)
          .validate(contentType: ["text/json"])

        let dataPart = validatedRequest
          .rx.data()
          .map { d -> Data? in d }
          .startWith(nil as Data?)
        let progressPart = validatedRequest.rx.progress()
        return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
      }
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // MARK: Alamofire manager
    // same methods with any alamofire manager
    let manager = Session.default

    // simple case
    _ = manager.rx.json(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // NSURLHTTPResponse + JSON
    _ = manager.rx.responseJSON(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // NSURLHTTPResponse + String
    _ = manager.rx.responseString(.get, stringURL)
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // NSURLHTTPResponse + Validation + String
    _ = manager.rx.request(.get, stringURL)
      .flatMap {
        $0
          .validate(statusCode: 200..<300)
          .validate(contentType: ["text/json"])
          .rx.string()
      }
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // NSURLHTTPResponse + Validation + NSURLHTTPResponse + String
    _ = manager.rx.request(.get, stringURL)
      .flatMap {
        $0
          .validate(statusCode: 200..<300)
          .validate(contentType: ["text/json"])
          .rx.responseString()
      }
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }

    // NSURLHTTPResponse + Validation + NSURLHTTPResponse + String + Progress
    _ = manager.rx.request(.get, stringURL)
      .flatMap { request -> Observable<(String?, RxProgress)> in
        let validatedRequest = request
          .validate(statusCode: 200..<300)
          .validate(contentType: ["text/something"])

        let stringPart = validatedRequest
          .rx.string()
          .map { d -> String? in d }
          .startWith(nil as String?)
        let progressPart = validatedRequest.rx.progress()
        return Observable.combineLatest(stringPart, progressPart) { ($0, $1) }
      }
      .observeOn(MainScheduler.instance)
      .subscribe { print($0) }
  }

  @IBAction func getDummyDataPressed(_ sender: UIButton) {
    let dummyPostURLString = "http://jsonplaceholder.typicode.com/posts/1"
    let dummyCommentsURLString = "http://jsonplaceholder.typicode.com/posts/1/comments"

    let postObservable = json(.get, dummyPostURLString)
    let commentsObservable = json(.get, dummyCommentsURLString)
    dummyDataTextView.text = "Loading..."
    Observable.zip(postObservable, commentsObservable) { postJSON, commentsJSON in
      (postJSON, commentsJSON)
    }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { postJSON, commentsJSON in

      let postInfo = NSMutableString()
      if let postDict = postJSON as? [String: AnyObject],
        let commentsArray = commentsJSON as? [[String: AnyObject]],
        let postTitle = postDict["title"] as? String,
        let postBody = postDict["body"] as? String {
        postInfo.append("Title: ")
        postInfo.append(postTitle)
        postInfo.append("\n\n")
        postInfo.append(postBody)
        postInfo.append("\n\n\nComments:\n")
        for comment in commentsArray {
          if let email = comment["email"] as? String,
            let body = comment["body"] as? String {
            postInfo.append(email)
            postInfo.append(": ")
            postInfo.append(body)
            postInfo.append("\n\n")
          }
        }
      }

      self.dummyDataTextView.text = String(postInfo)
    }, onError: { e in
      self.dummyDataTextView.text = "An Error Occurred"
      self.displayError(e as NSError)
            }).disposed(by: disposeBag)
  }

  // MARK: - Utils

  func displayError(_ error: NSError?) {
    if let e = error {
      let alertController = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        // do nothing...
      }
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
    }
  }
}
