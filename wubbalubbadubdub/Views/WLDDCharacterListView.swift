//
//  WLDDCharacterListView.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

protocol WLDDCharacterListViewDelegate: AnyObject {
    func wlddCharacterListView(
        _ characterListView: WLDDCharacterListView,
        didSelectCharacter character: WLDDCharacter
    )
}

final class WLDDCharacterListView: UIView {
    
    public weak var delegate: WLDDCharacterListViewDelegate?
    
    private let viewModel = WLDDCharacterListViewModel()
    
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
            WLDDCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: WLDDCharacterCollectionViewCell.cellIdentifier
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
        viewModel.fetchCharacters()
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

extension WLDDCharacterListView: WLDDCharacterListViewModelDelegate {
    func didSelectCharacter(_ character: WLDDCharacter) {
        delegate?.wlddCharacterListView(
            self,
            didSelectCharacter: character
        )
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) { 
            self.collectionView.alpha = 1
        }
    }
}
