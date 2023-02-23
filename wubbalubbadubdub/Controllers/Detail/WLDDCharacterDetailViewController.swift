//
//  WLDDCharacterDetailViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit

final class WLDDCharacterDetailViewController: UIViewController {
    private let viewModel: WLDDCharacterDetailViewModel
    
    init(viewModel: WLDDCharacterDetailViewModel) {
        self.viewModel = viewModel
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
    }
    
    

}
