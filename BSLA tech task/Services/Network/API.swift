//
//  API.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

struct API {
    static let baseURL = "https://api.spoonacular.com/recipes/"
    static let apiKey = "0e60e139520d4a0ebfdeae5f45ab500c"
    
    struct Routes {
        static let recepieRoutes = API.baseURL + "complexSearch/"
        static let recepieDetailFormat = API.baseURL + "%d" + "/information"
    }
}
