//
//  GetCharactersResponse.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import Foundation

struct WLDDGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    } 
    
    let info: Info
    let results: [WLDDCharacter]
}

