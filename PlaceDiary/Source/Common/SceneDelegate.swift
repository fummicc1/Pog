//
//  SceneDelegate.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/28.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import CoreLocation
import YPImagePicker

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
        var config = YPImagePickerConfiguration()
        config.colors.tintColor = UIColor(named: "Tint")!
        config.library.mediaType = .photo
        config.showsPhotoFilters = false
        config.screens = [.library, .photo]
        YPImagePickerConfiguration.shared = config
		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = HomeViewController()
		window?.makeKeyAndVisible()
	}
}

