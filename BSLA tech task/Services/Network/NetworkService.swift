//
//  NetworkService.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation
import Alamofire

final class NetworkService<T: Codable>: NSObject {
    private static var interceptor: Interceptor {
        return .init()
    }
    
    private static var sessionManager: Session {
        let temp = Alamofire.Session.default
        return temp
    }
    
    private static var isConnectedToTheInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

// MARK: - Static Methods
extension NetworkService {
    // MARK: - Cancel all request in session
    static func cancelAllRequest() {
        Alamofire.Session.default.cancelAllRequests()
    }
}

// MARK: - use mapper with Generic model confirms DataParser
extension NetworkService {
    static func fetch<T: DataParser>(_ dump: T, setup: NetworkSetup,
                                         callback: @escaping (Result<T.T, Error>) -> Void) {
        guard isConnectedToTheInternet else {
            let error = CustomError(description: "Device is not connected to the internet, Try again later!")
            callback(.failure(error))
            return
        }
        var url: URLRequest
        do {
            url = try setup.asUrlRequest()
        } catch let error {
            callback(.failure(CustomError(description: error.localizedDescription)))
            return
        }
        
        let validationRange = [200...400, 402...500].joined()
        
        sessionManager.request(url)
            .validate(statusCode: validationRange)
            .responseString(completionHandler: { response in
                Logger.log(.warning, response)
            })
            .responseData { response in
                Logger.log(.warning, response.response?.headers)
                guard let httpResponse = response.response else {
                    callback(.failure(CustomError(description: "No Http response")))
                    return}
                dump.mapData(result: response, response: httpResponse, callback: callback)
            }
    }
}
