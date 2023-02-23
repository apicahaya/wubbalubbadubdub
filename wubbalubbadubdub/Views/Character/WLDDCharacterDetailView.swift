//
//  WLDDCharacterDetailView.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit

final class WLDDCharacterDetailView: UIView {
    
    // MARK: - Properties

    public var collectionView: UICollectionView?
    
    private let viewModel: WLDDCharacterDetailViewModel
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Init
    
    init(
        frame: CGRect,
        viewModel: WLDDCharacterDetailViewModel
    ) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemPurple
        let collectionView = createColletionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    private func addConstraint() {
        guard let collectionView = collectionView else { return }
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
    
    private func createColletionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
    private func createSection(
        for sectionIndex: Int
    ) -> NSCollectionLayoutSection{
        
        let sectionTypes = viewModel.sections

        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotosectionLayout()
        case .information:
            return viewModel.createInfosectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        }
    }
}
