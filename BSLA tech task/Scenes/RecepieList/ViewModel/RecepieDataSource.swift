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
    func bookmark(recepie id: Int, callback: @escaping RecepieDataCallback)
    
//    func fetchRecepie
}


final class RecepieDataSource {
    // MARK: - properties
    private let client: NetworkClient
    private var rowData: RRecepieDataModel?
    private var uiData: [UIRecepieItemModel] = []
    private let offlineDataSource: OfflineRecepiesDataSourceRepo
    private let reachability = NetworkReachability.shared
    
    // MARK: - init
    init(client: NetworkClient, offlineDataSource: OfflineRecepiesDataSourceRepo) {
        self.client = client
        self.offlineDataSource = offlineDataSource
        NotificationCenter.default.addObserver(self, selector: #selector(reachableNotification), name: .networkReachable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notReachableNotification), name: .networkNotReachable, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - repository logics
extension RecepieDataSource: RecepieDataSourceRepo {
    func loadAllData(callback: @escaping RecepieDataCallback) {
        if reachability.isReachableOnCellular {
            let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                     params: RecepieQueryModel(query: ""),
                                     method: .get)
            sendRequest(with: setup) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.offlineDataSource.store(recepies: self.rowData?.data ?? [])
                    callback(.success(success))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        } else {
            let data = offlineDataSource.fetchData()
            self.uiData = data
            callback(.success(data))
        }
    }
    
    func filterData(with keyword: String) -> [UIRecepieItemModel] {
        guard let data = rowData else { return []}
        let filterData = data.data.filter({$0.title.lowercased().contains(keyword.lowercased())})
        let uiData = self.convertData(data: filterData)
        self.uiData = uiData
        return uiData
    }
    
    func search(with keyword: String, callback: @escaping RecepieDataCallback) {
        if reachability.isReachableOnCellular {
            let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                     params: RecepieQueryModel(query: keyword.lowercased()),
                                     method: .get)
            sendRequest(with: setup, callback: callback)
        } else {
            callback(.success(uiData))
        }
    }
    
    func bookmark(recepie id: Int, callback: @escaping RecepieDataCallback) {
        var uiData = offlineDataSource.toggleBookmark(with: id)
        if uiData == nil {
            var previousData = self.uiData.first(where: {$0.id == id})
            previousData?.toggleBookmark()
            uiData = previousData
        }
        guard let newData = uiData else { return }
        self.uiData.replaceOrAppend(newData, firstMatchingKeyPath: \.id)
        callback(.success(self.uiData))
    }
}

// MARK: - private logics
private extension RecepieDataSource {
    func convertData(data: RRecepieDataModel) -> [UIRecepieItemModel] {
        let bookmarked = offlineDataSource.fetchBookmarked()
        return data.data.compactMap({
            var data = UIRecepieItemModel(data: $0)
            data.bookmark = bookmarked.contains(where: {$0.id == data.id})
            return data
        })
    }
    
    func convertData(data: [RRecepieItemModel]) -> [UIRecepieItemModel] {
        let bookmarked = offlineDataSource.fetchBookmarked()
        return data.compactMap({
            var data = UIRecepieItemModel(data: $0)
            data.bookmark = bookmarked.contains(where: {$0.id == data.id})
            return data
        })
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
    
    @objc private func reachableNotification() {
        guard reachability.isReachableOnCellular, rowData == nil else { return }
        self.loadAllData { _ in }
    }
    
    @objc private func notReachableNotification() {
        guard reachability.isReachableOnCellular, rowData == nil else { return }
        self.loadAllData { _ in }
    }
}
