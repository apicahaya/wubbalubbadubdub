//
//  WLDDEpisodeDetailViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

final class WLDDEpisodeDetailViewController: UIViewController, WLDDEpisodeDetailViewViewModelDelegate {
    
    
    // MARK: - Properties
    private let url: URL?
    
    private let viewModel: WLDDEpisodeDetailViewViewModel
    
    private let detailView = WLDDEpisodeDetailView()
    
    // MARK: - Init
    init(url: URL?) {
       
        self.url = url
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
    
    // MARK: - Delegate
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}
