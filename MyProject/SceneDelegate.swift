//
//  SceneDelegate.swift
//  MyProject
//
//  Created by Константин Коробов on 24.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController(rootViewController: MainViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func switchToMainTabBar() {
        guard let window = UIApplication.shared.windows.first else { return }
        let mainTabBarController = MainTabBarController()
        window.rootViewController = mainTabBarController
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
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

