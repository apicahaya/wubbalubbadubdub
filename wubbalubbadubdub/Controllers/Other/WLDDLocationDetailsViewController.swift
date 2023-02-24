//
//  WLDDLocationDetailsViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

class WLDDLocationDetailsViewController: UIViewController, WLDDLocationDetailViewViewModelDelegate, WLDDLocationDetailViewDelegate {
    
    
    
    // MARK: - Properties
    private let viewModel: WLDDLocationDetailViewViewModel
    
    private let detailView = WLDDLocationDetailView()
    
    // MARK: - Init
    init(location: WLDDLocation) {
        let url = URL(string: location.url)
        self.viewModel = WLDDLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location Detail"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        
        addConstraint()
        
        viewModel.delegate = self
        viewModel.fetchLocationData()
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
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
    
    // MARK: - View Delegate
    func wlddEpisodeDetailView(
        _ detailView: WLDDLocationDetailView,
        didSelect character: WLDDCharacter
    ) {
        let vc = WLDDCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
