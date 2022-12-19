//
//  PDFParser.swift
//  Tennis Notes
//
//  Created by Jozsef Adam Punk on 17/12/2022.
//

import Foundation

class PDFParser {
    func parse<T: Decodable>(data: Data, toType: T.Type) throws -> T {
        if let pdfData = data as? T {
            return pdfData
        } else {
            throw DataError.dataParsingError
        }
    }
}
