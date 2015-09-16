//
//  RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. (@bontojr) on 23/08/15.
//  Developed with the kind help of Krunoslav Zaher (@KrunoslavZaher)
//
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

// MARK: Global Functions


// MARK: Request - Common Response Handlers
extension Request {
    
    /**
    Returns an `Observable` of NSData for the current request.
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<NSData>`
    */
    func rx_response(cancelOnDispose: Bool = false) -> Observable<NSData> {
        
        return create { (observer: ObserverOf<NSData>) -> Disposable in
            
            self.response { request, response, data, error in
                if let e = error as NSError? {
                    observer.on(.Error(e))
                } else {
                    if let d = data {
                        if 200 ..< 300 ~= response?.statusCode ?? 0 {
                            observer.on(.Next(d))
                            observer.on(.Completed)
                        } else {
                            observer.on(.Error(NSError(domain: "Wrong status code, expected 200-206, got \(response?.statusCode ?? -1)", code: -1, userInfo: nil)))
                        }
                    }
                    else {
                        observer.on(.Error(error ?? NSError(domain: "Empty data received", code: -1, userInfo: nil)))
                    }
                    
                }
            }
            
            return AnonymousDisposable {
                if(cancelOnDispose) {
                    self.cancel()
                }
            }
            
        }
    }
    
    /**
    Returns an `Observable` of a String for the current request.
    - parameter encoding: Type of the string encoding, **default:** `nil`
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<String>`
    */
    func rx_responseString(encoding: NSStringEncoding? = nil, cancelOnDispose: Bool = false) -> Observable<String> {
        
        return create { (observer: ObserverOf<String>) -> Disposable in
            
            self.responseString(encoding: encoding) { request, response, result in
                switch result {
                case .Success(let v):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.on(.Next(v))
                        observer.on(.Completed)
                    } else {
                        observer.on(.Error(NSError(domain: "Wrong status code, expected 200-206, got \(response?.statusCode ?? -1)", code: -1, userInfo: nil)))
                    }
                case .Failure(_, let e):
                    observer.on(.Error(e))
                }
            }
            
            return AnonymousDisposable {
                if(cancelOnDispose) {
                    self.cancel()
                }
            }
            
        }
    }
    
    /**
    Returns an `Observable` of a deserialized JSON for the current request.
    - parameter options: Reading optinons for JSON decoding process, **default:** `.AllowFragments`
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<AnyObject>`
    */
    func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments, cancelOnDispose: Bool = false) -> Observable<AnyObject> {
        
        return create { (observer: ObserverOf<AnyObject>) -> Disposable in
            
            self.responseJSON(options: options) { request, response, result in
                switch result {
                case .Success(let v):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.on(.Next(v))
                        observer.on(.Completed)
                    } else {
                        observer.on(.Error(NSError(domain: "Wrong status code, expected 200-206, got \(response?.statusCode ?? -1)", code: -1, userInfo: nil)))
                    }
                case .Failure(_, let e):
                    observer.on(.Error(e))
                }
            }
            
            return AnonymousDisposable {
                if(cancelOnDispose) {
                    self.cancel()
                }
            }
            
        }
    }
    
    /**
    Returns an `Observable` of a deserialized property list for the current request.
    - parameter options: Property list reading options, **default:** `NSPropertyListReadOptions()`
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<AnyObject>`
    */
    func rx_responsePropertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions(), cancelOnDispose: Bool = false) -> Observable<AnyObject> {
        
        return create { (observer: ObserverOf<AnyObject>) -> Disposable in
            
            self.responsePropertyList(options: options) { request, response, result in
                switch result {
                case .Success(let v):
                    if 200 ..< 300 ~= response?.statusCode ?? 0 {
                        observer.on(.Next(v))
                        observer.on(.Completed)
                    } else {
                        observer.on(.Error(NSError(domain: "Wrong status code, expected 200-206, got \(response?.statusCode ?? -1)", code: -1, userInfo: nil)))
                    }
                case .Failure(_, let e):
                    observer.on(.Error(e))
                }
            }
            
            return AnonymousDisposable {
                if(cancelOnDispose) {
                    self.cancel()
                }
            }
            
        }
    }
}


// MARK: Requesst - Upload and Download progress

extension Request {
    
    /**
    Returns an `Observable` for the current progess status.
    
    Parameters on observed tuple:
    
    1. bytes written
    1. total bytes written
    1. total bytes expected to write.
    
    - returns: An instance of `Observable<(Int64, Int64, Int64)>`
    */
    func rx_progress() -> Observable<(Int64, Int64, Int64)> {
        
        return create { (observer: ObserverOf<(Int64, Int64, Int64)>) -> Disposable in
            
            self.progress() { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                observer.on(.Next(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite))
            }
            
            return AnonymousDisposable {}
        }

    }
}
