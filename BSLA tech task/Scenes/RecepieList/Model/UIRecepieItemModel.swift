//
//  UIRecepieItemModel.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

struct UIRecepieItemModel: Identifiable {
    let id: Int
    let imageURL: URL?
    let name: String
    let description: String
    var bookmark: Bool = false
    
    // MARK: - default init
    init(id: Int, name: String, description: String, bookmarked: Bool = false, imageURL: URL? = URL(string: "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg")) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.bookmark = bookmarked
    }
    
    // MARK: - init with row data
    init(data: RRecepieItemModel) {
        self.id = data.id
        self.name = data.title
        self.description = data.title + "\n" + data.title
        self.imageURL = data.image
    }
    
    // MARK: - mutating
    mutating func toggleBookmark() {
        bookmark.toggle()
    }
}
