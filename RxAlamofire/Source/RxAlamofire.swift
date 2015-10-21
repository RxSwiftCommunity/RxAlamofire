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