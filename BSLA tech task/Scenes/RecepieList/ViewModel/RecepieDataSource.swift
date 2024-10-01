//
//  RecepieDataSource.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

typealias RecepieDataCallback = (Result<[UIRecepieItemModel], Error>) -> Void
protocol RecepieDataSourceRepo {
    func loadAllData(callback: @escaping RecepieDataCallback)
    func search(with keyword: String, callback: @escaping RecepieDataCallback)
    func filterData(with keyword: String) -> [UIRecepieItemModel]
}


final class RecepieDataSource {
    // MARK: - properties
    private let client: NetworkClient
    private var rowData: RRecepieDataModel?
    private var uiData: [UIRecepieItemModel] = []
    
    // MARK: - init
    init(client: NetworkClient) {
        self.client = client
    }
}

// MARK: - repository logics
extension RecepieDataSource: RecepieDataSourceRepo {
    func loadAllData(callback: @escaping RecepieDataCallback) {
        let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                 params: RecepieQueryModel(query: ""),
                                 method: .get)
        sendRequest(with: setup, callback: callback)
    }
    
    func filterData(with keyword: String) -> [UIRecepieItemModel] {
        guard let data = rowData else { return []}
        let filterData = data.data.filter({$0.title.lowercased().contains(keyword.lowercased())})
        return self.convertData(data: filterData)
    }
    
    func search(with keyword: String, callback: @escaping RecepieDataCallback) {
        let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                 params: RecepieQueryModel(query: keyword.lowercased()),
                                 method: .get)
        sendRequest(with: setup, callback: callback)
    }
}

// MARK: - private logics
private extension RecepieDataSource {
    func convertData(data: RRecepieDataModel) -> [UIRecepieItemModel] {
        return data.data.compactMap({UIRecepieItemModel(data: $0)})
    }
    
    func convertData(data: [RRecepieItemModel]) -> [UIRecepieItemModel] {
        return data.compactMap({UIRecepieItemModel(data: $0)})
    }
    
    private func sendRequest(with setup: NetworkSetup, callback: @escaping RecepieDataCallback) {
        client.fetch(RRecepieDataModel.self, setup: setup) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.rowData = success
                let uiData = self.convertData(data: success)
                self.uiData = uiData
                callback(.success(uiData))
            case .failure(let failure):
                callback(.failure(failure))
            }
        }
    }
}
