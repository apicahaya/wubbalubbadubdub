//
//  SceneDelegate.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 22/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        let vc = ViewController()
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
    }

    func sceneWillResignActive(_ scene: UIScene) {
      
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

