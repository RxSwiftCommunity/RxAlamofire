#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
  import Foundation

  import Alamofire
  import RxCocoa
  import RxSwift

  // MARK: NSURLSession extensions

  extension Reactive where Base: URLSession {
    /**
     Creates an observable returning a decoded JSON object as `AnyObject`.

     - parameter method: Alamofire method object
     - parameter url: An object adopting `URLConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of a decoded JSON object as `AnyObject`
     */
    public func json(_ method: Alamofire.HTTPMethod,
                     _ url: URLConvertible,
                     parameters: [String: Any]? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil) -> Observable<Any> {
      do {
        let request = try urlRequest(method,
                                     url,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
        return json(request: request)
      } catch {
        return Observable.error(error)
      }
    }

    /**
     Creates an observable returning a tuple of `(NSData!, NSURLResponse)`.

     - parameter method: Alamofire method object
     - parameter url: An object adopting `URLConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of a tuple containing data and the request
     */
    public func response(method: Alamofire.HTTPMethod,
                         _ url: URLConvertible,
                         parameters: [String: Any]? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         headers: HTTPHeaders? = nil) -> Observable<(response: HTTPURLResponse, data: Data)> {
      do {
        let request = try urlRequest(method,
                                     url,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
        return response(request: request)
      } catch {
        return Observable.error(error)
      }
    }

    /**
     Creates an observable of response's content as `NSData`.

     - parameter method: Alamofire method object
     - parameter url: An object adopting `URLConvertible`
     - parameter parameters: A dictionary containing all necessary options
     - parameter encoding: The kind of encoding used to process parameters
     - parameter header: A dictionary containing all the additional headers

     - returns: An observable of a data
     */
    public func data(_ method: Alamofire.HTTPMethod,
                     _ url: URLConvertible,
                     parameters: [String: AnyObject]? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil) -> Observable<Data> {
      do {
        let request = try urlRequest(method,
                                     url,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
        return data(request: request)
      } catch {
        return Observable.error(error)
      }
    }
  }
#endif
