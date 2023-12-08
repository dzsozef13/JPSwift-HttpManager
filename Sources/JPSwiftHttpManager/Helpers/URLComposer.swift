//
//  URLComposet.swift
//  Tennis Notes
//
//  Created by Jozsef Adam Punk on 16/12/2022.
//

import Foundation

class URLComposer {
    public func compose(
        apiTransferProtocol: String,
        apiNamespace: String,
        apiUrl: String,
        endpoint: String,
        parameters: [String]?,
        query: [String: String]?
    ) -> String {
        var url = "\(apiTransferProtocol)://\(apiUrl)/\(apiNamespace)/\(endpoint)"
        if let parameters = parameters {
            for parameter in parameters {
                url += "/\(parameter)"
            }
        }
        if let query = query,
           query.count > 0 {
            url += "?"
            for (key, value) in query {
                url += "\(key)=\(value)&"
            }
            url.remove(at: url.index(before: url.endIndex))
        }
        return url
    }
}
