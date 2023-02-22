//
//  WLDDRequest.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import Foundation

final class WLDDRequest {
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    private let endpoint: WLDDEndPoint
    
    private let pathComponents: [String]
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    // MARK: - Public
    
    init(
        endpoint: WLDDEndPoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
}

// MARK: - Extensions
extension WLDDRequest {
    static let listCharacterRequests = WLDDRequest(endpoint: .character)
}
