//
//  HttpManager.swift
//  HttpManager
//
//  Created by Jozsef Adam Punk on 01/12/2022.
//

import Foundation
import UIKit

public class HttpManager {
    
    private let apiTransferProtocol: String
    private let apiNamespace: String
    private let apiUrl: String
    
    init(apiTransferProtocol: String,
         apiNamespace: String,
         apiUrl: String) {
        self.apiTransferProtocol = apiTransferProtocol
        self.apiNamespace = apiNamespace
        self.apiUrl = apiUrl
    }
    
    // MARK: Request Handling
    public func send<T>(requestType: HttpRequestType,
                        returnType: T.Type,
                        contentType: HttpContentType = .json,
                        endpoint: String,
                        parameters: [String]? = nil,
                        query: [String: String]? = nil,
                        completionHandler: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        // Compose request
        if var request = composeRequest(endpoint: endpoint, parameters: parameters, query: query) {
            // Set content type
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
            // Execute request
            execute(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        var parsedData: T
                        switch contentType {
                        case .json:
                            parsedData = try JSONParser().parse(data: data, toType: T.self)
                        case .pdf:
                            parsedData = try PDFParser().parse(data: data, toType: T.self)
                        }
                        
                        // Escape with successfully parsed data
                        completionHandler(.success(parsedData))
                        return
                        
                    } catch {
                        completionHandler(.failure(DataError.dataParsingError))
                        return
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                    return
                }
            }
        } else {
            print("Failed to compose request for return type \(returnType).")
            completionHandler(.failure(HttpError.requestCompositionError))
            return
        }
    }

    // MARK: Request Execution
    private func execute(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error  in
            if let response = response as? HTTPURLResponse {
                if let error = error {
                    print("Request error: \(error.localizedDescription).")
                    completionHandler(.failure(HttpError.requestExecutionError))
                    return
                }
                if let data = data {
                    let statusCode = response.statusCode
                    guard (200...299).contains(statusCode) else {
                        print("Responded with error status code: \(statusCode).")
                        completionHandler(.failure(HttpError.responseError(errorCode: statusCode)))
                        return
                    }
                    
                    // Escape with data from response
                    completionHandler(.success(data))
                    return
                    
                } else {
                    print("Empty data in response.")
                    completionHandler(.failure(HttpError.emptyDataError))
                    return
                }
            } else {
                print("No response.")
                completionHandler(.failure(HttpError.connectionError))
                return
            }
        }
        task.resume()
    }
    
    // MARK: Request Composer
    private func composeRequest(endpoint: String,
                                parameters: [String]?,
                                query: [String: String]?) -> URLRequest? {
        let urlString = URLComposer().compose(apiTransferProtocol: apiTransferProtocol,
                                              apiNamespace: apiNamespace,
                                              apiUrl: apiUrl,
                                              endpoint: endpoint,
                                              parameters: parameters,
                                              query: query)
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
}
