//
//  RRecepieModel.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

struct RRecepieItemModel: Codable { // response recepie item model
    let id: Int
    let title: String
    let image: URL?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey  {
        case id, title, image
    }
    
    // MARK: - init from decoder
    init(from decoder: any Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container?.decode(Int.self, forKey: .id)) ?? -1
        self.title = (try? container?.decode(String.self, forKey: .title)) ?? "unknown"
        if let imageStr = try? container?.decodeIfPresent(String.self, forKey: .image),
           let url = URL(string: imageStr) {
            self.image = url
        } else {
            self.image = nil
        }
    }
    
    // MARK: - for sample initialize
    init(id: Int, title: String, url: URL?) {
        self.id = id
        self.title = title
        self.image = url
    }
}

// MARK: - result data
struct RRecepieDataModel: Codable {
    let data: [RRecepieItemModel]
    
    enum CodingKeys: String, CodingKey  {
        case data = "results"
    }
}

