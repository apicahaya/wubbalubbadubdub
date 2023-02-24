//
//  WLDDLocationDetailViewViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

protocol WLDDLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

class WLDDLocationDetailViewViewModel {
    
    // MARK: - Properties
    
    enum SectionType {
        case information(viewmodels: [WLDDEpisodeInfoCollectionViewViewModel])
        case characters(viewModels: [WLDDCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: WLDDLocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    private let endpointUrl: URL?
    
    private var dataTuple: (location: WLDDLocation, characters: [WLDDCharacter])? {
        didSet {
            createCellViewModel()
            delegate?.didFetchLocationDetails()
        }
    }
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Methods
    
    public func character(at index: Int) -> WLDDCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    private func createCellViewModel() {
        guard let dataTuple = dataTuple else {
            return
        } 
        
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdString = location.created
        
        if let date = WLDDCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = WLDDCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date) 
        }
        
        cellViewModels = [
            .information(viewmodels: [
                .init(title: "Location Name: ",value: location.name),
                .init(title: "Type: ",value: location.type),
                .init(title: "Dimension: ",value: location.dimension),
                .init(title: "Created: ",value: createdString),
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
    
    public func fetchLocationData() {
        guard let url = endpointUrl,
              let request = WLDDRequest(url: url) else {
            return
        }
        
        WLDDService.shared.execute(request, expecting: WLDDLocation.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedLocations(location: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedLocations(location: WLDDLocation) {
        let requests: [WLDDRequest] = location.residents.compactMap({
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
                location: location,
                characters: characters
            )
        }
    }
}
