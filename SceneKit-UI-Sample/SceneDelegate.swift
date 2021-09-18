//
//  SceneDelegate.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: ViewController())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
