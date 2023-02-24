//
//  WLDDEndPoint.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import Foundation

@frozen enum WLDDEndPoint: String, CaseIterable, Hashable {
    case character = "character"
    case location = "location"
    case episode = "episode"
}
