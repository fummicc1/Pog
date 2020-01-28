//
//  AppDelegate.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/28.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		#if DEBUG
		let options = FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-debug", ofType: "plist")!)!
		FirebaseApp.configure(options: options)
		#else
		let options = FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!)!
		FirebaseApp.configure(options: options)
		#endif
		
		return true
	}
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
}

