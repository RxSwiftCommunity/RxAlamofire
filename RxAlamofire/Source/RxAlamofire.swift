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
    - parameter URLString: An object adopting `URLStringConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    - returns: An instance of `NSMutableURLRequest`
*/
public func URLRequest(
    method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    throws -> NSMutableURLRequest
{
    var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
    mutableURLRequest.HTTPMethod = method.rawValue

    if let headers = headers {
        for (headerField, headerValue) in headers {
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }

    if let parameters = parameters {
        let encoded = encoding.encode(mutableURLRequest, parameters: parameters)
        if let error = encoded.1 {
            throw error
        }
        mutableURLRequest = encoded.0
    }

    return mutableURLRequest
}

// MARK: Request

/**
Creates an observable of the generated `Request`.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLStringConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of a the `Request`
*/
public func request(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<Request>
{
    return Manager.sharedInstance.rx_request(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: data

/**
Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLStringConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
*/
public func requestData(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<(NSHTTPURLResponse, NSData)>
{
    return Manager.sharedInstance.rx_responseData(
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
 - parameter URLString: An object adopting `URLStringConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the addional headers
 
 - returns: An observable of `NSData`
 */
public func data(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<NSData>
{
    return Manager.sharedInstance.rx_data(
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
- parameter URLString: An object adopting `URLStringConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of the tuple `(NSHTTPURLResponse, String)`
*/
public func requestString(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<(NSHTTPURLResponse, String)>
{
    return Manager.sharedInstance.rx_responseString(
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
 - parameter URLString: An object adopting `URLStringConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the addional headers
 
 - returns: An observable of `String`
 */
public func string(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<String>
{
    return Manager.sharedInstance.rx_string(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: JSON

/**
Creates an observable of the returned decoded JSON as `AnyObject` and the response.

- parameter method: Alamofire method object
- parameter URLString: An object adopting `URLStringConvertible`
- parameter parameters: A dictionary containing all necessary options
- parameter encoding: The kind of encoding used to process parameters
- parameter header: A dictionary containing all the addional headers

- returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
*/
public func requestJSON(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<(NSHTTPURLResponse, AnyObject)>
{
    return Manager.sharedInstance.rx_responseJSON(
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
 - parameter URLString: An object adopting `URLStringConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the addional headers
 
 - returns: An observable of the decoded JSON as `AnyObject`
 */
public func JSON(method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Observable<AnyObject>
{
    return Manager.sharedInstance.rx_JSON(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

// MARK: Upload

/**
    Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter file: An instance of NSURL holding the information of the local file.
    - returns: The observable of `Request` for the created request.
 */
public func upload(URLRequest: URLRequestConvertible, file: NSURL) -> Observable<Request> {
    return Manager.sharedInstance.rx_upload(URLRequest, file: file)
}

/**
    Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter data: An instance of NSData holdint the data to upload.
    - returns: The observable of `Request` for the created request.
 */
public func upload(URLRequest: URLRequestConvertible, data: NSData) -> Observable<Request> {
    return Manager.sharedInstance.rx_upload(URLRequest, data: data)
}

/**
    Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter stream: The stream to upload.
    - returns: The observable of `Request` for the created upload request.
 */
public func upload(URLRequest: URLRequestConvertible, stream: NSInputStream) -> Observable<Request> {
    return Manager.sharedInstance.rx_upload(URLRequest, stream: stream)
}

// MARK: Download

/**
    Creates a download request using the shared manager instance for the specified URL request.
    - parameter URLRequest:  The URL request.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observable of `Request` for the created download request.
 */
public func download(URLRequest: URLRequestConvertible, destination: Request.DownloadFileDestination) -> Observable<Request> {
    return Manager.sharedInstance.rx_download(URLRequest, destination: destination)
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
public func download(resumeData data: NSData, destination: Request.DownloadFileDestination) -> Observable<Request> {
    return Manager.sharedInstance.rx_download(resumeData: data, destination: destination)
}

// MARK: Manager - Extension of Manager

extension Manager {

    // MARK: Generic request convenience
    
    /**
    Creates an observable of the returned decoded JSON.
    
    - parameter createRequest: A function used to create a `Request` using a `Manager`
    
    - returns: A generic observable of created request
    */
    public func rx_request(createRequest: (Manager) throws -> Request) -> Observable<Request> {
        return Observable.create { observer -> Disposable in
            let request: Request
            do {
                request = try createRequest(self)
            }
            catch let error {
                observer.on(.Error(error))
                return NopDisposable.instance
            }

            observer.on(.Next(request))

            // needs to wait for response because sending complete immediatelly will cancel the request
            request.response { (_, _, _, error) -> Void in
                if let error = error {
                    observer.on(.Error(error as ErrorType))
                } else {
                    observer.on(.Completed)
                }
            }

            if !self.startRequestsImmediately {
                request.resume()
            }

            return AnonymousDisposable {
                request.cancel()
            }
        }
    }

    /**
     Creates an observable of the `Request`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLStringConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of the `Request`
     */
    public func rx_request(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
    )
        -> Observable<Request>
    {
        return rx_request { manager in
            return manager.request(try URLRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers))
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
    public func rx_request(URLRequest: URLRequestConvertible)
        -> Observable<Request>
    {
        return rx_request { manager in
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
    
    - returns: An observable of the tuple `(NSHTTPURLResponse, NSData)`
    */
    public func rx_responseData(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
    )
        -> Observable<(NSHTTPURLResponse, NSData)>
    {
        return rx_request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx_responseData() }
    }
    
    /**
     Creates an observable of the data.
     
     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of `NSData`
     */
    public func rx_data(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
        )
        -> Observable<NSData>
    {
        return rx_request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx_data() }
    }

    // MARK: string

    /**
    Creates an observable of the tuple `(NSHTTPURLResponse, String)`.
    
    - parameter URLRequest: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    
    - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
    */
    public func rx_responseString(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
    )
        -> Observable<(NSHTTPURLResponse, String)>
    {
        return rx_request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx_responseString() }
    }

    /**
     Creates an observable of the data encoded as String.
     
     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of `String`
     */
    public func rx_string(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
        )
        -> Observable<String>
    {
        return rx_request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx_string() }
    }

    // MARK: JSON

    /**
    Creates an observable of the data decoded from JSON and processed as tuple `(NSHTTPURLResponse, AnyObject)`.
    
    - parameter URLRequest: An object adopting `URLRequestConvertible`
    - parameter parameters: A dictionary containing all necessary options
    - parameter encoding: The kind of encoding used to process parameters
    - parameter header: A dictionary containing all the addional headers
    
    - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
    */
    public func rx_responseJSON(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
    )
        -> Observable<(NSHTTPURLResponse, AnyObject)>
    {
        return rx_request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        ).flatMap { $0.rx_responseJSON() }
    }

    /**
     Creates an observable of the data decoded from JSON and processed as `AnyObject`.
     
     - parameter URLRequest: An object adopting `URLRequestConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of `AnyObject`
     */
    public func rx_JSON(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
        )
        -> Observable<AnyObject>
    {
        return rx_request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { $0.rx_JSON() }
    }

    // MARK: Upload

    /**
     Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
     The request is started immediately.

     - parameter URLRequest: The request object to start the upload.
     - paramenter file: An instance of NSURL holding the information of the local file.
     - returns: The observable of `AnyObject` for the created request.
     */
    public func rx_upload(URLRequest: URLRequestConvertible, file: NSURL) -> Observable<Request> {
        return rx_request { manager in
            return manager.upload(URLRequest, file: file)
        }
    }

    /**
     Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
     The request is started immediately.

     - parameter URLRequest: The request object to start the upload.
     - paramenter data: An instance of NSData holdint the data to upload.
     - returns: The observable of `AnyObject` for the created request.
     */
    public func rx_upload(URLRequest: URLRequestConvertible, data: NSData) -> Observable<Request> {
        return rx_request { manager in
            return self.upload(URLRequest, data: data)
        }
    }

    /**
     Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
     The request is started immediately.

     - parameter URLRequest: The request object to start the upload.
     - paramenter stream: The stream to upload.
     - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
     */
    public func rx_upload(URLRequest: URLRequestConvertible, stream: NSInputStream) -> Observable<Request> {
        return rx_request { manager in
            return self.upload(URLRequest, stream: stream)
        }
    }

    // MARK: Download

    /**
     Creates a download request using the shared manager instance for the specified URL request.
     - parameter URLRequest:  The URL request.
     - parameter destination: The closure used to determine the destination of the downloaded file.
     - returns: The observable of `(NSData?, RxProgress)` for the created download request.
     */
    public func rx_download(URLRequest: URLRequestConvertible, destination: Request.DownloadFileDestination) -> Observable<Request> {
        return rx_request { manager in
            return self.download(URLRequest, destination: destination)
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
    public func rx_download(resumeData data: NSData, destination: Request.DownloadFileDestination) -> Observable<Request> {
        return rx_request { manager in
            return self.download(data, destination: destination)
        }
    }
}

// MARK: Request - Common Response Handlers
extension Request {

    // MARK: Defaults
    
    /// - returns: A validated request based on the status code
    func rx_validateSuccessfulResponse() -> Request {
        return self.validate(statusCode: 200 ..< 300)
    }
    
    /**
     Transform a request into an observable of the response and serialized object.
     
     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `(NSHTTPURLResponse, T.SerializedObject)` for the created download request.
     */
    public func rx_responseResult<T: ResponseSerializerType>(
        queue queue: dispatch_queue_t? = nil,
        responseSerializer: T)
        -> Observable<(NSHTTPURLResponse, T.SerializedObject)>
    {
        return Observable.create { observer in
            self.response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                switch packedResponse.result {
                case .Success(let result):
                    if let httpResponse = packedResponse.response {
                        observer.on(.Next(httpResponse, result))
                    }
                    else {
                        observer.on(.Error(RxAlamofireUnknownError))
                    }
                    observer.on(.Completed)
                case .Failure(let error):
                    observer.on(.Error(error as ErrorType))
                }
            }
            return NopDisposable.instance
        }
    }

    /**
     Transform a request into an observable of the serialized object.
     
     - parameter queue: The dispatch queue to use.
     - parameter responseSerializer: The the serializer.
     - returns: The observable of `T.SerializedObject` for the created download request.
     */
    public func rx_result<T: ResponseSerializerType>(
        queue queue: dispatch_queue_t? = nil,
        responseSerializer: T)
        -> Observable<T.SerializedObject>
    {
        return Observable.create { observer in
            self
                .rx_validateSuccessfulResponse()
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    switch packedResponse.result {
                    case .Success(let result):
                        if let _ = packedResponse.response {
                            observer.on(.Next(result))
                        }
                        else {
                            observer.on(.Error(RxAlamofireUnknownError))
                        }
                        observer.on(.Completed)
                    case .Failure(let error):
                        observer.on(.Error(error as ErrorType))
                    }
                }
            return NopDisposable.instance
        }
    }

    /**
    Returns an `Observable` of NSData for the current request.
    
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<NSData>`
    */
    public func rx_responseData() -> Observable<(NSHTTPURLResponse, NSData)> {
        return rx_responseResult(responseSerializer: Request.dataResponseSerializer())
    }

    public func rx_data() -> Observable<NSData> {
        return rx_result(responseSerializer: Request.dataResponseSerializer())
    }

    /**
    Returns an `Observable` of a String for the current request
    
    - parameter encoding: Type of the string encoding, **default:** `nil`

    - returns: An instance of `Observable<String>`
    */
    public func rx_responseString(encoding: NSStringEncoding? = nil) -> Observable<(NSHTTPURLResponse, String)> {
        return rx_responseResult(responseSerializer: Request.stringResponseSerializer(encoding: encoding))
    }

    public func rx_string(encoding: NSStringEncoding? = nil) -> Observable<String> {
        return rx_result(responseSerializer: Request.stringResponseSerializer(encoding: encoding))
    }
    
    /**
    Returns an `Observable` of a serialized JSON for the current request.
    
    - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

    - returns: An instance of `Observable<AnyObject>`
    */
    public func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments) -> Observable<(NSHTTPURLResponse, AnyObject)> {
        return rx_responseResult(responseSerializer: Request.JSONResponseSerializer(options: options))
    }

    /**
     Returns an `Observable` of a serialized JSON for the current request.

     - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

     - returns: An instance of `Observable<AnyObject>`
     */
    public func rx_JSON(options: NSJSONReadingOptions = .AllowFragments) -> Observable<AnyObject> {
        return rx_result(responseSerializer: Request.JSONResponseSerializer(options: options))
    }

    /**
    Returns and `Observable` of a serialized property list for the current request.
    
    - parameter options: Property list reading options, **default:** `NSPropertyListReadOptions()`

    - returns: An instance of `Observable<AnyData>`
    */
    public func rx_responsePropertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions()) -> Observable<(NSHTTPURLResponse, AnyObject)> {
        return rx_responseResult(responseSerializer: Request.propertyListResponseSerializer(options: options))
    }

    public func rx_propertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions()) -> Observable<AnyObject> {
        return rx_result(responseSerializer: Request.propertyListResponseSerializer(options: options))
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
    public func rx_progress() -> Observable<RxProgress> {
        return Observable.create { observer in
            self.progress() { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in

                observer.onNext(RxProgress(bytesWritten: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite))

                if totalBytesWritten >= totalBytesExpectedToWrite {
                    observer.onCompleted()
                }

            }

            return NopDisposable.instance
            }
            // warm up a bit :)
            .startWith(RxProgress(bytesWritten: 0, totalBytesWritten: 0, totalBytesExpectedToWrite: 0))
    }
}

// MARK: RxProgress
public struct RxProgress {
    let bytesWritten: Int64
    let totalBytesWritten: Int64
    let totalBytesExpectedToWrite: Int64

    public init(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.bytesWritten = bytesWritten
        self.totalBytesWritten = totalBytesWritten
        self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
    }
    
    public func floatValue() -> Float {
        if totalBytesExpectedToWrite > 0 {
            return Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
        else {
            return 0
        }
    }
}
