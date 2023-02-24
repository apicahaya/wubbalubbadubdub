//
//  WLDDGetAllEpisodesResponse.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import Foundation

struct WLDDGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    } 
    
    let info: Info
    let results: [WLDDEpisode]
}
