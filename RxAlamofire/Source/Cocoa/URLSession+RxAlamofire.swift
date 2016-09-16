//
//  URLSession+RxAlamofire.swift
//  RxAlamofire
//
//  Created by Junior B. on 04/11/15.
//  Copyright © 2015 Bonto.ch. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

// MARK: URLSession extensions

extension URLSession {
    
    /**
     Creates an observable returning a decoded JSON object as `Any`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLStringConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of a decoded JSON object as `Any`
     */
    public func rx_JSON(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil) -> Observable<Any> {
            do {
                let request = try urlRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers) as URLRequest
                return rx.JSON(request).map({ (o) -> Any in o })
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
    public func rx_response(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil) -> Observable<(Data, HTTPURLResponse)> {
            do {
                let request = try urlRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers) as URLRequest
                return rx.response(request)
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
    public func rx_data(_ method: Alamofire.HTTPMethod,
        _ URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil) -> Observable<Data> {
            do {
                return rx.data(try urlRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers))
            }
            catch let error {
                return Observable.error(error)
            }
    }
}
