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
import RxCocoa

/// Default instance of unknown error
public let RxAlamofireUnknownError = NSError(domain: "RxAlamofireDomain", code: -1, userInfo: nil)

// MARK: Convenience functions

/**
    Creates a NSMutableURLRequest using all necessary parameters.
    
    - parameter method: Alamofire method object
    - parameter URLString: An object adopting `URLConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    - returns: An instance of `NSMutableURLRequest`
*/
public func urlRequest(
    _ method: Alamofire.HTTPMethod,
    _ URL: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    throws -> URLRequest
{
    var request = URLRequest(url: try URL.asURL())
    request.httpMethod = method.rawValue

    if let headers = headers {
        for (headerField, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }

    if let parameters = parameters {
        request = try encoding.encode(request, with: parameters)
    }

    return request
}

// MARK: Request

/**
Creates an observable of the generated `Request`.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of a the `Request`
*/
public func request(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<DataRequest>
{
    return SessionManager.default.rx.request(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: data

/**
Creates an observable of the `(HTTPURLResponse, Data)` instance.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of a tuple containing `(HTTPURLResponse, Data)`
*/
public func requestData(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<(HTTPURLResponse, Data)>
{
    return SessionManager.default.rx.responseData(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the returned data.
 
 - parameter method: Alamofire method object
 - parameter URLString: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the addional headers
 
 - returns: An observable of `Data`
 */
public func data(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<Data>
{
    return SessionManager.default.rx.data(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: string

/**
Creates an observable of the returned decoded string and response.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of the tuple `(HTTPURLResponse, String)`
*/
public func requestString(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<(HTTPURLResponse, String)>
{
    return SessionManager.default.rx.responseString(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the returned decoded string.
 
 - parameter method: Alamofire method object
 - parameter URLString: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the addional headers
 
 - returns: An observable of `String`
 */
public func string(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<String>
{
    return SessionManager.default.rx.string(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: JSON

/**
Creates an observable of the returned decoded JSON as `Any` and the response.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of the tuple `(HTTPURLResponse, Any)`
*/
public func requestJSON(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<(HTTPURLResponse, Any)>
{
    return SessionManager.default.rx.responseJSON(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/**
 Creates an observable of the returned decoded JSON.
 
 - parameter method: Alamofire method object
 - parameter URLString: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the addional headers
 
 - returns: An observable of the decoded JSON as `Any`
 */
public func JSON(_ method: Alamofire.HTTPMethod,
    _ URLString: URLConvertible,
    parameters: [String: Any]? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> Observable<Any>
{
    return SessionManager.default.rx.JSON(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: Upload

/**
    Returns an observable of a request using the shared session manager instance to upload a specific file to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter file: An instance of NSURL holding the information of the local file.
    - returns: The observable of `Request` for the created request.
 */
public func upload(_ URLRequest: URLRequestConvertible, file: URL) -> Observable<DataRequest> {
    return SessionManager.default.rx.upload(URLRequest, file: file)
}

/**
    Returns an observable of a request using the shared session manager instance to upload any data to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter data: An instance of Data holdint the data to upload.
    - returns: The observable of `Request` for the created request.
 */
public func upload(_ URLRequest: URLRequestConvertible, data: Data) -> Observable<DataRequest> {
    return SessionManager.default.rx.upload(URLRequest, data: data)
}

/**
    Returns an observable of a request using the shared session manager instance to upload any stream to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter stream: The stream to upload.
    - returns: The observable of `Request` for the created upload request.
 */
public func upload(_ URLRequest: URLRequestConvertible, stream: InputStream) -> Observable<DataRequest> {
    return SessionManager.default.rx.upload(URLRequest, stream: stream)
}

// MARK: Download

/**
    Creates a download request using the shared session manager instance for the specified URL request.
    - parameter URLRequest:  The URL request.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `Request` for the created download request.
 */
public func download(_ URLRequest: URLRequestConvertible, destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
    return SessionManager.default.rx.download(URLRequest, destination: destination)
}

// MARK: Resume Data

/**
    Creates a request using the shared session manager instance for downloading from the resume data produced from a
    previous request cancellation.

    - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
    when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
    information.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `Request` for the created download request.
*/
public func download(resumeData data: Data, destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
    return SessionManager.default.rx.download(resumeData: data, destination: destination)
}

// MARK: SessionManager - Extension of SessionManager

extension SessionManager: ReactiveCompatible {
}

extension Reactive where Base: SessionManager{

    // MARK: Generic request convenience
    
    /**
     Creates an observable of the returned decoded JSON.
     
     - parameter createRequest: A function used to create a `Request` using a `SessionManager`
     
     - returns: A generic observable of created request
     */
    public func request(_ createRequest: @escaping (SessionManager) throws -> DataRequest) -> Observable<DataRequest> {
        return Observable.create { observer -> Disposable in
            let request: DataRequest
            do {
                request = try createRequest(self.base)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            observer.onNext(request)
            
            // needs to wait for response because sending complete immediatelly will cancel the request
            request.response { response in
                if let error = response.error {
                    observer.on(.error(error as Error))
                } else {
                    observer.on(.completed)
                }
            }
            
            if !self.base.startRequestsImmediately {
                request.resume()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    /**
     Creates an observable of the returned decoded JSON.
     
     - parameter createRequest: A function used to create a `Request` using a `SessionManager`
     
     - returns: A generic observable of created request
     */
    public func request(_ createRequest: @escaping (SessionManager) throws -> DownloadRequest) -> Observable<DownloadRequest> {
        return Observable.create { observer -> Disposable in
            let request: DownloadRequest
            do {
                request = try createRequest(self.base)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            observer.onNext(request)
            
            // needs to wait for response because sending complete immediatelly will cancel the request
            request.response { response in
                if let error = response.error {
                    observer.on(.error(error as Error))
                } else {
                    observer.on(.completed)
                }
            }
            
            if !self.base.startRequestsImmediately {
                request.resume()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }

    /**
     Creates an observable of the `Request`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of the `Request`
     */
    public func request(_ method: Alamofire.HTTPMethod,
        _ URL: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<DataRequest>
    {
        return request { manager in
            return manager.request(try urlRequest(method, URL, parameters: parameters, encoding: encoding, headers: headers))
        }
    }

    /**
     Creates an observable of the `Request`.
     
     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of the `Request`
     */
    public func request(_ URLRequest: URLRequestConvertible)
        -> Observable<DataRequest>
    {
        return request { manager in
            return manager.request(URLRequest)
        }
    }

    // MARK: data
    
    /**
    Creates an observable of the data.
    
    - parameter URLRequest: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    
    - returns: An observable of the tuple `(HTTPURLResponse, Data)`
    */
    public func responseData(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<(HTTPURLResponse, Data)>
    {
        return request(
            method,
            URLString,
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
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of `Data`
     */
    public func data(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<Data>
    {
        return request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx.data() }
    }

    // MARK: string

    /**
    Creates an observable of the tuple `(HTTPURLResponse, String)`.
    
    - parameter URLRequest: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    
    - returns: An observable of the tuple `(HTTPURLResponse, String)`
    */
    public func responseString(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<(HTTPURLResponse, String)>
    {
        return request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx.responseString() }
    }

    /**
     Creates an observable of the data encoded as String.
     
     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of `String`
     */
    public func string(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<String>
    {
        return request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx.string() }
    }

    // MARK: JSON

    /**
    Creates an observable of the data decoded from JSON and processed as tuple `(HTTPURLResponse, Any)`.
    
    - parameter URLRequest: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    
    - returns: An observable of the tuple `(HTTPURLResponse, Any)`
    */
    public func responseJSON(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
    )
        -> Observable<(HTTPURLResponse, Any)>
    {
        return request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx.responseJSON() }
    }

    /**
     Creates an observable of the data decoded from JSON and processed as `Any`.
     
     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of `Any`
     */
    public func JSON(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<Any>
    {
        return request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx.JSON() }
    }

    // MARK: Upload

    /**
     Returns an observable of a request using the shared session manager instance to upload a specific file to a specified URL.
     The request is started immediately.

     - parameter URLRequest: The request object to start the upload.
     - paramenter file: An instance of NSURL holding the information of the local file.
     - returns: The observable of `Any` for the created request.
     */
    public func upload(_ URLRequest: URLRequestConvertible, file: URL) -> Observable<DataRequest> {
        return request { manager in
            return manager.upload(file, with: URLRequest)
        }
    }

    /**
     Returns an observable of a request using the shared session manager instance to upload any data to a specified URL.
     The request is started immediately.

     - parameter URLRequest: The request object to start the upload.
     - paramenter data: An instance of Data holdint the data to upload.
     - returns: The observable of `Any` for the created request.
     */
    public func upload(_ URLRequest: URLRequestConvertible, data: Data) -> Observable<DataRequest> {
        return request { manager in
            return self.base.upload(data, with: URLRequest)
        }
    }

    /**
     Returns an observable of a request using the shared session manager instance to upload any stream to a specified URL.
     The request is started immediately.

     - parameter URLRequest: The request object to start the upload.
     - paramenter stream: The stream to upload.
     - returns: The observable of `(Data?, Progress)` for the created upload request.
     */
    public func upload(_ URLRequest: URLRequestConvertible, stream: InputStream) -> Observable<DataRequest> {
        return request { manager in
            return self.base.upload(stream, with: URLRequest)
        }
    }

    // MARK: Download

    /**
     Creates a download request using the shared manager instance for the specified URL request.
     - parameter URLRequest:  The URL request.
     - parameter destination: The closure used to determine the destination of the downloaded file.
     - returns: The observable of `(Data?, Progress)` for the created download request.
     */
    public func download(_ URLRequest: URLRequestConvertible, destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
        return request { manager in
            return self.base.download(URLRequest, to: destination)
        }
    }

    /**
    Creates a request using the shared session manager instance for downloading with a resume data produced from a
    previous request cancellation.

    - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
    when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
    information.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `(Data?, Progress)` for the created download request.
    */
    public func download(resumeData data: Data, destination: @escaping DownloadRequest.DownloadFileDestination) -> Observable<DownloadRequest> {
        return request { manager in
            return self.base.download(resumingWith: data, to: destination)
        }
    }
}

// MARK: DataRequest - Data Response Handlers
extension DataRequest: ReactiveCompatible {
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
     - returns: The observable of `(HTTPURLResponse, T.SerializedObject)` for the created download request.
     */
    public func responseResult<T>(
        queue: DispatchQueue? = nil,
        responseSerializer: DataResponseSerializer<T>)
        -> Observable<(HTTPURLResponse, T)>
    {
        return Observable.create { observer in
            self.base.response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                switch packedResponse.result {
                case .success(let result):
                    if let httpResponse = packedResponse.response {
                        observer.on(.next(httpResponse, result))
                    }
                    else {
                        observer.on(.error(RxAlamofireUnknownError))
                    }
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.error(error as Error))
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     Transform a request into an observable of the serialized object.
     
     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `T.SerializedObject` for the created download request.
     */
    public func result<T>(
        queue: DispatchQueue? = nil,
        responseSerializer: DataResponseSerializer<T>)
        -> Observable<T>
    {
        return Observable.create { observer in
            self
                .validateSuccessfulResponse()
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    switch packedResponse.result {
                    case .success(let result):
                        if let _ = packedResponse.response {
                            observer.on(.next(result))
                        }
                        else {
                            observer.on(.error(RxAlamofireUnknownError))
                        }
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error as Error))
                    }
            }
            return Disposables.create()
        }
    }
    
    /**
     Returns an `Observable` of Data for the current request.
     
     - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
     
     - returns: An instance of `Observable<Data>`
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
    public func responseString(_ encoding: String.Encoding? = nil) -> Observable<(HTTPURLResponse, String)> {
        return responseResult(responseSerializer: DataRequest.stringResponseSerializer(encoding: encoding))
    }
    
    public func string(_ encoding: String.Encoding? = nil) -> Observable<String> {
        return result(responseSerializer: DataRequest.stringResponseSerializer(encoding: encoding))
    }
    
    /**
     Returns an `Observable` of a serialized JSON for the current request.
     
     - parameter options: Reading options for JSON decoding process, **default:** `.allowFragments`
     
     - returns: An instance of `Observable<Any>`
     */
    public func responseJSON(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<(HTTPURLResponse, Any)> {
        return responseResult(responseSerializer: DataRequest.jsonResponseSerializer(options: options))
    }
    
    /**
     Returns an `Observable` of a serialized JSON for the current request.
     
     - parameter options: Reading options for JSON decoding process, **default:** `.allowFragments`
     
     - returns: An instance of `Observable<Any>`
     */
    public func JSON(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
        return result(responseSerializer: DataRequest.jsonResponseSerializer(options: options))
    }
    
    /**
     Returns and `Observable` of a serialized property list for the current request.
     
     - parameter options: Property list reading options, **default:** `NSPropertyListReadOptions()`
     
     - returns: An instance of `Observable<AnyData>`
     */
    public func responsePropertyList(_ options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<(HTTPURLResponse, Any)> {
        return responseResult(responseSerializer: DataRequest.propertyListResponseSerializer(options: options))
    }
    
    public func propertyList(_ options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<Any> {
        return result(responseSerializer: DataRequest.propertyListResponseSerializer(options: options))
    }
    
    // MARK: Request - Upload and download progress
    
    /**
     Returns an `Observable` for the current progress status.
     
     Parameters on observed tuple:
     
     1. bytes written
     1. total bytes written
     1. total bytes expected to write.
     
     - returns: An instance of `Observable<(Int64, Int64, Int64)>`
     */
    public func progress() -> Observable<Progress> {
        return Observable.create { observer in
            self.base.downloadProgress { progress in
                observer.onNext(progress)
                if progress.totalUnitCount == progress.completedUnitCount {
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
            }
    }
}

// MARK: DownloadRequest - Download Response Handlers
extension DownloadRequest: ReactiveCompatible {
}

extension Reactive where Base: DownloadRequest {

    // MARK: Defaults
    
    /// - returns: A validated request based on the status code
    func validateSuccessfulResponse() -> DownloadRequest {
        return self.base.validate(statusCode: 200 ..< 300)
    }
    
    /**
     Transform a request into an observable of the response and serialized object.
     
     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `(HTTPURLResponse, T.SerializedObject)` for the created download request.
     */
    public func responseResult<T>(
        queue: DispatchQueue? = nil,
        responseSerializer: DownloadResponseSerializer<T>)
        -> Observable<(HTTPURLResponse, T)>
    {
        return Observable.create { observer in
            self.base.response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                switch packedResponse.result {
                case .success(let result):
                    if let httpResponse = packedResponse.response {
                        observer.on(.next(httpResponse, result))
                    }
                    else {
                        observer.on(.error(RxAlamofireUnknownError))
                    }
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.error(error as Error))
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     Transform a request into an observable of the serialized object.
     
     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `T.SerializedObject` for the created download request.
     */
    public func result<T>(
        queue: DispatchQueue? = nil,
        responseSerializer: DownloadResponseSerializer<T>)
        -> Observable<T>
    {
        return Observable.create { observer in
            self
                .validateSuccessfulResponse()
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    switch packedResponse.result {
                    case .success(let result):
                        if let _ = packedResponse.response {
                            observer.on(.next(result))
                        }
                        else {
                            observer.on(.error(RxAlamofireUnknownError))
                        }
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error as Error))
                    }
            }
            return Disposables.create()
        }
    }
    
    /**
     Returns an `Observable` of Data for the current request.
     
     - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
     
     - returns: An instance of `Observable<Data>`
     */
    public func responseData() -> Observable<(HTTPURLResponse, Data)> {
        return responseResult(responseSerializer: DownloadRequest.dataResponseSerializer())
    }
    
    public func data() -> Observable<Data> {
        return result(responseSerializer: DownloadRequest.dataResponseSerializer())
    }
    
    /**
     Returns an `Observable` of a String for the current request
     
     - parameter encoding: Type of the string encoding, **default:** `nil`
     
     - returns: An instance of `Observable<String>`
     */
    public func responseString(_ encoding: String.Encoding? = nil) -> Observable<(HTTPURLResponse, String)> {
        return responseResult(responseSerializer: DownloadRequest.stringResponseSerializer(encoding: encoding))
    }
    
    public func string(_ encoding: String.Encoding? = nil) -> Observable<String> {
        return result(responseSerializer: DownloadRequest.stringResponseSerializer(encoding: encoding))
    }
    
    /**
     Returns an `Observable` of a serialized JSON for the current request.
     
     - parameter options: Reading options for JSON decoding process, **default:** `.allowFragments`
     
     - returns: An instance of `Observable<Any>`
     */
    public func responseJSON(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<(HTTPURLResponse, Any)> {
        return responseResult(responseSerializer: DownloadRequest.jsonResponseSerializer(options: options))
    }
    
    /**
     Returns an `Observable` of a serialized JSON for the current request.
     
     - parameter options: Reading options for JSON decoding process, **default:** `.allowFragments`
     
     - returns: An instance of `Observable<Any>`
     */
    public func JSON(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
        return result(responseSerializer: DownloadRequest.jsonResponseSerializer(options: options))
    }
    
    /**
     Returns and `Observable` of a serialized property list for the current request.
     
     - parameter options: Property list reading options, **default:** `NSPropertyListReadOptions()`
     
     - returns: An instance of `Observable<AnyData>`
     */
    public func responsePropertyList(_ options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<(HTTPURLResponse, Any)> {
        return responseResult(responseSerializer: DownloadRequest.propertyListResponseSerializer(options: options))
    }
    
    public func propertyList(_ options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Observable<Any> {
        return result(responseSerializer: DownloadRequest.propertyListResponseSerializer(options: options))
    }
    
    // MARK: Request - Upload and download progress
    
    /**
     Returns an `Observable` for the current progress status.
     
     Parameters on observed tuple:
     
     1. bytes written
     1. total bytes written
     1. total bytes expected to write.
     
     - returns: An instance of `Observable<(Int64, Int64, Int64)>`
     */
    public func progress() -> Observable<Progress> {
        return Observable.create { observer in
            self.base.downloadProgress { progress in
                observer.onNext(progress)
                if progress.totalUnitCount == progress.completedUnitCount {
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
