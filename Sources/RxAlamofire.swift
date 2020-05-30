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

public func urlRequest(_ method: HTTPMethod,
                       _ url: URLConvertible,
                       parameters: Parameters? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: HTTPHeaders? = nil)
  throws -> Foundation.URLRequest {
    var mutableURLRequest = Foundation.URLRequest(url: try url.asURL())
    mutableURLRequest.httpMethod = method.rawValue
    
    if let headers = headers {
      for header in headers {
        mutableURLRequest.setValue(header.value, forHTTPHeaderField: header.name)
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
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of a the `Request`
 */
public func request(_ method: HTTPMethod,
                    _ url: URLConvertible,
                    parameters: Parameters? = nil,
                    encoding: ParameterEncoding = URLEncoding.default,
                    headers: HTTPHeaders? = nil,
                    interceptor: RequestInterceptor? = nil,
                    requestModifier: Session.RequestModifier? = nil)
  -> Observable<DataRequest> {
    return Alamofire.Session.default.rx
      .request(method,
               url,
               parameters: parameters,
               encoding: encoding,
               headers: headers,
               interceptor: interceptor,
               requestModifier: requestModifier)
}

/**
 Creates an observable of the generated `Request`.
 
 - parameter urlRequest: An object adopting `URLRequestConvertible`
 
 - returns: An observable of a the `Request`
 */
public func request(_ urlRequest: URLRequestConvertible) -> Observable<DataRequest> {
  return Alamofire.Session.default.rx.request(urlRequest: urlRequest)
}

// MARK: data

/**
 Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
 */
public func requestData(_ method: HTTPMethod,
                        _ url: URLConvertible,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,
                        interceptor: RequestInterceptor? = nil,
                        requestModifier: Session.RequestModifier? = nil)
  -> Observable<(HTTPURLResponse, Data)> {
    return Alamofire.Session.default.rx
      .responseData(method,
                    url,
                    parameters: parameters,
                    encoding: encoding,
                    headers: headers,
                    interceptor: interceptor,
                    requestModifier: requestModifier)
}

/**
 Creates an observable of the `(NSHTTPURLResponse, NSData)` instance.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of a tuple containing `(NSHTTPURLResponse, NSData)`
 */
public func requestData(_ urlRequest: URLRequestConvertible)
  -> Observable<(HTTPURLResponse, Data)> {
    return request(urlRequest).flatMap { $0.rx.responseData() }
}

/**
 Creates an observable of the returned data.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of `NSData`
 */
public func data(_ method: HTTPMethod,
                 _ url: URLConvertible,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil,
                 requestModifier: Session.RequestModifier? = nil)
  -> Observable<Data> {
    return Alamofire.Session.default.rx
      .data(method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier)
}

// MARK: string

/**
 Creates an observable of the returned decoded string and response.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
 */
public func requestString(_ method: HTTPMethod,
                          _ url: URLConvertible,
                          parameters: Parameters? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          headers: HTTPHeaders? = nil,
                          interceptor: RequestInterceptor? = nil,
                          requestModifier: Session.RequestModifier? = nil)
  -> Observable<(HTTPURLResponse, String)> {
    return Alamofire.Session.default.rx
      .responseString(method,
                      url,
                      parameters: parameters,
                      encoding: encoding,
                      headers: headers,
                      interceptor: interceptor,
                      requestModifier: requestModifier)
}

/**
 Creates an observable of the returned decoded string and response.

 - parameter urlRequest: An object adopting `URLRequestConvertible`

 - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
 */
public func requestString(_ urlRequest: URLRequestConvertible)
  -> Observable<(HTTPURLResponse, String)> {
    return request(urlRequest).flatMap { $0.rx.responseString() }
}

/**
 Creates an observable of the returned decoded string.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of `String`
 */
public func string(_ method: HTTPMethod,
                   _ url: URLConvertible,
                   parameters: Parameters? = nil,
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   requestModifier: Session.RequestModifier? = nil)
  -> Observable<String> {
    return Alamofire.Session.default.rx
      .string(method,
              url,
              parameters: parameters,
              encoding: encoding,
              headers: headers,
              interceptor: interceptor,
              requestModifier: requestModifier)
}

// MARK: JSON

/**
 Creates an observable of the returned decoded JSON as `AnyObject` and the response.

 - parameter method: Alamofire method object
 - parameter url: An object adopting `URLConvertible`
 - parameter parameters: A dictionary containing all necessary options
 - parameter encoding: The kind of encoding used to process parameters
 - parameter header: A dictionary containing all the additional headers
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
 */
public func requestJSON(_ method: HTTPMethod,
                        _ url: URLConvertible,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,
                        interceptor: RequestInterceptor? = nil,
                        requestModifier: Session.RequestModifier? = nil)
  -> Observable<(HTTPURLResponse, Any)> {
    return Alamofire.Session.default.rx
      .responseJSON(method,
                    url,
                    parameters: parameters,
                    encoding: encoding,
                    headers: headers,
                    interceptor: interceptor,
                    requestModifier: requestModifier)
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
 - parameter headers: A dictionary containing all the additional headers
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

 - returns: An observable of the decoded JSON as `Any`
 */
public func json(_ method: HTTPMethod,
                 _ url: URLConvertible,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil,
                 requestModifier: Session.RequestModifier? = nil)
  -> Observable<Any> {
    return Alamofire.Session.default.rx
      .json(method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier)
}

// MARK: Upload

/**
 Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
 The request is started immediately.

 - parameter file: An instance of NSURL holding the information of the local file.
 - parameter urlRequest: The request object to start the upload.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
 - returns: The observable of `UploadRequest` for the created request.
 */
public func upload(_ file: URL,
                   urlRequest: URLRequestConvertible,
                   interceptor: RequestInterceptor? = nil,
                   fileManager:FileManager? = nil)
  -> Observable<UploadRequest> {
    return Alamofire.Session.default.rx.upload(file, urlRequest: urlRequest)
}

/**
 Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
 The request is started immediately.
 
 - parameter fileURL: The `URL` of the file to upload.
 - parameter urlRequest: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
 - parameter method: `HTTPMethod` for the `URLRequest`. `.post` by default.
 - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.

 - returns: The observable of `AnyObject` for the created request.
 */
public func upload(_ file: URL,
                   urlRequest: URLConvertible,
                   method: HTTPMethod = .post,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   fileManager:FileManager? = nil,
                   requestModifier: Session.RequestModifier? = nil)
 -> Observable<UploadRequest> {
  return Alamofire.Session.default.rx
    .upload(file,
            urlRequest: urlRequest,
            method: method,
            headers: headers,
            interceptor: interceptor,
            fileManager: fileManager,
            requestModifier: requestModifier)
}


/**
 Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
 The request is started immediately.
 
 - parameter data: An instance of Data holdint the data to upload.
 - parameter urlRequest: The request object to start the upload.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`

 - returns: The observable of `UploadRequest` for the created request.
 */
public func upload(_ data: Data,
                   urlRequest: URLRequestConvertible,
                   interceptor: RequestInterceptor? = nil,
                   fileManager:FileManager? = nil)
  -> Observable<UploadRequest> {
    
      return Alamofire.Session.default.rx
        .upload(data,
                urlRequest: urlRequest,
                interceptor: interceptor,
                fileManager: fileManager)
    
}

/**
 Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
 The request is started immediately.

 - parameter data: The `Data` to upload.
 - parameter urlRequest: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
 - parameter method: `HTTPMethod` for the `URLRequest`. `.post` by default.
 - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.

 - returns: The observable of `AnyObject` for the created request.
 */
public func upload(_ data: Data,
                   urlRequest: URLConvertible,
                   method: HTTPMethod,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   fileManager:FileManager? = nil,
                   requestModifier: Session.RequestModifier? = nil)
  -> Observable<UploadRequest> {
    return Alamofire.Session.default.rx
      .upload(data,
              urlRequest: urlRequest,
              method: method,
              headers: headers,
              interceptor: interceptor,
              fileManager: fileManager,
              requestModifier: requestModifier)
}

/**
 Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
 The request is started immediately.

 - parameter stream: The stream to upload.
 - parameter urlRequest: The request object to start the upload.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`

 - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
 */
public func upload(_ stream: InputStream,
                   urlRequest: URLRequestConvertible,
                   interceptor: RequestInterceptor? = nil,
                   fileManager:FileManager? = nil)
  -> Observable<UploadRequest> {
    
    return Alamofire.Session.default.rx
      .upload(stream,
              urlRequest: urlRequest,
              interceptor: interceptor,
              fileManager: fileManager)
}

/**
 Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
 The request is started immediately.

 - parameter stream: The stream to upload.
 - parameter urlRequest: The request object to start the upload.
 - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.
 
 - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
 */
public func upload(_ stream: InputStream,
                   urlRequest: URLConvertible,
                   method: HTTPMethod,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   fileManager:FileManager? = nil,
                   requestModifier: Session.RequestModifier? = nil)
  -> Observable<UploadRequest> {
    return Alamofire.Session.default.rx
      .upload(stream,
              urlRequest: urlRequest,
              method: method,
              headers: headers,
              interceptor: interceptor,
              fileManager: fileManager ?? FileManager.default,
              requestModifier: requestModifier)
}

// MARK: Download

/**
 Creates a download request using the shared manager instance for the specified URL request.
 - parameter urlRequest:  The URL request.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter destination: The closure used to determine the destination of the downloaded file.
 - returns: The observable of `DownloadRequest` for the created download request.
 */
public func download(_ urlRequest: URLRequestConvertible,
                     interceptor: RequestInterceptor? = nil,
                     to destination: @escaping DownloadRequest.Destination) -> Observable<DownloadRequest> {
  return Alamofire.Session.default.rx.download(urlRequest,
                                               interceptor: interceptor,
                                               to: destination)
}

/**
 Creates a download request using the shared manager instance for the specified URL request.
 - parameter method: `HTTPMethod` for the `URLRequest`. `.post` by default.
 - parameter urlRequest:  The URL request.
 - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
 - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
 - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
 - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided
 
 - returns: The observable of `DownloadRequest` for the created download request.
 */
public func download(method: HTTPMethod,
                     urlRequest: URLConvertible,
                     parameters: Parameters?,
                     encoding: ParameterEncoding,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     requestModifier: Session.RequestModifier? = nil,
                     to destination: @escaping DownloadRequest.Destination)
  -> Observable<DownloadRequest> {
  return Alamofire.Session.default.rx
    .download(method: method,
              urlRequest: urlRequest,
              parameters: parameters,
              encoding: encoding,
              headers: headers,
              interceptor: interceptor,
              requestModifier: requestModifier,
              to: destination)
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
                     to destination: @escaping DownloadRequest.Destination) -> Observable<DownloadRequest> {
  return Alamofire.Session.default.rx.download(resumeData: resumeData, to: destination)
}

// MARK: Manager - Extension of Manager

extension Alamofire.Session: ReactiveCompatible {}

protocol RxAlamofireRequest {
  func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void)
  func resume() -> Self
  func cancel() -> Self
}

protocol RxAlamofireResponse {
  var error: Error? { get }
}

extension DataResponse: RxAlamofireResponse {
  var error: Error? {
    switch result {
    case let .failure(error):
      return error
    default:
      return nil
    }
  }
}

extension DownloadResponse: RxAlamofireResponse {
  var error: Error? {
    switch result {
    case let .failure(error):
      return error
    default:
      return nil
    }
  }
}

extension DataRequest: RxAlamofireRequest {
  func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
    response { response in
      completionHandler(response)
    }
  }
}

extension DownloadRequest: RxAlamofireRequest {
  func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
    response { response in
      completionHandler(response)
    }
  }
}

extension Reactive where Base: Alamofire.Session {
  // MARK: Generic request convenience

  /**
   Creates an observable of the DataRequest.

   - parameter createRequest: A function used to create a `Request` using a `Manager`

   - returns: A generic observable of created data request
   */
  func request<R: RxAlamofireRequest>(_ createRequest: @escaping (Alamofire.Session) throws -> R) -> Observable<R> {
    return Observable.create { observer -> Disposable in
      let request: R
      do {
        request = try createRequest(self.base)
        observer.on(.next(request))
        request.responseWith(completionHandler: { response in
          if let error = response.error {
            observer.on(.error(error))
          } else {
            observer.on(.completed)
          }
        })

        if !self.base.startRequestsImmediately {
          _ = request.resume()
        }

        return Disposables.create {
          _ = request.cancel()
        }
      } catch {
        observer.on(.error(error))
        return Disposables.create()
      }
    }
  }

  /**
   Creates an observable of the `Request`.

   - parameter method: Alamofire method object
   - parameter url: An object adopting `URLConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameters. `nil` by default.

   - returns: An observable of the `Request`
   */
  public func request(_ method: HTTPMethod,
                      _ url: URLConvertible,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      interceptor: RequestInterceptor? = nil,
                      requestModifier: Session.RequestModifier? = nil)
    -> Observable<DataRequest> {
      return request { manager in
        manager.request(url,
                        method: method,
                        parameters: parameters,
                        encoding: encoding,
                        headers: headers,
                        interceptor: interceptor,
                        requestModifier: requestModifier)
      }
  }
  
  /**
   Creates an observable of the `Request`.

   - parameter URLRequest: An object adopting `URLRequestConvertible`

   - returns: An observable of the `Request`
   */
  public func request(urlRequest: URLRequestConvertible)
    -> Observable<DataRequest> {
      return request { manager in
        manager.request(urlRequest)
      }
  }

  // MARK: data

  /**
   Creates an observable of the data.

   - parameter url: An object adopting `URLConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameters. `nil` by default.

   - returns: An observable of the tuple `(NSHTTPURLResponse, NSData)`
   */
  public func responseData(_ method: HTTPMethod,
                           _ url: URLConvertible,
                           parameters: Parameters? = nil,
                           encoding: ParameterEncoding = URLEncoding.default,
                           headers: HTTPHeaders? = nil,
                           interceptor: RequestInterceptor? = nil,
                           requestModifier: Session.RequestModifier? = nil)
    -> Observable<(HTTPURLResponse, Data)> {
      return request(method,
                     url,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers,
                     interceptor: interceptor,
                     requestModifier: requestModifier)
        .flatMap { $0.rx.responseData() }
  }

  /**
   Creates an observable of the data.

   - parameter URLRequest: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameters. `nil` by default.

   - returns: An observable of `NSData`
   */
  public func data(_ method: HTTPMethod,
                   _ url: URLConvertible,
                   parameters: Parameters? = nil,
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   requestModifier: Session.RequestModifier? = nil)
    -> Observable<Data> {
      return request(method,
                     url,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers,
                     interceptor: interceptor,
                     requestModifier: requestModifier)
        .flatMap { $0.rx.data() }
  }

  // MARK: string

  /**
   Creates an observable of the tuple `(NSHTTPURLResponse, String)`.

   - parameter url: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameters. `nil` by default.

   - returns: An observable of the tuple `(NSHTTPURLResponse, String)`
   */
  public func responseString(_ method: HTTPMethod,
                             _ url: URLConvertible,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: HTTPHeaders? = nil,
                             interceptor: RequestInterceptor? = nil,
                             requestModifier: Session.RequestModifier? = nil)
    -> Observable<(HTTPURLResponse, String)> {
      return request(method,
                     url,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers,
                     interceptor: interceptor,
                     requestModifier: requestModifier)
        .flatMap { $0.rx.responseString() }
  }

  /**
   Creates an observable of the data encoded as String.

   - parameter url: An object adopting `URLConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided
   - returns: An observable of `String`
   */
  public func string(_ method: HTTPMethod,
                     _ url: URLConvertible,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     requestModifier: Session.RequestModifier? = nil)
    -> Observable<String> {
      return request(method,
                     url,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers,
                     interceptor: interceptor,
                     requestModifier: requestModifier)
        .flatMap { (request) -> Observable<String> in
          request.rx.string()
      }
  }

  // MARK: JSON

  /**
   Creates an observable of the data decoded from JSON and processed as tuple `(NSHTTPURLResponse, AnyObject)`.

   - parameter url: An object adopting `URLRequestConvertible`
   - parameter parameters: A dictionary containing all necessary options
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

   - returns: An observable of the tuple `(NSHTTPURLResponse, AnyObject)`
   */
  public func responseJSON(_ method: HTTPMethod,
                           _ url: URLConvertible,
                           parameters: Parameters? = nil,
                           encoding: ParameterEncoding = URLEncoding.default,
                           headers: HTTPHeaders? = nil,
                           interceptor: RequestInterceptor? = nil,
                           requestModifier: Session.RequestModifier? = nil)
    -> Observable<(HTTPURLResponse, Any)> {
      return request(method,
                     url,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers,
                     interceptor: interceptor,
                     requestModifier: requestModifier)
        .flatMap { $0.rx.responseJSON() }
  }

  /**
   Creates an observable of the data decoded from JSON and processed as `AnyObject`.

   - parameter parameters: A dictionary containing all necessary options
   - parameter URLRequest: An object adopting `URLRequestConvertible`
   - parameter encoding: The kind of encoding used to process parameters
   - parameter headers: A dictionary containing all the additional headers
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided

   - returns: An observable of `AnyObject`
   */
  public func json(_ method: HTTPMethod,
                   _ url: URLConvertible,
                   parameters: Parameters? = nil,
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   requestModifier: Session.RequestModifier? = nil)
    -> Observable<Any> {
      return request(method,
                     url,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers,
                     interceptor: interceptor,
                     requestModifier: requestModifier)
        .flatMap { $0.rx.json() }
  }

  // MARK: Upload

  /**
   Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
   The request is started immediately.

   - parameter urlRequest: The request object to start the upload.
   - parameter file: An instance of NSURL holding the information of the local file.
   
   - parameter convertible: `URLRequestConvertible` value to be used to create the `URLRequest`.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default` instance by default.

   - returns: The observable of `AnyObject` for the created request.
   */
  public func upload(_ file: URL,
                     urlRequest: URLRequestConvertible,
                     interceptor: RequestInterceptor? = nil,
                     fileManager:FileManager? = nil)
    -> Observable<UploadRequest> {
      return request { manager in
        manager.upload(file,
                       with: urlRequest,
                       interceptor: interceptor,
                       fileManager: fileManager ?? FileManager.default)
      }
  }

  /**
   Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
   The request is started immediately.
   
   - parameter fileURL: The `URL` of the file to upload.
   - parameter urlRequest: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
   - parameter method: `HTTPMethod` for the `URLRequest`. `.post` by default.
   - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.
  
   - returns: The observable of `AnyObject` for the created request.
   */
  public func upload(_ file: URL,
                     urlRequest: URLConvertible,
                     method: HTTPMethod,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     fileManager:FileManager? = nil,
                     requestModifier: Session.RequestModifier? = nil)
    -> Observable<UploadRequest> {
      return request { manager in
        manager.upload(file,
                       to: urlRequest,
                       method: method,
                       headers: headers,
                       interceptor: interceptor,
                       fileManager: fileManager ?? FileManager.default,
                       requestModifier: requestModifier)
      }
  }

  /**
   Returns an observable of a request using the shared manager instance to upload any data to a specified URL.
   The request is started immediately.
   
   - parameter data: An instance of Data holdint the data to upload.
   - parameter urlRequest: The request object to start the upload.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`

   - returns: The observable of `UploadRequest` for the created request.
   */
  public func upload(_ data: Data,
                     urlRequest: URLRequestConvertible,
                     interceptor: RequestInterceptor? = nil,
                     fileManager:FileManager? = nil)
    -> Observable<UploadRequest> {
      return request { manager in
        manager.upload(data,
                       with: urlRequest,
                       interceptor: interceptor,
                       fileManager: fileManager ?? FileManager.default)
      }
  }
  
  /**
   Returns an observable of a request using the shared manager instance to upload a specific file to a specified URL.
   The request is started immediately.

   - parameter data: The `Data` to upload.
   - parameter urlRequest: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
   - parameter method: `HTTPMethod` for the `URLRequest`. `.post` by default.
   - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.

   - returns: The observable of `AnyObject` for the created request.
   */
  public func upload(_ data: Data,
                     urlRequest: URLConvertible,
                     method: HTTPMethod,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     fileManager:FileManager? = nil,
                     requestModifier: Session.RequestModifier? = nil)
    -> Observable<UploadRequest> {
      return request { manager in
        manager.upload(data,
                       to: urlRequest,
                       method: method,
                       headers: headers,
                       interceptor: interceptor,
                       fileManager: fileManager ?? FileManager.default,
                       requestModifier: requestModifier)
      }
  }

  /**
   Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
   The request is started immediately.
   
   - parameter stream: The stream to upload.
   - parameter urlRequest: The request object to start the upload.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
   
   - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
   */
  public func upload(_ stream: InputStream,
                     urlRequest: URLRequestConvertible,
                     interceptor: RequestInterceptor? = nil,
                     fileManager:FileManager? = nil)
    -> Observable<UploadRequest> {
      return request { manager in
        manager.upload(stream,
                       with: urlRequest,
                       interceptor: interceptor,
                       fileManager: fileManager ?? FileManager.default)
      }
  }

  /**
   Returns an observable of a request using the shared manager instance to upload any stream to a specified URL.
   The request is started immediately.
   
   - parameter stream: The stream to upload.
   - parameter urlRequest: The request object to start the upload.
   - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.
   
   - returns: The observable of `(NSData?, RxProgress)` for the created upload request.
   */
  public func upload(_ stream: InputStream,
                     urlRequest: URLConvertible,
                     method: HTTPMethod,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     fileManager:FileManager? = nil,
                     requestModifier: Session.RequestModifier? = nil)
    -> Observable<UploadRequest> {
      return request { manager in
        manager.upload(stream,
                       to: urlRequest,
                       method: method,
                       headers: headers,
                       interceptor: interceptor,
                       fileManager: fileManager ?? FileManager.default,
                       requestModifier: requestModifier)
      }
  }

  // MARK: Download

  /**
   Creates a download request using the shared manager instance for the specified URL request.
   - parameter urlRequest:  The URL request.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter destination: The closure used to determine the destination of the downloaded file.
   - returns: The observable of `(NSData?, RxProgress)` for the created download request.
   */
  public func download(_ urlRequest: URLRequestConvertible,
                       interceptor: RequestInterceptor? = nil,
                       to destination: @escaping DownloadRequest.Destination) -> Observable<DownloadRequest> {
    return request { manager in
      manager.download(urlRequest,
                       interceptor: interceptor,
                       to: destination)
    }
  }

  /**
   Creates a download request using the shared manager instance for the specified URL request.
   - parameter method: `HTTPMethod` for the `URLRequest`. `.post` by default.
   - parameter urlRequest:  The URL request.
   - parameter headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
   - parameter interceptor: `RequestInterceptor` value to be used by the returned `UploadRequest`. `nil` by default.
   - parameter fileManager: `FileManager` instance to be used by the returned `UploadRequest`. `.default`
   - parameter requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided parameter parameters. `nil` by default.
   - parameter destination: The closure used to determine the destination of the downloaded file.
   - returns: The observable of `(NSData?, RxProgress)` for the created download request.
   */
  public func download(method: HTTPMethod,
                       urlRequest: URLConvertible,
                       parameters: Parameters?,
                       encoding: ParameterEncoding,
                       headers: HTTPHeaders? = nil,
                       interceptor: RequestInterceptor? = nil,
                       requestModifier: Session.RequestModifier? = nil,
                       to destination: @escaping DownloadRequest.Destination)
    -> Observable<DownloadRequest> {
      return request { manager in
        manager.download(urlRequest,
                         method: method,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers,
                         interceptor: interceptor,
                         requestModifier: requestModifier,
                         to: destination)
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
                       to destination: @escaping DownloadRequest.Destination) -> Observable<DownloadRequest> {
    return request { manager in
      manager.download(resumingWith: resumeData, to: destination)
    }
  }
}

// MARK: Request - Common Response Handlers

extension ObservableType where Element == DataRequest {
  public func responseJSON() -> Observable<DataResponse<Any, AFError>> {
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
    
  public func progress() -> Observable<RxProgress> {
    return flatMap { $0.rx.progress() }
  }
}

// MARK: Request - Validation

extension ObservableType where Element == DataRequest {
  public func validate<S: Sequence>(statusCode: S) -> Observable<Element> where S.Element == Int {
    return map { $0.validate(statusCode: statusCode) }
  }

  public func validate() -> Observable<Element> {
    return map { $0.validate() }
  }

  public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<Element> where S.Iterator.Element == String {
    return map { $0.validate(contentType: acceptableContentTypes) }
  }

  public func validate(_ validation: @escaping DataRequest.Validation) -> Observable<Element> {
    return map { $0.validate(validation) }
  }
}

extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
  // MARK: Defaults

  /// - returns: A validated request based on the status code
  func validateSuccessfulResponse() -> DataRequest {
    return base.validate(statusCode: 200..<300)
  }

  /**
   Transform a request into an observable of the response and serialized object.

   - parameter queue: The dispatch queue to use.
   - parameter responseSerializer: The the serializer.
   - returns: The observable of `(NSHTTPURLResponse, T.SerializedObject)` for the created download request.
   */
  public func responseResult<T: DataResponseSerializerProtocol>(queue: DispatchQueue = .main,
                                                                responseSerializer: T)
    -> Observable<(HTTPURLResponse, T.SerializedObject)> {
      return Observable.create { observer in
        let dataRequest = self.base
          .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
            switch packedResponse.result {
            case let .success(result):
              if let httpResponse = packedResponse.response {
                observer.on(.next((httpResponse, result)))
                observer.on(.completed)
              } else {
                observer.on(.error(RxAlamofireUnknownError))
              }
            case let .failure(error):
              observer.on(.error(error as Error))
            }
        }
        return Disposables.create {
          dataRequest.cancel()
        }
      }
  }
  
  public func responseJSON() -> Observable<DataResponse<Any, AFError>> {
    return Observable.create { observer in
      let request = self.base

      request.responseJSON { response in
        switch response.result {
        case .success:
          observer.on(.next(response))
          observer.on(.completed)
        case let .failure(error):
          observer.on(.error(error))
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
  public func result<T: DataResponseSerializerProtocol>(queue: DispatchQueue = .main,
                                                        responseSerializer: T)
    -> Observable<T.SerializedObject> {
      return Observable.create { observer in
        let dataRequest = self.validateSuccessfulResponse()
          .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
            switch packedResponse.result {
            case let .success(result):
              if let _ = packedResponse.response {
                observer.on(.next(result))
                observer.on(.completed)
              } else {
                observer.on(.error(RxAlamofireUnknownError))
              }
            case let .failure(error):
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
    return responseResult(responseSerializer: DataResponseSerializer())
  }

  public func data() -> Observable<Data> {
    return result(responseSerializer: DataResponseSerializer())
  }

  /**
   Returns an `Observable` of a String for the current request

   - parameter encoding: Type of the string encoding, **default:** `nil`

   - returns: An instance of `Observable<String>`
   */
  public func responseString(encoding: String.Encoding? = nil) -> Observable<(HTTPURLResponse, String)> {
    return responseResult(responseSerializer: StringResponseSerializer(encoding: encoding))
  }

  public func string(encoding: String.Encoding? = nil) -> Observable<String> {
    return result(responseSerializer: StringResponseSerializer(encoding: encoding))
  }

  /**
   Returns an `Observable` of a serialized JSON for the current request.

   - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

   - returns: An instance of `Observable<AnyObject>`
   */
  public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<(HTTPURLResponse, Any)> {
    return responseResult(responseSerializer: JSONResponseSerializer(options: options))
  }

  /**
   Returns an `Observable` of a serialized JSON for the current request.

   - parameter options: Reading options for JSON decoding process, **default:** `.AllowFragments`

   - returns: An instance of `Observable<AnyObject>`
   */
  public func json(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<Any> {
    return result(responseSerializer: JSONResponseSerializer(options: options))
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
    } else {
      return 0
    }
  }
}

extension RxProgress: Equatable {}

public func ==(lhs: RxProgress, rhs: RxProgress) -> Bool {
  return lhs.bytesWritten == rhs.bytesWritten &&
    lhs.totalBytes == rhs.totalBytes
}
