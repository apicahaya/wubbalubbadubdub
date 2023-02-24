//
//  WLDDCharacterDetailViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit

final class WLDDCharacterDetailViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: WLDDCharacterDetailViewModel
    private let detailView: WLDDCharacterDetailView
    
    // MARK: - Initializers
    init(viewModel: WLDDCharacterDetailViewModel) {
        self.viewModel = viewModel
        self.detailView = WLDDCharacterDetailView(
            frame: .zero,
            viewModel: viewModel
        )
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        addConstraint()
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Collection Delegate and Data Source
extension WLDDCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(viewModels: let viewModels):
            return viewModels.count
        case .episodes(viewModels: let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]

        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WLDDCharacterPhotoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WLDDCharacterPhotoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WLDDCharacterInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WLDDCharacterInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WLDDCharacterEpisodesCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WLDDCharacterEpisodesCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let sectionType = viewModel.sections[indexPath.section]

        switch sectionType {
        case .photo, .information: break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let vc = WLDDEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
