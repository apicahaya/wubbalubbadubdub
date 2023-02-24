//
//  WLDDAPICacheManager.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import Foundation

final class WLDDAPICacheManager {
    
    private var cacheDictionary: [
        String: NSCache<NSString, NSData>
    ] = [:]
    
    private var cache = NSCache<NSString, NSData>()
    
    init() {
        setupCache()
    }
    
    // MARK: - Public Func
    
    public func cachedResponse(for endpoint: WLDDEndPoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint.rawValue], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: WLDDEndPoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint.rawValue], let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    
    // MARK: - Private Func
    private func setupCache() {
        WLDDEndPoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint.rawValue] = NSCache<NSString, NSData>()
        })
    }
    
}
