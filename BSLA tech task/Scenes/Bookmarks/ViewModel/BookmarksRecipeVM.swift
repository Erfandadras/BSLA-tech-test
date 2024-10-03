//
//  BookmarksRecipeVM.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/3/24.
//

import Combine

final class BookmarksRecipeVM: ObservableObject {
    // MARK: - dependencies
    private let dataSource: BookmarksRecipeDataSourceRepo
    
    // MARK: - properties
    @Published var data = [UIRecepieItemModel]()
    
    // MARK: - init
    init(dataSource: BookmarksRecipeDataSourceRepo) {
        self.dataSource = dataSource
    }
}

// MARK: - logic
extension BookmarksRecipeVM {
    func getData() {
        self.data = dataSource.loadAllData()
    }
    
    func bookmark(recepie id: Int) {
        dataSource.bookmark(recepie: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let error):
                //TODO: - handle error
                Logger.log(.error, error.localizedDescription)
            }
        }
    }
}
