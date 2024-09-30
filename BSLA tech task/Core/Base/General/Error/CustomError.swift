//
//  CustomError.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

protocol ErrorProtocol: LocalizedError {
    var title: String? { get }
}

struct CustomError: ErrorProtocol {

    var title: String?
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    private var _description: String

    init(title: String = "Something wrong happened!",
         description: String) {
        self.title = title
        self._description = description
    }
    
}
