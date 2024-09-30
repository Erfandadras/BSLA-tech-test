//
//  RecepieListNetworkClient.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation
import Alamofire


final class RecepieListNetworkClient: NetworkClient, DataParser {
    typealias T = [RRecepieModel]
    private let header: HTTPHeaders = [
        "Content-Type": "application/json",
        "x-api-key": API.apiKey
    ]
    // MARK: - logics
    func fetch<T: Codable>(_ dump : T.Type, callback: @escaping ((Result<T, any Error>) -> Void)) {
        let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                 params: RecepieQueryModel(query: ""),
                                 method: .get, headers: header)
        
    }
    
    private func parseData(data: Any,
                   callback: @escaping ((Result<[RRecepieModel], Error>) -> Void)) {
        let decoder = JSONDecoder()
        if let jsonData = try? JSONSerialization.data(withJSONObject: data),
           let response = try? decoder.decode([RRecepieModel].self, from: jsonData) {
            callback(.success(response))
        }
        callback(.failure(CustomError(description: "Failed to fetch data")))
    }
}

// MARK: - mock
//TODO: - remove on production
//class RecepieListNetworkClient: NetworkClient, DataParser {
//    func fetch<T>(_ dump: T.Type, callback: @escaping ((Result<T, any Error>) -> Void)) where T : Decodable, T : Encodable {
//        if let url = Bundle.main.url(forResource: "chats", withExtension: "json"),
//           let jsonFile = try? Data(contentsOf: url),
//           let jsonObject = try? JSONSerialization.jsonObject(with: jsonFile, options: []) {
//            parseData(data: jsonObject) { result in
//                switch result {
//                case .success(let success):
//                    if let data = success as? T {
//                        callback(.success(data))
//                    } else {
//                        callback(.failure(FirebaseClientError.typeError))
//                    }
//                case .failure(let failure):
//                    print(failure)
//                    callback(.failure(failure))
//                }
//            }
//        }
//    }
//    
//    
//    func parseData(data: Any,
//                   callback: @escaping ((Result<[RMChat], Error>) -> Void)) {
//        guard let dictionary = data as? Dictionary<String, Any> else {
//            callback(.success([]))
//            return
//        }
//        let decoder = JSONDecoder()
//        let carsArray = dictionary.compactMap { (key, value) -> RMChat? in
//            if let dictionary = value as? [String: Any],
//               let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
//               var chat = try? decoder.decode(RMChat.self, from: jsonData) {
//                chat.id = key
//                return chat
//            }
//            return nil
//        }
//        callback(.success(carsArray))
//    }
//}
    
