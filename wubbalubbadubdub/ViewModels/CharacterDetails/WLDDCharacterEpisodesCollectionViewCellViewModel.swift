//
//  WLDDCharacterEpisodesCollectionViewCellViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import Foundation

protocol WLDDEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class WLDDCharacterEpisodesCollectionViewCellViewModel: Hashable, Equatable {
    
    // MARK: - Properties
    private let episodeDataUrl: URL?
    private  var isFetching = false
    private var dataBlock: ((WLDDEpisodeDataRender) -> Void)?
    private var episode: WLDDEpisode? {
        didSet {
            guard let model = episode else {
                return   
            }
            dataBlock?(model)
        }
    }
    
    
    // MARK: - Init
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    // MARK: - Public Method
    
    public func registerForData(_ block: @escaping (WLDDEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                self.dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl,
              let request = WLDDRequest(url: url) else {
            return
        }
        
        isFetching = true
        
        
        WLDDService.shared.execute(request, expecting: WLDDEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: WLDDCharacterEpisodesCollectionViewCellViewModel, rhs: WLDDCharacterEpisodesCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}


