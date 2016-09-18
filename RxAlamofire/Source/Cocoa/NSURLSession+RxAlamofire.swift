//
//  NSURLSession+RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. on 04/11/15.
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

// MARK: NSURLSession extensions

extension Reactive where Base: URLSession {
    
    /**
     Creates an observable returning a decoded JSON object as `AnyObject`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLStringConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of a decoded JSON object as `AnyObject`
     */
    public func JSON(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil) -> Observable<AnyObject> {
            do {
                let request = try RxAlamofire.URLRequest(method,
                                                         URLString,
                                                         parameters: parameters,
                                                         encoding: encoding,
                                                         headers: headers)
                return JSON(request)
            }
            catch let error {
                return Observable.error(error)
            }
    }

    /**
     Creates an observable returning a tuple of `(NSData!, NSURLResponse)`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLStringConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of a tuple containing data and the request
     */
    public func response(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil) -> Observable<(Data, HTTPURLResponse)> {
            do {
                let request = try RxAlamofire.URLRequest(method,
                                                         URLString,
                                                         parameters: parameters,
                                                         encoding: encoding,
                                                         headers: headers)
                return response(request)
            }
            catch let error {
                return Observable.error(error)
            }
    }

    /**
     Creates an observable of response's content as `NSData`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLStringConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of a data
     */
    public func data(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil) -> Observable<Data> {
            do {
                let request = try RxAlamofire.URLRequest(method,
                                                         URLString,
                                                         parameters: parameters,
                                                         encoding: encoding,
                                                         headers: headers)
                return data(request)
            }
            catch let error {
                return Observable.error(error)
            }
    }
}
