//
//  SceneDelegate.swift
//  CitySearch
//
//  Created by Willy on 27/02/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        Application.shared.configureMainInterface(in: window)
        self.window = window
    }
}

