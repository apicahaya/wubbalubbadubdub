//
//  WLDDCharacterCollectionViewCellViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit
import Foundation

final class WLDDCharacterCollectionViewCellViewModel {
    
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
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ??  URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }

        task.resume()
    }
}