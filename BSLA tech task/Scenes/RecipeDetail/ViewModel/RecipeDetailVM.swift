//
//  RecipeDetailVM.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/2/24.
//

import Combine

final class RecipeDetailVM: ObservableObject {
    // MARK: - properties
    @Published var recepie: UIRecipeDetailModel?
    @Published var error: Error?
    private let dataSource: RecipeDetailDataSourceRepo
    
    // MARK: - init
    init(dataSource: RecipeDetailDataSourceRepo) {
        self.dataSource = dataSource
        self._error = .init(initialValue: nil)
        self._recepie = .init(initialValue: nil)
    }
    
    func loadData() {
        dataSource.loadData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                self.recepie = success
                
            case .failure(let error):
                self.error = error
            }
        }
    }
}
