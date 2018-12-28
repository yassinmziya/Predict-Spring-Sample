//
//  TabBarController.swift
//  Predict Spring Sample
//
//  Created by Yassin Mziya on 12/21/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NetworkManager.sharedInstantce.accessToken)
        
        UITabBar.appearance().tintColor = .pinterestRed
        UITabBar.appearance().backgroundColor = .white

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "profile-icon"), selectedImage: UIImage(named: "profile-icon"))
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "home-icon"), selectedImage: UIImage(named: "home-icon"))
        
        let tabsList = [homeViewController, profileViewController].map { UINavigationController(rootViewController: $0) }
        tabsList.forEach { $0.isNavigationBarHidden = true }
        
        viewControllers = tabsList
    }

}
