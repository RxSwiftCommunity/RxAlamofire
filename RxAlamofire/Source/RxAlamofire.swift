//
//  RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. (@bontojr) on 23/08/15.
//  Developed with the kind help of Krunoslav Zaher (@KrunoslavZaher)
//
//  Updated by Ivan Đikić for the latest version of Alamofire(3) and RxSwift(2) on 21/10/15
//
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

// MARK: Wrap of global functions

/**
    Returns an observalbe of a request using the shared manager instance for the specified URL request.
    The request is started immediately.

    - parameter URLRequest: The URL to create the request
    - returns: The observalbe of `NSData` for the created request.
*/
public func rx_request(URLRequest: URLRequestConvertible) -> Observable<NSData> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.request(URLRequest.URLRequest)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        request.response() { request, response, data, error in
            if let e = error {
                observer.on(.Error(e as ErrorType))
            } else {
                if let d = data {
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(d)
                        observer.onComplete()
                    } else {
                        observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                } else {
                    observer.onError(error ?? NSError(domain: "Empty data received", code: -1, userInfo: nil))
                }
            }
        }
        
        return AnonymousDisposable {
            request.cancel()
        }
    }
}

/**
    Returns an observalbe of a request (with all information) using the shared manager instance for the specified URL request.
    The request is started immediately.

    - parameter URLRequest: The URL to create the request
    - returns: The observalbe of `(NSURLRequest, NSHTTPURLResponse, NSData)` for the created request.
 */
public func rx_requestFull(URLRequest: URLRequestConvertible) -> Observable<(NSURLRequest, NSHTTPURLResponse, NSData)> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.request(URLRequest.URLRequest)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        request.response() { request, response, data, error in
            if let e = error {
                observer.on(.Error(e as ErrorType))
            } else {
                if let d = data {
                    if let res = response, req = request where 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext((req, res, d))
                        observer.onComplete()
                    } else {
                        observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                } else {
                    observer.onError(error ?? NSError(domain: "Empty data received", code: -1, userInfo: nil))
                }
            }
        }
        
        return AnonymousDisposable {
            request.cancel()
        }
    }
}

/**
    Returns an observalbe of a request using the shared manager instance for the specified URL request.
    The request is started immediately.

    - parameter URLRequest: The URL to create the request
    - paramenter ecoding: The string encoding to use
    - returns: The observalbe of `String` for the created request.
 */
public func rx_requestString(URLRequest: URLRequestConvertible, encoding: NSStringEncoding? = nil) -> Observable<String> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.request(URLRequest.URLRequest)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        request.responseString(encoding: encoding) { responseData in
            let result = responseData.result
            let response = responseData.response
            
            switch result {
            case .Success(let s):
                if 200 ..< 300 ~= response?.statusCode ?? 0 {
                    observer.onNext(s)
                    observer.onComplete()
                } else {
                    observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                        code: -1,
                        userInfo: nil))
                }
            case .Failure(let e):
                observer.onError(e)
            }
        }
        
        return AnonymousDisposable {
            request.cancel()
        }
    }
}

/**
    Returns an observalbe of a request using the shared manager instance for the specified URL request.
    The request is started immediately.

    - parameter URLRequest: The URL to create the request.
    - parameter options: The JSON reading options.
    - returns: The observalbe of `AnyObject` for the created request.
 */
public func rx_requestJSON(URLRequest: URLRequestConvertible, options: NSJSONReadingOptions = .AllowFragments) -> Observable<AnyObject> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.request(URLRequest.URLRequest)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        request.responseJSON(options: options) { responseData in
            
            let result = responseData.result
            let response = responseData.response
            
            switch result {
            case .Success(let d):
                if 200 ..< 300 ~= response?.statusCode ?? 0 {
                    observer.onNext(d)
                    observer.onComplete()
                } else {
                    observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                        code: -1,
                        userInfo: nil))
                }
            case .Failure(let e):
                observer.onError(e)
            }
            
        }
        
        return AnonymousDisposable {
            request.cancel()
        }
    }
}

/**
    Returns an observalbe of a request using the shared manager instance to upload a specific file to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter file: An instance of NSURL holding the information of the local file.
    - returns: The observalbe of `AnyObject` for the created request.
 */
public func rx_upload(URLRequest: URLRequestConvertible, file: NSURL) -> Observable<(NSData?, RxProgess)> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.upload(URLRequest, file: file)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }

        return handleProgress(request, observer: observer)
    }
}

/**
    Returns an observalbe of a request using the shared manager instance to upload any data to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter data: An instance of NSData holdint the data to upload.
    - returns: The observalbe of `AnyObject` for the created request.
 */
public func rx_upload(URLRequest: URLRequestConvertible, data: NSData) -> Observable<(NSData?, RxProgess)> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.upload(URLRequest, data: data)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        return handleProgress(request, observer: observer)
    }
}

/**
    Returns an observalbe of a request using the shared manager instance to upload any stream to a specified URL.
    The request is started immediately.

    - parameter URLRequest: The request object to start the upload.
    - paramenter stream: The stream to upload.
    - returns: The observalbe of `(NSData?, RxProgress)` for the created upload request.
 */
public func rx_upload(URLRequest: URLRequestConvertible, stream: NSInputStream) -> Observable<(NSData?, RxProgess)> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.upload(URLRequest, stream: stream)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        return handleProgress(request, observer: observer)
    }
}

/**
    Creates a download request using the shared manager instance for the specified URL request.
    - parameter URLRequest:  The URL request.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observalbe of `(NSData?, RxProgress)` for the created download request.
 */
public func rx_download(URLRequest: URLRequestConvertible, destination: Request.DownloadFileDestination) -> Observable<(NSData?, RxProgess)> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.download(URLRequest, destination: destination)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        return handleProgress(request, observer: observer)
    }
}

// MARK: Resume Data

/**
    Creates a request using the shared manager instance for downloading from the resume data produced from a
    previous request cancellation.

    - parameter resumeData:  The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask`
    when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional
    information.
    - parameter destination: The closure used to determine the destination of the downloaded file.
    - returns: The observalbe of `(NSData?, RxProgress)` for the created download request.
*/
public func rx_download(resumeData data: NSData, destination: Request.DownloadFileDestination) -> Observable<(NSData?, RxProgess)> {
    return create() { observer -> Disposable in
        let request = Manager.sharedInstance.download(data, destination: destination)
        
        if Manager.sharedInstance.startRequestsImmediately == false {
            request.resume()
        }
        
        return handleProgress(request, observer: observer)
    }
}

// MARK: Internal convenience
internal func handleProgress(request: Request, observer: AnyObserver<(NSData?, RxProgess)>) -> Disposable {
    var progress: RxProgess?
    
    request.response() { request, response, data, error in
        if let e = error {
            observer.on(.Error(e as ErrorType))
        } else {
            if let d = data {
                if 200 ..< 300 ~= response?.statusCode ?? 0 {
                    if let progress = progress {
                        observer.onNext((d, progress))
                        observer.onComplete()
                    } else {
                        observer.onNext((d, RxProgess.None))
                        observer.onComplete()
                    }
                } else {
                    observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                        code: -1,
                        userInfo: nil))
                }
            } else {
                observer.onError(error ?? NSError(domain: "Empty data received", code: -1, userInfo: nil))
            }
        }
    }
    
    request.progress() { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
        let p = RxProgess(bytesWritten: bytesWritten,
            totalBytesWritten: totalBytesWritten,
            totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        progress = p
        observer.onNext((nil, p))
    }
    
    return AnonymousDisposable {
        request.cancel()
    }
}

// MARK: Request - Common Response Handlers
extension Request {
    
    /**
    Returns an `Observable` of NSData for the current request.
    
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<NSData>`
    */
    func rx_response(cancelOnDispose: Bool = false) -> Observable<NSData> {
        
        return create { observer -> Disposable in
            
            self.response { request, response, data, error in
                
                if let e = error as NSError? {
                    observer.onError(e)
                } else {
                    if let d = data {
                        if 200 ..< 300 ~= response?.statusCode ?? 0 {
                            observer.onNext(d)
                            observer.onComplete()
                        } else {
                            observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                                code: -1,
                                userInfo: nil))
                        }
                    } else {
                        observer.onError(error ?? NSError(domain: "Empty data received", code: -1, userInfo: nil))
                    }
                }
                
            }
            
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
            
        }
    }
    
    /**
    Returns an `Observable` of a String for the current request
    
    - parameter encoding:        Type of the string encoding, **default:** `nil`
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<String>`
    */
    func rx_responseString(encoding: NSStringEncoding? = nil, cancelOnDispose: Bool = false) -> Observable<String> {
        
        return create { observer -> Disposable in
            
            self.responseString(encoding: encoding) { responseData in
                
                let result = responseData.result
                let response = responseData.response
                
                switch result {
                case .Success(let s):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(s)
                        observer.onComplete()
                    } else {
                        observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                case .Failure(let e):
                    observer.onError(e)
                }
                
            }
            
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
            
        }
        
    }
    
    /**
    Returns an `Observable` of a deserialized JSON for the current request.
    
    - parameter options:         Reading options for JSON decoding process, **default:** `.AllowFragments`
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<AnyObject>`
    */
    func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments, cancelOnDispose: Bool = false) -> Observable<AnyObject> {
        
        return create { observer in
            
            self.responseJSON(options: options) { responseData in
                
                let result = responseData.result
                let response = responseData.response
                
                switch result {
                case .Success(let d):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(d)
                        observer.onComplete()
                    } else {
                        observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                case .Failure(let e):
                    observer.onError(e)
                }
                
            }
            
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
        }
    }
    
    /**
    Returns and `Observable` of a deserialized property list for the current request.
    
    - parameter options:         Property list reading options, **default:** `NSPropertyListReadOptions()`
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<AnyData>`
    */
    func rx_responsePropertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions(), cancelOnDispose: Bool = false) -> Observable<AnyObject> {
        
        return create { observer in
            
            self.responsePropertyList(options: options) { responseData in
                
                let result = responseData.result
                let response = responseData.response
                
                switch result {
                case .Success(let d):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.onNext(d)
                        observer.onComplete()
                    } else {
                        observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                            code: -1,
                            userInfo: nil))
                    }
                case .Failure(let e):
                    observer.onError(e)
                }
                
            }
            
            return AnonymousDisposable {
                if cancelOnDispose {
                    self.cancel()
                }
            }
        }
        
    }
    
}

// MARK: Request - Upload and download progress
extension Request {
    
    /**
    Returns an `Observable` for the current progress status.
    
    Parameters on observed tuple:
    
    1. bytes written
    1. total bytes written
    1. total bytes expected to write.
    
    - returns: An instance of `Observable<(Int64, Int64, Int64)>`
    */
    func rx_progress() -> Observable<(Int64, Int64, Int64)> {
        
        return create { observer in
            
            self.progress() { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                
                observer.onNext((bytesWritten, totalBytesWritten, totalBytesExpectedToWrite))
                
            }
            
            return AnonymousDisposable {
            }
        }
    }
}

// MARK: RxProgress
public struct RxProgess {
    let bytesWritten: Int64
    let totalBytesWritten: Int64
    let totalBytesExpectedToWrite: Int64
    
    public static let None = RxProgess(bytesWritten: 0, totalBytesWritten: 0, totalBytesExpectedToWrite: 0)
    
    init(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.bytesWritten = bytesWritten
        self.totalBytesWritten = totalBytesWritten
        self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
    }
}

// MARK: Response Code
enum RxResponse: Int {
    case OK = 200
    case Created = 201
    case Accepted = 202
    
    case MovedPermanently = 301
    case TemporaryRedirect = 307
    
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case RequestTimeout = 408
    
    case InternalServerError = 500
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    
    case Unknown = 0
}