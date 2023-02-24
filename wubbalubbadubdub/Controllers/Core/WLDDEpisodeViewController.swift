//
//  WLDDEpisodeViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

final class WLDDEpisodeViewController: UIViewController, WLDDEpisodeListViewDelegate {
    
    private let episodeListView = WLDDEpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episode"
        setupView()
    }    
    
    // MARK: - Private Methods
    private func setupView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - WLDDCharacterListViewDelegate
    func wlddEpisodeListView(
        _ episodeListView: WLDDEpisodeListView,
        didSelectEpisode episode: WLDDEpisode
    ) {
        let viewModel = WLDDEpisodeDetailViewViewModel(endpointUrl: URL(string: episode.url))
        let detailVC = WLDDEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
