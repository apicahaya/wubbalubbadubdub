//
//  WLDDEpisodeDetailViewViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

protocol WLDDEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

class WLDDEpisodeDetailViewViewModel {
    
    // MARK: - Properties
    
    enum SectionType {
        case information(viewmodels: [WLDDEpisodeInfoCollectionViewViewModel])
        case characters(viewModels: [WLDDCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: WLDDEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    private let endpointUrl: URL?
    
    private var dataTuple: (episode: WLDDEpisode, characters: [WLDDCharacter])? {
        didSet {
            createCellViewModel()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Methods
    
    private func createCellViewModel() {
        guard let dataTuple = dataTuple else {
            return
        } 
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        cellViewModels = [
            .information(viewmodels: [
                .init(title: "Episode Name: ",value: episode.name),
                .init(title: "Air Date: ",value: episode.air_date),
                .init(title: "Episode: ",value: episode.episode),
                .init(title: "Created: ",value: episode.created),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return WLDDCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterSpecies: character.species,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }
    
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = WLDDRequest(url: url) else {
            return
        }
        
        WLDDService.shared.execute(request, expecting: WLDDEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: WLDDEpisode) {
        let requests: [WLDDRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return WLDDRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters: [WLDDCharacter] = []
        for request in requests {
            group.enter()
            WLDDService.shared.execute(request, expecting: WLDDCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) { 
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}
