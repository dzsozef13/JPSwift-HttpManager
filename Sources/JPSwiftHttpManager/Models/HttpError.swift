//
//  HttpError.swift
//  Tennis Notes
//
//  Created by Jozsef Adam Punk on 17/12/2022.
//

import Foundation

public enum HttpError: Error {
    case requestCompositionError
    case requestExecutionError
    
    case connectionError
    case responseError(errorCode: Int)
    case emptyDataError
}
