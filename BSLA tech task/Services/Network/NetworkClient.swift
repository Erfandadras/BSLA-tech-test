//
//  NetworkClient.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

protocol NetworkClient {
    func fetch<T: Codable>(_ dump : T.Type, callback: @escaping ((Result<T, any Error>) -> Void))
}
