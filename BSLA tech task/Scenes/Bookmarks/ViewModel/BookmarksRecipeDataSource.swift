//
//  BookmarksRecipeDataSource.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/3/24.
//

import Foundation

protocol BookmarksRecipeDataSourceRepo {
    func loadAllData() -> [UIRecepieItemModel]
    func bookmark(recepie id: Int, callback: @escaping RecepieDataCallback)
}

final class BookmarksRecipeDataSource {
    // MARK: - properties
    private var data: [UIRecepieItemModel] = []
    private let offlineDataSource: OfflineRecepiesDataSourceRepo
    
    // MARK: - init
    init(offlineDataSource: OfflineRecepiesDataSourceRepo) {
        self.offlineDataSource = offlineDataSource
    }
}

extension BookmarksRecipeDataSource: BookmarksRecipeDataSourceRepo {
    func loadAllData() -> [UIRecepieItemModel] {
        let uidata = offlineDataSource.fetchBookmarked()
        self.data = uidata
        return data
    }
    
    func bookmark(recepie id: Int, callback: @escaping RecepieDataCallback) {
        _ = offlineDataSource.toggleBookmark(with: id)
        self.data.removeAll(where: {$0.id == id})
        callback(.success(self.data))
    }
}
