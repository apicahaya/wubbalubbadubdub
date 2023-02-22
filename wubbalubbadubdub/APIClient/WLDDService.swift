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
    
    enum WLDDServiceError: Error {
        case failedCreateRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(
        _ request: WLDDRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T,
        Error>) -> Void
    ) {
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(WLDDServiceError.failedCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? WLDDServiceError.failedToGetData))
                
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - Private Methods
    
    private func request(from wlddRequest: WLDDRequest) -> URLRequest? {
        guard let url = wlddRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = wlddRequest.httpMethod
        
        return request
    }
}

