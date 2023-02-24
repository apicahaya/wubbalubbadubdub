//
//  WLDDEpisodeListViewViewModel.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import Foundation
import UIKit

protocol WLDDEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
    func didSelectEpisode(_ episode: WLDDEpisode)
}

final class WLDDEpisodeListViewViewModel: NSObject {
    // MARK: - Properties

    public weak var delegate: WLDDEpisodeListViewViewModelDelegate?
    private var isLoadingMoreEpisode = false
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemGreen,
        .systemYellow,
        .systemCyan,
        .systemRed
    ]
    private var episodes: [WLDDEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = WLDDCharacterEpisodesCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }  
            }
        }
    }
    private var cellViewModels: [WLDDCharacterEpisodesCollectionViewCellViewModel] = []
    private var apiInfo: WLDDGetAllEpisodesResponse.Info? = nil
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    // MARK: - Actions
    public func fetchEpisodes() {
        WLDDService.shared.execute(
            .listEpisodesRequests,
            expecting: WLDDGetAllEpisodesResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.results
                let info = responseModel.info
                self?.episodes = result
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreEpisode else {
            return
        }
        
        isLoadingMoreEpisode = true
        guard let request = WLDDRequest(url: url) else {
            isLoadingMoreEpisode = false
            return
        }

        WLDDService.shared.execute(
            request,
            expecting: WLDDGetAllEpisodesResponse.self
        ) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                
                let originalCount =  strongSelf.episodes.count
                let newCount = moreResult.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
                
                strongSelf.episodes.append(contentsOf: moreResult)
                self?.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(
                        with: indexPathToAdd
                    )
                    strongSelf.isLoadingMoreEpisode = false
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreEpisode = false
            }
        }
    }
}
// MARK: - UI Colletion View Delegate
extension WLDDEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            withReuseIdentifier: WLDDCharacterEpisodesCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? WLDDCharacterEpisodesCollectionViewCell else {
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
        let bounds = collectionView.bounds
        let width = (bounds.width - 20)
        return CGSize(
            width: width,
            height: 100
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

// MARK: - ScrollView Delegate
extension WLDDEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard 
            shouldShowLoadMoreIndicator, 
            !isLoadingMoreEpisode,
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
