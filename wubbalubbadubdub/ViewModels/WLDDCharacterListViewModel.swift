//
//  WLDDCharacterListViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

protocol WLDDCharacterListViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class WLDDCharacterListViewModel: NSObject {
    
    public weak var delegate: WLDDCharacterListViewModelDelegate?
    
    private var characters: [WLDDCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = WLDDCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterSpecies: character.species,
                    characterImageUrl: URL(string: character.image)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [WLDDCharacterCollectionViewCellViewModel] = []
    
    public func fetchCharacters() {
        WLDDService.shared.execute(
            .listCharacterRequests,
            expecting: WLDDGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.results
                self?.characters = result
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension WLDDCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WLDDCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? WLDDCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        } 
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    
}
