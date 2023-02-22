//
//  WLDDServices.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import Foundation

final class WLDDService {
    static let shared = WLDDService()
    
    private init() {}
    
    public func execute<T: Codable>(
        _ request: WLDDRequest,
        expecting type: T.Type,
        completion: @escaping (Result<String,
        Error>) -> Void
    ) {
        
    }
}
