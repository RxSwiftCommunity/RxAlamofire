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

extension NSURLSession {
    
    /**
     Creates an observable returning a decoded JSON object as `AnyObject`.
     
     - parameter method: Alamofire method object
     - parameter URLString: An object adopting `URLStringConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the addional headers
     
     - returns: An observable of a decoded JSON object as `AnyObject`
     */
    public func rx_JSON(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil) -> Observable<AnyObject> {
            do {
                let request = try URLRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers) as NSURLRequest
                return rx_JSON(request)
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
    public func rx_response(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil) -> Observable<(NSData, NSHTTPURLResponse)> {
            do {
                let request = try URLRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers) as NSURLRequest
                return rx_response(request)
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
    public func rx_data(method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil) -> Observable<NSData> {
            do {
                return rx_data(try URLRequest(method, URLString, parameters: parameters, encoding: encoding, headers: headers))
            }
            catch let error {
                return Observable.error(error)
            }
    }
}