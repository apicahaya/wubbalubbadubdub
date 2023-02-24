//
//  WLDDEpisodeDetailViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

final class WLDDEpisodeDetailViewController: UIViewController, WLDDEpisodeDetailViewViewModelDelegate, WLDDEpisodeDetailViewDelegate {
    
    
    // MARK: - Properties
//    private let url: URL?
    
    private let viewModel: WLDDEpisodeDetailViewViewModel
    
    private let detailView = WLDDEpisodeDetailView()
    
    // MARK: - Init
    init(url: URL?) {
       
//        self.url = url
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        
        addConstraint()
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - View Model Delegate
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
    
    // MARK: - View Delegate
    func wlddEpisodeDetailView(
        _ detailView: WLDDEpisodeDetailView,
        didSelect character: WLDDCharacter
    ) {
        let vc = WLDDCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
