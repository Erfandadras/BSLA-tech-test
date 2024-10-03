//
//  UIRecipeDetailModel.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/2/24.
//

import Foundation


struct UIRecipeDetailModel {
    let id: Int
    let name: String
    let beReadyIn: String
    let serving: String
    let image: URL?
    let detail: String
    let ingredients: [UIRecipeIngredientModel]
    
    // MARK: - init
    init(id: Int, name: String, beReadyIn: String, serving: String, image: URL?, detail: String, ingredients: [UIRecipeIngredientModel] = []) {
        self.id = id
        self.name = name
        self.beReadyIn = beReadyIn
        self.serving = serving
        self.image = image
        self.detail = detail
        self.ingredients = ingredients
    }
    
    // MARK: - init from row data
    init(data: RRecepieDetailModel) {
        self.id = data.id
        self.name = data.title
        self.beReadyIn = "\(Int(data.beReadyIn)) Minutes"
        self.serving = "\(Int(data.servings)) servings"
        self.image = data.image
        self.detail = data.detail
        self.ingredients = data.ingredient.map({UIRecipeIngredientModel(data: $0)})
    }
}

struct UIRecipeIngredientModel: Identifiable {
    let id: Int
    let name: String
    
    // MARK: - init
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: - init from row data
    init(data: RIngredientModel) {
        self.id = data.id
        self.name = data.original
    }
}
