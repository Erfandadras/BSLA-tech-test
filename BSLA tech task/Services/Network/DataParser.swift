//
//  DataParser.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Alamofire
import Foundation

protocol DataParser {
    associatedtype T: Codable
    func mapData(result: Alamofire.DataResponse<Data, AFError>?, response: HTTPURLResponse, callback: @escaping ((Result<T, Error>) -> Void))
}

// MARK: - data mapper
extension DataParser {
    // MARK: - map errors
    func mapError(error: Error?, response: HTTPURLResponse, callback: @escaping ((Result<T, Error>) -> Void)) {
        if error != nil {
            Logger.log(.error, "error code \(response.statusCode)  \(error?.localizedDescription ?? "")")
            callback(.failure(CustomError(description: "error code \(response.statusCode)  \(error?.localizedDescription ?? "")")))
        } else {
            Logger.log(.error, "error code \(response.statusCode)")
            callback(.failure(CustomError(description: "error code \(response.statusCode)")))
        }
    }
    
    // MARK: - map Data
    func mapData(result: DataResponse<Data, AFError>?, response: HTTPURLResponse, callback: @escaping ((Result<T, Error>) -> Void)) {
        guard let data = result?.data else {
            self.mapError(error: result?.error, response: response, callback: callback)
            return }
        
        if response.statusCode == 204 {
            Logger.log(.error, "204 -> no data")
            callback(.failure(CustomError(description: "204 -> no data")))
        }
        
        if response.statusCode == 200 {
            var errorMessage: String = ""
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                callback(.success(result))
                return
            } catch let DecodingError.dataCorrupted(context) {
                errorMessage = "\(context)"

            } catch let DecodingError.keyNotFound(key, context) {
                errorMessage = "Key '\(key)' not found: " + context.debugDescription
                errorMessage += "\n codingPath: \(context.codingPath)"
                
            } catch let DecodingError.valueNotFound(value, context) {
                errorMessage = "value '\(value)' not found: " + context.debugDescription
                errorMessage += "\n codingPath: \(context.codingPath)"

            } catch let DecodingError.typeMismatch(type, context)  {
                errorMessage = "Type '\(type)' mismatch: " + context.debugDescription
                errorMessage += "\n codingPath: \(context.codingPath)"

            } catch {
                errorMessage = error.localizedDescription
                
            }
            callback(.failure(CustomError(description: errorMessage)))
        } else {
            mapError(error: result?.error, response: response, callback: callback)
        }
    }
    
}
