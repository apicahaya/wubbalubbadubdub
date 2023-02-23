//
//  WLDDCharacterCollectionViewCellViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit
import Foundation

final class WLDDCharacterCollectionViewCellViewModel : Hashable {
    
    public let characterName: String
    private let characterSpecies: String
    private let characterImageUrl: URL?

    // MARK: - Init
    init (
        characterName: String,
        characterSpecies: String,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
        self.characterSpecies = characterSpecies
        self.characterImageUrl = characterImageUrl

    }

    // MARK: - Public
    public var characterSpeciesText: String {
        return characterSpecies
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return 
        }
        
        WLDDImageLoader.shared.downloadImage(url: url, completion: completion)

    }
    
    // MARK: - Hashable
    static func == (lhs: WLDDCharacterCollectionViewCellViewModel, rhs: WLDDCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterSpecies)
        hasher.combine(characterImageUrl)
    }
}
