//
//  WLDDDetailViewViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

class WLDDDetailViewViewModel {
    
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = WLDDRequest(url: url) else {
            return
        }
        
        WLDDService.shared.execute(request, expecting: WLDDEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure( _):
                break
            }
        }
    }
}
