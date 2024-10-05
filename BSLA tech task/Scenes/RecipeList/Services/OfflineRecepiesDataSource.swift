//
//  OfflineRecepiesDataSource.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/1/24.
//

import Foundation

protocol OfflineRecepiesDataSourceRepo {
    func fetchData() -> [UIRecepieItemModel]
    func fetchRowData() -> [RRecepieItemModel]
    func fetchBookmarked() -> [UIRecepieItemModel]
    func toggleBookmark(with id: Int) -> UIRecepieItemModel?
    func store(recepies data: [RRecepieItemModel])
    func setOfflineDataSourceOutput(output: OfflineRecepiesDataSource.Output)
}

final class OfflineRecepiesDataSource {
    // MARK: - properties
    private var output: Output?
}

// MARK: - repo logics
extension OfflineRecepiesDataSource: OfflineRecepiesDataSourceRepo {
    func fetchRowData() -> [RRecepieItemModel] {
        let recepies = RecepieDBManager.fetchRecepies()
        return convert(data: recepies)
    }
    
    func setOfflineDataSourceOutput(output: Output) {
        self.output = output
    }
    
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
        let item = UIRecepieItemModel(data: recepie)
        output?.action(.bookmarks(bookmark: item))
        return item
    }
    
    func store(recepies data: [RRecepieItemModel]) {
        guard !data.isEmpty else {return}
        RecepieDBManager.storeRecepies(data: data)
    }
}

private extension OfflineRecepiesDataSource {
    func convert(data: [RecepieEntity]) -> [UIRecepieItemModel] {
        return data.map({UIRecepieItemModel(data: $0)})
    }
    
    
    func convert(data: [RecepieEntity]) -> [RRecepieItemModel] {
        return data.map({
            .init(id: Int($0.id), title: $0.title ?? "", url: $0.imageUrl)
        })
    }
}


extension OfflineRecepiesDataSource {
    struct Output {
        let action: (Action) -> Void
    }
    
    enum Action {
        case bookmarks(bookmark: UIRecepieItemModel?)
    }
}
