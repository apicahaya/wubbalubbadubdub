//
//  WLDDLocationViewViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import Foundation

protocol WLDDLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class WLDDLocationViewViewModel {
    
    weak var delegate: WLDDLocationViewViewModelDelegate?
    
    private var locations: [WLDDLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = WLDDLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    public private(set) var cellViewModels: [WLDDLocationTableViewCellViewModel] = []
    
    private var apiInfo: WLDDGetAllLocationsResponse.Info?
    
    init() {
    }
    
    public func fetchLocations() {
        WLDDService.shared.execute(
            .listLocationsRequests,
            expecting: WLDDGetAllLocationsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                
                break
            }
        }
    }
    
    private var hasMoreResult: Bool {
        return false
    }
}
