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
        
        
        
        let firstViewController = UINavigationController(rootViewController: DiscoverViewController())
        firstViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search-selected"))
        firstViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordViewController")
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "camera"), selectedImage: #imageLiteral(resourceName: "camera-selected"))
        secondViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let thirdViewController = SignInViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home-selected"))
        thirdViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList
        
        tabBar.tintColor = UIColor(named: "Theme")
        
        
    }
    
}
