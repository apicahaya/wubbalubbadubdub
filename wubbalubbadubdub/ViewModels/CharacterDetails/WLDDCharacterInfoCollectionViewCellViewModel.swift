//
//  WLDDCharacterInfoCollectionViewCellViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import Foundation
import UIKit

final class WLDDCharacterInfoCollectionViewCellViewModel {
    
    private let type: `Type`
    
    public let value: String 
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = .current
        
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        
        return formatter
    }()

    public var title: String {
        self.type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        
        return value
    }
    
    public var iconImage: UIImage?    {
        return type.iconImage
    }
    
    public var tintcolor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case species
        case origin
        case type
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemGreen
            case .gender:
                return .systemGreen
            case .species:
                return .systemGreen
            case .origin:
                return .systemGreen
            case .type:
                return .systemGreen
            case .created:
                return .systemGreen
            case .location:
                return .systemGreen
            case .episodeCount:
                return .systemGreen
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status,
                    .gender,
                    .species,
                    .origin,
                    .created,
                    .location,
                    .episodeCount,
                    .type:
                return rawValue.uppercased()
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
