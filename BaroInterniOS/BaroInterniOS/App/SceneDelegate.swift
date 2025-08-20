//
//  SceneDelegate.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let vc = DIContainer.shared.makeInitialViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        UINavigationBar.appearance().tintColor = .cRed
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

