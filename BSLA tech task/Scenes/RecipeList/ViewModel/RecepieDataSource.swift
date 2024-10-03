//
//  RecepieDataSource.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

typealias RecepieDataCallback = (Result<[UIRecepieItemModel], Error>) -> Void
typealias SuccessCallback = (Bool) -> Void
typealias Action = () -> Void

protocol RecepieDataSourceRepo {
    func loadAllData(callback: @escaping Action)
    func search(with keyword: String, callback: @escaping SuccessCallback)
    func filterData(with keyword: String) -> [UIRecepieItemModel]
    func bookmark(recepie id: Int)
    
//    func fetchRecepie
}

protocol RecepieDataSourceDelegate: AnyObject {
    func uiDataUpdated(data: [UIRecepieItemModel])
    func handleDataSourceError(error: Error)
}

final class RecepieDataSource {
    // MARK: - properties
    private let client: NetworkClient
    private var rowData: RRecepieDataModel?
    private var uiData: [UIRecepieItemModel] = []
    private let offlineDataSource: OfflineRecepiesDataSourceRepo
    private let reachability: NetworkReachabilityRepo
    weak var delegate: RecepieDataSourceDelegate?
    
    // MARK: - init
    init(client: NetworkClient,
         offlineDataSource: OfflineRecepiesDataSourceRepo,
         reachability: NetworkReachabilityRepo = NetworkReachability.shared) {
        self.client = client
        self.offlineDataSource = offlineDataSource
        self.reachability = reachability
        
        offlineDataSource.setOfflineDataSourceOutput(output: .init(action: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .bookmarks(bookmark: let item):
                if let newData = item {
                    self.uiData.replaceOrAppend(newData, firstMatchingKeyPath: \.id)
                }
            }
        }))
        NotificationCenter.default.addObserver(self, selector: #selector(reachableNotification), name: .networkReachable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notReachableNotification), name: .networkNotReachable, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - repository logics
extension RecepieDataSource: RecepieDataSourceRepo {
    func loadAllData(callback: @escaping Action) {
        if reachability.isReachableOnCellular {
            let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                     params: RecepieQueryModel(query: ""),
                                     method: .get)
            sendRequest(with: setup) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.offlineDataSource.store(recepies: self.rowData?.data ?? [])
                    self.delegate?.uiDataUpdated(data: success)
                    callback()
                case .failure(let error):
                    callback()
                    self.delegate?.handleDataSourceError(error: error)
                }
            }
        } else {
            let data = offlineDataSource.fetchData()
            self.uiData = data
            self.delegate?.uiDataUpdated(data: data)
            callback()
        }
    }
    
    func filterData(with keyword: String) -> [UIRecepieItemModel]{
        guard let data = rowData else { return []}
        let filterData = data.data.filter({$0.title.lowercased().contains(keyword.lowercased())})
        let uiData = self.convertData(data: filterData)
        return uiData
    }
    
    func search(with keyword: String, callback: @escaping SuccessCallback) {
        if reachability.isReachableOnCellular {
            let setup = NetworkSetup(route: API.Routes.recepieRoutes,
                                     params: RecepieQueryModel(query: keyword.lowercased()),
                                     method: .get)
            sendRequest(with: setup) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.delegate?.uiDataUpdated(data: success)
                    callback(true)
                case .failure(let error):
                    Logger.log(.error, error.localizedDescription)
                    callback(false)
                    self.delegate?.handleDataSourceError(error: error)
                }
            }
        } else {
            self.delegate?.uiDataUpdated(data: uiData)
            callback(true)
        }
    }
    
    func bookmark(recepie id: Int) {
        var uiData = offlineDataSource.toggleBookmark(with: id)
        if uiData == nil {
            var previousData = self.uiData.first(where: {$0.id == id})
            previousData?.toggleBookmark()
            uiData = previousData
        }
        guard let newData = uiData else { return }
        self.uiData.replaceOrAppend(newData, firstMatchingKeyPath: \.id)
        self.delegate?.uiDataUpdated(data: self.uiData)
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
        self.loadAllData {}
    }
    
    @objc private func notReachableNotification() {
        guard reachability.isReachableOnCellular, rowData == nil else { return }
        self.loadAllData {}
    }
}
