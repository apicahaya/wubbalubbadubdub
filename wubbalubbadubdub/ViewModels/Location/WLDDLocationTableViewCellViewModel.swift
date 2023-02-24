//
//  WLDDLocationTableViewCellViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import Foundation

struct WLDDLocationTableViewCellViewModel: Hashable, Equatable {
    
    
    private let location: WLDDLocation
    
    init(location: WLDDLocation) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    static func == (lhs: WLDDLocationTableViewCellViewModel, rhs: WLDDLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
        
    }
}
