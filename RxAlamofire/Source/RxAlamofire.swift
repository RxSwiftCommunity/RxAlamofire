//
//  RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. on 23/08/15.
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

// MARK: Common Response Handlers

extension Request {
    
    /**
    Returns an `Observable` of NSData for the current request.
    - parameter cancelOnDispose: Indicates if the request has to be canceled when the observer is disposed, **default:** `false`
    
    - returns: An instance of `Observable<(NSURLRequest, NSHTTPURLResponse, NSData?)>`
    */
    func rx_response(cancelOnDispose: Bool = false) -> Observable<(NSURLRequest, NSHTTPURLResponse, NSData?)> {
        
        return create { (observer: ObserverOf<(NSURLRequest, NSHTTPURLResponse, NSData?)>) -> Disposable in
            
            self.response { request, response, data, error in
                if let e = error {
                    sendError(observer, e)
                } else {
                    sendNext(observer, (request!, response!, data))
                    sendCompleted(observer)
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
    
    - returns: An instance of `Observable<(NSURLRequest, NSHTTPURLResponse, String)>`
    */
    func rx_responseString(encoding: NSStringEncoding? = nil, cancelOnDispose: Bool = false) -> Observable<(NSURLRequest, NSHTTPURLResponse, String)> {
        
        return create { (observer: ObserverOf<(NSURLRequest, NSHTTPURLResponse, String)>) -> Disposable in
            
            self.responseString(encoding: encoding) { request, response, result in
                switch result {
                case .Success(let v):
                    sendNext(observer, (request!, response!, v))
                    sendCompleted(observer)
                case .Failure(_, let e):
                    sendError(observer, e)
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
    
    - returns: An instance of `Observable<(NSURLRequest, NSHTTPURLResponse, AnyObject))>`
    */
    func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments, cancelOnDispose: Bool = false) -> Observable<(NSURLRequest, NSHTTPURLResponse, AnyObject)> {
        
        return create { (observer: ObserverOf<(NSURLRequest, NSHTTPURLResponse, AnyObject)>) -> Disposable in
            
            self.responseJSON(options: options) { request, response, result in
                switch result {
                case .Success(let v):
                    sendNext(observer, (request!, response!, v))
                    sendCompleted(observer)
                case .Failure(_, let e):
                    sendError(observer, e)
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
    
    - returns: An instance of `Observable<(NSURLRequest, NSHTTPURLResponse, AnyObject))>`
    */
    func rx_responsePropertyList(options: NSPropertyListReadOptions = NSPropertyListReadOptions(), cancelOnDispose: Bool = false) -> Observable<(NSURLRequest, NSHTTPURLResponse, AnyObject)> {
        
        return create { (observer: ObserverOf<(NSURLRequest, NSHTTPURLResponse, AnyObject)>) -> Disposable in
            
            self.responsePropertyList(options: options) { request, response, result in
                switch result {
                case .Success(let v):
                    sendNext(observer, (request!, response!, v))
                    sendCompleted(observer)
                case .Failure(_, let e):
                    sendError(observer, e)
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


// MARK: Upload and Download progress

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
                sendNext(observer, (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite))
            }
            
            return AnonymousDisposable {}
        }

    }
}
