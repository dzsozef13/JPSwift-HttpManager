//
//  DataError.swift
//  Tennis Notes
//
//  Created by Jozsef Adam Punk on 17/12/2022.
//

import Foundation

public enum DataError: Error {
    case dataEncodingError(error: Error)
    case dataDecodingError(error: Error)
    case dataParsingError
}
