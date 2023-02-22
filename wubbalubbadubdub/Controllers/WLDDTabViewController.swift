//
//  ViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

final class WLDDTabViewController: UITabBarController {

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        setupTabs()
    }
    
    // MARK: - Private Methods
    
    private func setupTabs() {
        let charactersVC = WLDDCharacterViewController()
        let locationsVC = WLDDLocationViewController()
        let episodesVC = WLDDEpisodeViewController()
        let settingsVC = WLDDSettingViewController()
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
    
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationsVC)
        let nav3 = UINavigationController(rootViewController: episodesVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(named: "TabBar/CharacterSelected")?.resized(to: CGSize(width: 32.0,
            height: 32.0)),
            tag: 1
        )
        nav2.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(named: "TabBar/LocationSelected")?.resized(to: CGSize(width: 32.0, height: 32.0)),
            tag: 2
        )
        nav3.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(named: "TabBar/EpisodeSelected")?.resized(to: CGSize(width: 32.0,
            height: 32.0)),
            tag: 3
        )
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 4)
        
        for nav in [nav1,
                    nav2,
                    nav3,
                    nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1,
            nav2,
            nav3,
            nav4],
            animated: true
        )
        
    }
}

