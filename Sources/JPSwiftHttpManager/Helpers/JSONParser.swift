//
//  JSONParser.swift
//  Tennis Notes
//
//  Created by Jozsef Adam Punk on 16/12/2022.
//

import Foundation

class JSONParser {
    public func parse<T: Decodable>(data: Data, toType: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            let parsedData = try decoder.decode(toType, from: data)
            return parsedData
        } catch let error {
            throw DataError.dataDecodingError(error: error)
        }
    }
}
