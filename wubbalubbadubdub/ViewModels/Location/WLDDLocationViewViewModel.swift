//
//  WLDDLocationViewViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import Foundation

final class WLDDLocationViewViewModel {
    
    private var locations: [WLDDLocation] = []
    
    private var cellViewModels: [String] = []
    
    init() {
        
    }
    
    public func fetchLocations() {
        WLDDService.shared.execute(.listLocationsRequests, expecting: String.self) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    private var hasMoreResult: Bool {
        return false
    }
}
