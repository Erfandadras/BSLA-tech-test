//
//  RRecepieDetailModel.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/2/24.
//

import Foundation

struct RRecepieDetailModel: Codable { // Response Recepie Detail Model
    let id: Int
    let title: String
    let beReadyIn, servings: Double
    let image: URL?
    let detail: String
    let ingredient: [RIngredientModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case beReadyIn = "readyInMinutes"
        case servings
        case image
        case detail = "summary"
        case ingredient = "extendedIngredients"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container?.decode(Int.self, forKey: .id)) ?? -1
        self.title = (try? container?.decode(String.self, forKey: .title)) ?? "unknown"
        self.beReadyIn = (try? container?.decode(Double.self, forKey: .beReadyIn)) ?? 0
        self.servings = (try? container?.decode(Double.self, forKey: .servings)) ?? 0
        if let imageStr = try? container?.decodeIfPresent(String.self, forKey: .image),
           let url = URL(string: imageStr) {
            self.image = url
        } else {
            self.image = nil
        }
        self.detail = (try? container?.decode(String.self, forKey: .detail)) ?? "no more information"
        self.ingredient =  (try? container?.decode([RIngredientModel].self, forKey: .ingredient)) ?? []
    }
}
