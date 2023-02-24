//
//  WLDDEpisodeListView.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

protocol WLDDEpisodeListViewDelegate: AnyObject {
    func wlddEpisodeListView(
        _ episodeListView: WLDDEpisodeListView,
        didSelectEpisode character: WLDDEpisode
    )
}

final class WLDDEpisodeListView: UIView {

    public weak var delegate: WLDDEpisodeListViewDelegate?
    
    private let viewModel = WLDDEpisodeListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 10,
            right: 10
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            WLDDCharacterEpisodesCollectionViewCell.self,
            forCellWithReuseIdentifier: WLDDCharacterEpisodesCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            WLDDFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: WLDDFooterLoadingCollectionReusableView.identifier
        )
        return collectionView
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        
        addConstraints()

        spinner.startAnimating()
        viewModel.fetchEpisodes()
        viewModel.delegate = self
        
        setupCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension WLDDEpisodeListView: WLDDEpisodeListViewViewModelDelegate {
    func didLoadInitialEpisodes() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) { 
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates { 
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
     
    func didSelectEpisode(_ episode: WLDDEpisode) {
        delegate?.wlddEpisodeListView(self, didSelectEpisode: episode)
    }
}
