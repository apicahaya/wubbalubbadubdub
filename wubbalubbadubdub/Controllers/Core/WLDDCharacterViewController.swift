//
//  WLDDCharacterViewController.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

final class WLDDCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = WLDDRequest(
            endpoint: .character,
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        print(request.url ?? "Endpoint dont get")
        
        WLDDService.shared.execute(request, expecting: WLDDCharacter.self) { result in
                
        }
    }    
}
