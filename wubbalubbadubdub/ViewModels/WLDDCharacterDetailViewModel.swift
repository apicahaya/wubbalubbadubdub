//
//  WLDDCharacterDetailViewMOdel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import Foundation

final class WLDDCharacterDetailViewModel {
    private let character: WLDDCharacter
    
    init(character: WLDDCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
