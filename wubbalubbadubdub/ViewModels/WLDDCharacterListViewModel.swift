//
//  WLDDCharacterListViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

final class WLDDCharacterListViewModel: NSObject {
    func fetchCharacters() {
        WLDDService.shared.execute(.listCharacterRequests, expecting: WLDDGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Example image url: " + String(model.results.first?.image ?? "No Image"))
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
        return 20
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
        let viewModel = WLDDCharacterCollectionViewCellViewModel(
            characterName: "Agni",
            characterStatus: .alive,
            characterImageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        )
        cell.configure(with: viewModel)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    
}
