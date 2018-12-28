//
//  AppDelegate.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/19/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if let accessToken = UserDefaults.standard.string(forKey: "pinterestAccessToken") {
            NetworkManager.sharedInstantce.accessToken = accessToken
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        return true
    }
    
}

