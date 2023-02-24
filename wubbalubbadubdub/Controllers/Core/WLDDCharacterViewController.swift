//
//  WLDDCharacterViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

final class WLDDCharacterViewController: UIViewController, WLDDCharacterListViewDelegate {
    
    private let characterListView = WLDDCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        view.addSubview(characterListView)
        setupView()
    }    
    
    // MARK: - Private Methods
    private func setupView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - WLDDCharacterListViewDelegate
    
    func wlddCharacterListView(
        _ characterListView: WLDDCharacterListView,
        didSelectCharacter character: WLDDCharacter
    ) {
        let viewModel = WLDDCharacterDetailViewModel(character: character)
        let detailVC = WLDDCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
}
