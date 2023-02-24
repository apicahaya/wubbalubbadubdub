//
//  WLDDLocationViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

final class WLDDLocationViewController: UIViewController {

    private let primaryView = WLDDLocationView()
    
    private let viewModel = WLDDLocationViewViewModel()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("wldd location view controller is loaded")
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func didTapSearch() {
        
    }
}

// MARK: - Extension LocationView View Model Delegate

extension WLDDLocationViewController: WLDDLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        print("this is called")
        primaryView.configure(with: viewModel)
    }
}
