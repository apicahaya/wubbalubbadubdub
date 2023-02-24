//
//  WLDDEpisodeDetailViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

final class WLDDEpisodeDetailViewController: UIViewController {
    
    private let url: URL?
    
    // MARK: - Init
    init(url: URL?) {
       
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
    

    
}
