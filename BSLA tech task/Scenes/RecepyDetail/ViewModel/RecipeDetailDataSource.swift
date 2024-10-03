//
//  RecipeDetailDataSource.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/2/24.
//

import Foundation

typealias RecepieDetailDataCallback = (Result<UIRecipeDetailModel, Error>) -> Void

protocol RecipeDetailDataSourceRepo {
    func loadData(callback: @escaping RecepieDetailDataCallback)
}


final class RecipeDetailDataSource {
    private let client: NetworkClient
    private var rowData: RRecepieDetailModel?
    private var uiData: UIRecipeDetailModel?
    private let id: Int
    
    // MARK: - init
    init(id: Int, client: NetworkClient) {
        self.client = client
        self.id = id
    }
}

// MARK: - logic
extension RecipeDetailDataSource: RecipeDetailDataSourceRepo {
    func loadData(callback: @escaping RecepieDetailDataCallback) {
        let setup = NetworkSetup(route: String(format: API.Routes.recepieDetailFormat, id),
                                 method: .get)
        client.fetch(RRecepieDetailModel.self, setup: setup) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.rowData = success
                let uiData = UIRecipeDetailModel(data: success)
                self.uiData = uiData
                callback(.success(uiData))
            case .failure(let failure):
                callback(.failure(failure))
            }
        }
    }
}
