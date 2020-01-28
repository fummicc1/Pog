//
//  SceneDelegate.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/28.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = FindDiaryMapViewController()
		window?.makeKeyAndVisible()
	}
}

