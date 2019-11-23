//
//  MainTabBarController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {

    lazy var feedVC = UINavigationController(rootViewController: FeedViewController())
//
    lazy var uploadVC = UINavigationController(rootViewController: UploadViewController())
    
//    lazy var profileVC = UINavigationController(rootViewController: ProfileViewController())
//
    lazy var profileVC: UINavigationController = {
        let userProfileVC = ProfileViewController()
        userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        userProfileVC.isCurrentUser = true
        return UINavigationController(rootViewController: userProfileVC)
    }()
    
    override func viewDidLoad() {
        feedVC.isNavigationBarHidden = true
        uploadVC.isNavigationBarHidden = true
        profileVC.isNavigationBarHidden = true
        super.viewDidLoad()
       feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.dash"), tag: 0)
        uploadVC.tabBarItem = UITabBarItem(title: "Upload", image: UIImage(systemName: "photo"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.square"), tag: 2)
        self.viewControllers = [feedVC, uploadVC, profileVC]
        self.viewControllers?.forEach({$0.tabBarController?.tabBar.barStyle = .black})
    }
}
