//
//  WLDDCharacter.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import Foundation

struct WLDDCharacter: Codable {
    let id: Int
    let name: String
    let status: WLDDCharacterStatus
    let species: String
    let type: String
    let gender: WLDDCharacterGender
    let origin: WLDDOrigin
    let location: WLDDSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}



