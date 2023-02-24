//
//  WLDDServices.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import Foundation

final class WLDDService {
    static let shared = WLDDService()
    
    private let cacheManager = WLDDAPICacheManager()
    
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
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return 
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(WLDDServiceError.failedCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? WLDDServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
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

