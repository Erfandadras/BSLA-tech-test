//
//  Encodable+dictionary.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Foundation

extension Encodable {
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [],
                                                debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
    
    func toStringJson(_ encoder: JSONEncoder = JSONEncoder()) throws -> String? {
        encoder.outputFormatting = .withoutEscapingSlashes
        let data = try encoder.encode(self)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
            return jsonString
        }
        return nil
    }
    
}
