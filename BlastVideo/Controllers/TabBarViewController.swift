//
//  TabBarViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let discoverViewController = createNavController(vc: DiscoverViewController(), selected: #imageLiteral(resourceName: "play-button1"), unselected: #imageLiteral(resourceName: "play-button1-selected"))
        
        let cameraViewController = createNavController(vc: CameraViewController(), selected:#imageLiteral(resourceName: "photo-camera"), unselected:#imageLiteral(resourceName: "photo-camera-selected"))
        
        viewControllers = [discoverViewController, cameraViewController] //Discover, Camera, Profile
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
    }
    
}

extension UITabBarController {
    
    func createNavController(vc: UIViewController, selected: UIImage, unselected: UIImage) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        return navController
    }
}
