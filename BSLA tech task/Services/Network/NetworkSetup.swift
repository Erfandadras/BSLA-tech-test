//
//  NetworkSetup.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Alamofire

struct NetworkSetup {
    
    var route: String!
    var params: Codable?
    var method: HTTPMethod = .post
    var encoding: ParameterEncoding = JSONEncoding.default
    var body: Data?
    var headers: HTTPHeaders = [
        "Content-Type": "application/json",
    ]
    
    init(route: String,
         params: Codable? = nil,
         method: HTTPMethod = .post,
         body: Data? = nil,
         encoding: ParameterEncoding = JSONEncoding.default,
         headers: HTTPHeaders = ["Content-Type": "application/json",]) {
             self.route = route
             self.params = params
             self.method = method
             self.encoding = encoding
             self.body = body
             
             for (key, val) in headers.dictionary {
                 self.headers.update(name: key, value: val)
             }
         }
    
    func asUrlRequest() throws -> URLRequest {
        let url = try route.asURL()
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = body
        if let parametrs = try? params?.toDictionary() {
            request = try URLEncoding.default.encode(request, with: parametrs)
        }
        return request
    }
}
