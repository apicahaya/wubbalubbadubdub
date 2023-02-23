//
//  WLDDCharacterListViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit
import Foundation

protocol WLDDCharacterListViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacter(with newIndexPath: [IndexPath])
    func didSelectCharacter(_ character: WLDDCharacter)
}

final class WLDDCharacterListViewModel: NSObject {
    // MARK: - Properties

    public weak var delegate: WLDDCharacterListViewModelDelegate?
    private var isLoadingMoreCharacter = false
    private var characters: [WLDDCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = WLDDCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterSpecies: character.species,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }  
            }
        }
    }
    private var cellViewModels: [WLDDCharacterCollectionViewCellViewModel] = []
    private var apiInfo: WLDDGetAllCharactersResponse.Info? = nil
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    // MARK: - Actions
    public func fetchCharacters() {
        WLDDService.shared.execute(
            .listCharacterRequests,
            expecting: WLDDGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.results
                let info = responseModel.info
                self?.characters = result
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacter else {
            return
        }
        
        isLoadingMoreCharacter = true
        guard let request = WLDDRequest(url: url) else {
            isLoadingMoreCharacter = false
            return
        }

        WLDDService.shared.execute(
            request,
            expecting: WLDDGetAllCharactersResponse.self
        ) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                
                let originalCount =  strongSelf.characters.count
                let newCount = moreResult.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
                
                strongSelf.characters.append(contentsOf: moreResult)
                self?.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacter(
                        with: indexPathToAdd
                    )
                    strongSelf.isLoadingMoreCharacter = false
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacter = false
            }
        }
    }
}
// MARK: - UI Colletion View Delegate
extension WLDDCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionFooter, shouldShowLoadMoreIndicator,
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: WLDDFooterLoadingCollectionReusableView.identifier,
            for: indexPath
        ) as? WLDDFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating() 
        return footer
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
            
        }
        
        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
    
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
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - ScrollView Delegate
extension WLDDCharacterListViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard 
            shouldShowLoadMoreIndicator, 
            !isLoadingMoreCharacter,
            !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString)
        else { 
            return 
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
