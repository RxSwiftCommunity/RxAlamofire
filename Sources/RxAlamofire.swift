//
//  RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. (@bontojr) on 23/08/15.
//  Developed with the kind help of Krunoslav Zaher (@KrunoslavZaher)
//
//  Updated by Ivan Đikić for the latest version of Alamofire(3) and RxSwift(2) on 21/10/15
//  Updated by Krunoslav Zaher to better wrap Alamofire (3) on 1/10/15
//
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

/// Default instance of unknown error
public let RxAlamofireUnknownError = NSError(domain: "RxAlamofireDomain", code: -1, userInfo: nil)

// MARK: Convenience functions

/**
    Creates a NSMutableURLRequest using all necessary parameters.

    - parameter method: Alamofire method object
    - parameter url: An object adopting `URLConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the additional headers
    - returns: An instance of `NSMutableURLRequest`
*/

public func urlRequest(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    throws -> Foundation.URLRequest
{
    var mutableURLRequest = Foundation.URLRequest(url: try url.asURL())
    mutableURLRequest.httpMethod = method.rawValue

    if let headers = headers {
        for (headerField, headerValue) in headers {
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }

    if let parameters = parameters {
        mutableURLRequest = try encoding.encode(mutableURLRequest, with: parameters)
    }

    return mutableURLRequest
}

// MARK: Request

/**
Creates an observable of the generated `Request`.

- parameter method: Alamofire method object
- parameter url: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the additional headers

- returns: An observable of a the `Request`
*/
public func request(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<DataRequest>
{
    return SessionManager.default.rx.request(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the generated `Request`.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of a the `Request`
 */
public func request(_ urlRequest: URLRequestConvertible) -> Observable<DataRequest> {
  return SessionManager.default.rx.request(urlRequest: urlRequest)
}

// MARK: data

/**
Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

- parameter method: Alamofire method object
- parameter url: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the additional headers

- returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
*/
public func requestData(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<(HTTPURLResponse, Data)>
{
    return SessionManager.default.rx.responseData(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
 */
public func requestData(_ urlRequest: URLRequestConvertible) -> Observable<(HTTPURLResponse, Data)> {
    return request(urlRequest).flatMap { $0.rx.responseData() }
}

/**
 Creates an observable of the returned data.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of `NSData`
 */
public func data(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<Data>
{
    return SessionManager.default.rx.data(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: string

/**
Creates an observable of the returned decoded string and response.

- parameter method: Alamofire method object
- parameter url: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the additional headers

- returns: An observable of the tuple `(NSHTTPURLResponse, String)`
*/
public func requestString(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<(HTTPURLResponse, String)>
{
    return SessionManager.default.rx.responseString(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the returned decoded string and response.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
 */
public func requestString(_ urlRequest: URLRequestConvertible) -> Observable<(HTTPURLResponse, String)> {
    return request(urlRequest).flatMap { $0.rx.responseString() }
}

/**
 Creates an observable of the returned decoded string.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of `String`
 */
public func string(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<String>
{
    return SessionManager.default.rx.string(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: JSON

/**
Creates an observable of the returned decoded JSON as `AnyObject` and the response.

- parameter method: Alamofire method object
- parameter url: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the additional headers

- returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
*/
public func requestJSON(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<(HTTPURLResponse, Any)>
{
    return SessionManager.default.rx.responseJSON(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the returned decoded JSON as `AnyObject` and the response.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
 */
public func requestJSON(_ urlRequest: URLRequestConvertible) -> Observable<(HTTPURLResponse, Any)> {
    return request(urlRequest).flatMap { $0.rx.responseJSON() }
}

/**
 Creates an observable of the returned decoded JSON.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers

 - returns: An observable of the decoded JSON as `Any`
 */
public func json(_ method: Alamofire.HTTPMethod,
    _ url: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<Any>
{
    return SessionManager.default.rx.json(
        method,
        url,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: Upload

/**
    Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
    The request is started immediately.

    - parameter urlRequest: The request object to start the upload.
    - paramenter file: An instance of NSURL holding the information of the local file.
    - returns: The observable of `UploadRequest` for the created request.
 */
public func upload(_ file: URL, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
    return SessionManager.default.rx.upload(file, urlRequest: urlRequest)
}

/**
    Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
    The request is started immediately.

    - parameter urlRequest: The request object to start the upload.
    - paramenter data: An instance of NSData holdint the data to upload.
    - returns: The observable of `UploadRequest` for the created request.
 */
public func upload(_ data: Data, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
    return SessionManager.default.rx.upload(data , urlRequest: urlRequest)
}

/**
    Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
    The request is started immediately.

    - parameter urlRequest: The request object to start the upload.
    - paramenter stream: The stream to upload.
    - returns: The observable of `Request` for the created upload request.
 */
public func upload(_ stream: InputStream, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
    return SessionManager.default.rx.upload(stream, urlRequest: urlRequest)
}

// MARK: Download

/**
    Creates a download request using the shared manager instance for the specified URL request.
    - parameter urlRequest:  The URL request.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `DownloadRequest` for the created download request.
 */
public func download(_ urlRequest: URLRequestConvertible,
                     to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
    return SessionManager.default.rx.download(urlRequest, to: destination)
}

// MARK: Resume Data

/**
    Creates a request using the shared manager instance for downloading from the resume data produced from a
    previous request cancellation.

    - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
    when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
    information.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `Request` for the created download request.
*/
public func download(resumeData: Data,
                     to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
    return SessionManager.default.rx.download(resumeData: resumeData, to: destination)
}

// MARK: Manager - Extension of Manager

extension SessionManager: ReactiveCompatible {
}

protocol RxAlamofireRequest {

    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void)
    func resume()
    func cancel()
}

protocol RxAlamofireResponse {
    var error: Error? {get}
}

extension DefaultDataResponse: RxAlamofireResponse {}

extension DefaultDownloadResponse: RxAlamofireResponse {}

extension DataRequest: RxAlamofireRequest {
    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
        response { (response) in
            completionHandler(response)
        }
    }
}

extension DownloadRequest: RxAlamofireRequest {
    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
        response { (response) in
            completionHandler(response)
        }
    }
}


extension Reactive where Base: SessionManager {

    // MARK: Generic request convenience

    /**
    Creates an observable of the DataRequest.

    - parameter createRequest: A function used to create a `Request` using a `Manager`

    - returns: A generic observable of created data request
    */
    func request<R: RxAlamofireRequest>(_ createRequest: @escaping (SessionManager, @escaping (R) -> Void) -> Void) -> Observable<R> {
        return Observable.create { observer -> Disposable in
            var request: R?
            do {
                createRequest(self.base) { newRequest in
                    request = newRequest

                    observer.on(.next(newRequest))
                    newRequest.responseWith(completionHandler: { (response) in
                        if let error = response.error {
                            observer.on(.error(error))
                        } else {
                            observer.on(.completed)
                        }
                    })

                    if !self.base.startRequestsImmediately {
                        newRequest.resume()
                    }
                }

                return Disposables.create {
                    request?.cancel()
                }
            }
//            catch let error {
//                observer.on(.error(error))
//                return Disposables.create()
//            }
        }
    }


    /**
     Creates an observable of the `Request`.

     - parameter method: Alamofire method object
     - parameter url: An object adopting `URLConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of the `Request`
     */
    public func request(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<DataRequest>
    {
        return request { manager in
            return manager.request(url,
                                   method: method,
                                   parameters: parameters,
                                   encoding: encoding,
                                   headers: headers)
        }
    }

    /**
     Creates an observable of the `Request`.

     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of the `Request`
     */
    public func request(urlRequest: URLRequestConvertible)
        -> Observable<DataRequest>
    {
        return request { manager in
            return manager.request(urlRequest)
        }
    }

    // MARK: data

    /**
    Creates an observable of the data.

    - parameter url: An object adopting `URLConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the additional headers

    - returns: An observable of the tuple `(NSHTTPURLResponse, NSData)`
    */
    public func responseData(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<(HTTPURLResponse, Data)>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx.responseData() }
    }

    /**
     Creates an observable of the data.

     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of `NSData`
     */
    public func data(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<Data>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx.data() }
    }

    // MARK: string

    /**
    Creates an observable of the tuple `(NSHTTPURLResponse, String)`.

    - parameter url: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the additional headers

    - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
    */
    public func responseString(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<(HTTPURLResponse, String)>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx.responseString() }
    }

    /**
     Creates an observable of the data encoded as String.

     - parameter url: An object adopting `URLConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of `String`
     */
    public func string(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<String>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            )
            .flatMap { (request) -> Observable<String> in
                return request.rx.string()
            }
    }

    // MARK: JSON

    /**
    Creates an observable of the data decoded from JSON and processed as tuple `(NSHTTPURLResponse, AnyObject)`.

    - parameter url: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the additional headers

    - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
    */
    public func responseJSON(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<(HTTPURLResponse, Any)>
    {
        return request(method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx.responseJSON() }
    }

    /**
     Creates an observable of the data decoded from JSON and processed as `AnyObject`.

     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of `AnyObject`
     */
    public func json(_ method: Alamofire.HTTPMethod,
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<Any>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx.json() }
    }

    // MARK: Upload

    /**
     Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
     The request is started immediately.

     - parameter urlRequest: The request object to start the upload.
     - paramenter file: An instance of NSURL holding the information of the local file.
     - returns: The observable of `AnyObject` for the created request.
     */
    public func upload(_ file: URL, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {

        return request { manager in
            return manager.upload(file, with: urlRequest)
        }
    }

    /**
     Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
     The request is started immediately.

     - parameter urlRequest: The request object to start the upload.
     - paramenter data: An instance of Data holdint the data to upload.
     - returns: The observable of `UploadRequest` for the created request.
     */
    public func upload(_ data: Data, urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
        return request { manager in
            return manager.upload(data, with: urlRequest)
        }
    }

    /**
     Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
     The request is started immediately.

     - parameter urlRequest: The request object to start the upload.
     - paramenter stream: The stream to upload.
     - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
     */
    public func upload(_ stream: InputStream,
                       urlRequest: URLRequestConvertible) -> Observable<UploadRequest> {
        return request { manager in
            return manager.upload(stream, with: urlRequest)
        }
    }

    // MARK: Multipart upload

    /**
     Returns an observable of an `UploadRequest` using the `url`, `method` and `headers`,
     and a body that contains `multipart/form-data` content encoded from the input data,
     provided by the `multipartFormData` parameter.

     It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
     payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
     efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
     be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
     footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
     used for larger payloads such as video content.

     The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
     or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
     encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
     during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
     technique was used.

     - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
     - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
                                          `multipartFormDataEncodingMemoryThreshold` by default.
     - parameter url:                     The URL.
     - parameter method:                  The HTTP method. `.post` by default.
     - parameter headers:                 The HTTP headers. `nil` by default.
    */
    public func upload(multipartFormData data: @escaping (MultipartFormData) -> Void,
                       usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
                       to url: URLConvertible,
                       method: HTTPMethod = .post,
                       headers: HTTPHeaders = [:]) -> Observable<UploadRequest> {
        return request { manager, requestClosure in
            manager.upload(multipartFormData: data,
                           usingThreshold: encodingMemoryThreshold,
                           to: url,
                           method: method,
                           headers: headers) {
                            switch $0 {
                            case let .success(request, _, _):
                                requestClosure(request)
                            case .failure:
                                () // probably need to handle the error with a result type or something
                            }
            }
            fatalError()
        }

        let manager = base
        return Observable.create { observer in
            manager.upload(multipartFormData: data,
                           usingThreshold: encodingMemoryThreshold,
                           to: url,
                           method: method,
                           headers: headers) {
                switch $0 {
                case .failure(let error):
                    observer.onError(error)
                case .success(let request, _, _):
                    observer.onNext(request)
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }

    // MARK: Download

    /**
     Creates a download request using the shared manager instance for the specified URL request.
     - parameter urlRequest:  The URL request.
     - parameter destination: The closure used to determine the destination of the downloaded file.
     - returns: The observable of `(NSData?, RxProgress)` for the created download request.
     */
    public func download(_ urlRequest: URLRequestConvertible,
                         to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
        return request { manager in
            return manager.download(urlRequest, to: destination)
        }
    }

    /**
    Creates a request using the shared manager instance for downloading with a resume data produced from a
    previous request cancellation.

    - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
    when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
    information.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `(NSData?, RxProgress)` for the created download request.
    */
    public func download(resumeData: Data,
                         to destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
        return request { manager in
            return manager.download(resumingWith: resumeData, to: destination)
        }
    }
}

// MARK: Request - Common Response Handlers

extension ObservableType where E == DataRequest {
    public func responseJSON() -> Observable<DataResponse<Any>> {
        return flatMap { $0.rx.responseJSON() }
    }
    
    public func json(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
        return flatMap { $0.rx.json(options: options) }
    }
    
    public func responseString(encoding: String.Encoding? = nil) -> Observable<(HTTPURLResponse, String)> {
        return flatMap { $0.rx.responseString(encoding: encoding) }
    }
    
    public func string(encoding: String.Encoding? = nil) -> Observable<String> {
        return flatMap { $0.rx.string(encoding: encoding) }
    }
    
    public func responseData() -> Observable<(HTTPURLResponse, Data)> {
        return flatMap { $0.rx.responseData() }
    }
    
    public func data() -> Observable<Data> {
        return flatMap { $0.rx.data() }
    }
    
    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<(HTTPURLResponse, Any)> {
        return flatMap { $0.rx.responsePropertyList(options: options) }
    }
    
    public func propertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<Any> {
        return flatMap { $0.rx.propertyList(options: options) }
    }
    
    public func progress() -> Observable<RxProgress> {
        return flatMap { $0.rx.progress() }
    }
}

// MARK: Request - Validation

extension ObservableType where E == DataRequest {
    public func validate<S: Sequence>(statusCode: S) -> Observable<E> where S.Element == Int {
        return map { $0.validate(statusCode: statusCode) }
    }
    
    public func validate() -> Observable<E> {
        return map { $0.validate() }
    }
    
    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<E> where S.Iterator.Element == String {
        return map { $0.validate(contentType: acceptableContentTypes) }
    }
    
    public func validate(_ validation: @escaping DataRequest.Validation) -> Observable<E> {
        return map { $0.validate(validation) }
    }
}

extension Request: ReactiveCompatible {
}

extension Reactive where Base: DataRequest {

    // MARK: Defaults

    /// - returns: A validated request based on the status code
    func validateSuccessfulResponse() -> DataRequest {
        return self.base.validate(statusCode: 200 ..< 300)
    }

    /**
     Transform a request into an observable of the response and serialized object.

     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `(NSHTTPURLResponse, T.SerializedObject)` for the created download request.
     */
    public func responseResult<T: DataResponseSerializerProtocol>(queue: DispatchQueue? = nil,
        responseSerializer: T)
        -> Observable<(HTTPURLResponse, T.SerializedObject)>
    {
        return Observable.create { observer in
            let dataRequest = self.base
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                switch packedResponse.result {
                case .success(let result):
                    if let httpResponse = packedResponse.response {
                        observer.on(.next((httpResponse, result)))
                        observer.on(.completed)
                    }
                    else {
                        observer.on(.error(RxAlamofireUnknownError))
                    }
                case .failure(let error):
                    observer.on(.error(error as Error))
                }
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }

    public func responseJSON() -> Observable<DataResponse<Any>> {
        return Observable.create { observer in
            let request = self.base

            request.responseJSON { response in
                if let error = response.result.error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(response))
                    observer.on(.completed)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    /**
     Transform a request into an observable of the serialized object.

     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `T.SerializedObject` for the created download request.
     */
    public func result<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T)
        -> Observable<T.SerializedObject>
    {
        return Observable.create { observer in
            let dataRequest = self.validateSuccessfulResponse()
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    switch packedResponse.result {
                    case .success(let result):
                        if let _ = packedResponse.response {
                            observer.on(.next(result))
                            observer.on(.completed)
                        }
                        else {
                            observer.on(.error(RxAlamofireUnknownError))
                        }
                    case .failure(let error):
                        observer.on(.error(error as Error))
                    }
                }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }

    /**
    Returns an `Observable` of NSData for the current request.

    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`

    - returns: An instance of `Observable<NSData>`
    */
    public func responseData() -> Observable<(HTTPURLResponse, Data)> {
        return responseResult(responseSerializer: DataRequest.dataResponseSerializer())
    }

    public func data() -> Observable<Data> {
        return result(responseSerializer: DataRequest.dataResponseSerializer())
    }

    /**
    Returns an `Observable` of a String for the current request

    - parameter encoding: Type of the string encoding, **default:** `nil`

    - returns: An instance of `Observable<String>`
    */
    public func responseString(encoding: String.Encoding? = nil) -> Observable<(HTTPURLResponse, String)> {
        return responseResult(responseSerializer: Base.stringResponseSerializer(encoding: encoding))
    }

    public func string(encoding: String.Encoding? = nil) -> Observable<String> {
        return result(responseSerializer: Base.stringResponseSerializer(encoding: encoding))
    }

    /**
    Returns an `Observable` of a serialized JSON for the current request.

    - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

    - returns: An instance of `Observable<AnyObject>`
    */
    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<(HTTPURLResponse, Any)> {
        return responseResult(responseSerializer: Base.jsonResponseSerializer(options: options))
    }

    /**
     Returns an `Observable` of a serialized JSON for the current request.

     - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

     - returns: An instance of `Observable<AnyObject>`
     */
    public func json(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
        return result(responseSerializer: Base.jsonResponseSerializer(options: options))
    }

    /**
    Returns and `Observable` of a serialized property list for the current request.

    - parameter options: Property list reading options, **default:** `NSPropertyListReadOptions()`

    - returns: An instance of `Observable<AnyData>`
    */
    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<(HTTPURLResponse, Any)> {
        return responseResult(responseSerializer: Base.propertyListResponseSerializer(options: options))
    }

    public func propertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<Any> {
        return result(responseSerializer: Base.propertyListResponseSerializer(options: options))
    }
}

extension Reactive where Base: Request {
    // MARK: Request - Upload and download progress

    /**
    Returns an `Observable` for the current progress status.

    Parameters on observed tuple:

    1. bytes written so far.
    1. total bytes to write.

    - returns: An instance of `Observable<RxProgress>`
    */
    public func progress() -> Observable<RxProgress> {
        return Observable.create { observer in
            let handler: Request.ProgressHandler = { progress in
                let rxProgress = RxProgress(bytesWritten: progress.completedUnitCount,
                                            totalBytes: progress.totalUnitCount)
                observer.on(.next(rxProgress))

                if rxProgress.bytesWritten >= rxProgress.totalBytes {
                    observer.on(.completed)
                }
            }

            // Try in following order:
            //  - UploadRequest (Inherits from DataRequest, so we test the discrete case first)
            //  - DownloadRequest
            //  - DataRequest
            if let uploadReq = self.base as? UploadRequest {
                uploadReq.uploadProgress(closure: handler)
            } else if let downloadReq = self.base as? DownloadRequest {
                downloadReq.downloadProgress(closure: handler)
            } else if let dataReq = self.base as? DataRequest {
                dataReq.downloadProgress(closure: handler)
            }

            return Disposables.create()
        }
        // warm up a bit :)
        .startWith(RxProgress(bytesWritten: 0, totalBytes: 0))
    }
}

// MARK: RxProgress
public struct RxProgress {
    public let bytesWritten: Int64
    public let totalBytes: Int64

    public init(bytesWritten: Int64, totalBytes: Int64) {
        self.bytesWritten = bytesWritten
        self.totalBytes = totalBytes
    }
}

extension RxProgress {
    public var bytesRemaining: Int64 {
        return totalBytes - bytesWritten
    }

    public var completed: Float {
        if totalBytes > 0 {
            return Float(bytesWritten) / Float(totalBytes)
        }
        else {
            return 0
        }
    }
}

extension RxProgress: Equatable {}

public func ==(lhs: RxProgress, rhs: RxProgress) -> Bool {
    return lhs.bytesWritten == rhs.bytesWritten &&
        lhs.totalBytes == rhs.totalBytes
}
