//
//  RecepieListNetworkClient.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation
import Alamofire


final class RecepieListNetworkClient: NetworkClient, DataParser {
    typealias T = RRecepieDataModel
    private let header: HTTPHeaders = [
        "Content-Type": "application/json",
        "x-api-key": API.apiKey
    ]
    // MARK: - logics
    func fetch<T: Codable>(_ dump : T.Type, setup: NetworkSetup, callback: @escaping ((Result<T, any Error>) -> Void)) {
        var newSetup = setup
        newSetup.headers = header
        NetworkService<RRecepieDataModel>.fetch(self, setup: newSetup) { result in
            switch result {
            case .success(let success):
                if let data = success as? T {
                    callback(.success(data))
                } else {
                    callback(.failure(NetworkClientError.typeError))
                }
            case .failure(let failure):
                callback(.failure(failure))
            }
        }
    }
}

// MARK: - mock
final class MockRecepieListNetworkClient: NetworkClient {
    func fetch<T>(_ dump: T.Type, setup: NetworkSetup, callback: @escaping ((Result<T, any Error>) -> Void)) where T : Decodable, T : Encodable {
        if let url = Bundle.main.url(forResource: "RecepieListJsonData", withExtension: "json"),
           let jsonFile = try? Data(contentsOf: url),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonFile, options: []) {
            parseData(data: jsonObject, query: (setup.params as? RecepieQueryModel)?.query) { result in
                switch result {
                case .success(let success):
                    if let data = success as? T {
                        callback(.success(data))
                    } else {
                        callback(.failure(NetworkClientError.typeError))
                    }
                case .failure(let failure):
                    print(failure)
                    callback(.failure(failure))
                }
            }
        }
    }
    
    
    private func parseData(data: Any,
                           query: String?,
                           callback: @escaping ((Result<RRecepieDataModel, Error>) -> Void)) {
        let decoder = JSONDecoder()
        if let jsonData = try? JSONSerialization.data(withJSONObject: data),
           let response = try? decoder.decode(RRecepieDataModel.self, from: jsonData) {
            if let query = query {
                let filterData = response.data.filter({$0.title.lowercased().contains(query)})
                if filterData.isEmpty {
                    callback(.failure(CustomError(description: "not found")))
                } else {
                    callback(.success(.init(data: filterData)))
                }
            } else {
                callback(.success(response))
            }
        } else {
            callback(.failure(CustomError(description: "Failed to fetch data")))            
        }
    }
}
    
