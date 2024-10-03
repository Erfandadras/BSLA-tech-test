//
//  OfflineRecepiesDataSource.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/1/24.
//

import Foundation

protocol OfflineRecepiesDataSourceRepo {
    func fetchData() -> [UIRecepieItemModel]
    func fetchBookmarked() -> [UIRecepieItemModel]
    func toggleBookmark(with id: Int) -> UIRecepieItemModel?
    func store(recepies data: [RRecepieItemModel])
}

final class OfflineRecepiesDataSource {}

// MARK: - repo logics
extension OfflineRecepiesDataSource: OfflineRecepiesDataSourceRepo {
    func fetchData() -> [UIRecepieItemModel] {
        let recepies = RecepieDBManager.fetchRecepies()
        return convert(data: recepies)
    }
    
    func fetchBookmarked() -> [UIRecepieItemModel]  {
        let recepies = RecepieDBManager.fetchBookmarked()
        return convert(data: recepies)
    }
    
    func toggleBookmark(with id: Int) -> UIRecepieItemModel? {
        guard let recepie = RecepieDBManager.bookmark(id: id) else {return nil}
        return .init(data: recepie)
    }
    
    func store(recepies data: [RRecepieItemModel]) {
        RecepieDBManager.storeRecepies(data: data)
    }
}

private extension OfflineRecepiesDataSource {
    func convert(data: [RecepieEntity]) -> [UIRecepieItemModel] {
        return data.map({UIRecepieItemModel(data: $0)})
    }
}
