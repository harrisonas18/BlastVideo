//
//  TabBarViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import Disk
import FirebaseAuth

class TabBarController: UITabBarController {
    
    var signedIn = false
    
    var profileNavController = UINavigationController()
    var discoverTestNav = UINavigationController()
    
    var discoverTest = DiscoverPageController()
    var profileViewController = ProfileViewController()
    let layout = UICollectionViewFlowLayout()
    var livePhotoSelectorCtrl = LivePhotoSelectorController()
    var livePhotoSlctNav = UINavigationController()
    var searchController = SearchController()
    var searchNavController = UINavigationController()
    
    let pop1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopover") as! SignUpPopoverController
    let pop2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopover") as! SignUpPopoverController
    
    var pop1Nav = UINavigationController()
    var pop2Nav = UINavigationController()
    
    var tabBarList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.tintColor = .black
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.signedIn = true
                self.discoverTestNav = UINavigationController(rootViewController: self.discoverTest)
                self.discoverTestNav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "feedIcon"), selectedImage: #imageLiteral(resourceName: "feedIcon"))
                
                self.searchNavController = UINavigationController(rootViewController: self.searchController)
                self.searchNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search-selected"), selectedImage: #imageLiteral(resourceName: "search-selected"))
                
                self.livePhotoSelectorCtrl = LivePhotoSelectorController(collectionViewLayout: self.layout)
                self.livePhotoSlctNav = UINavigationController(rootViewController: self.livePhotoSelectorCtrl)
                self.livePhotoSlctNav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "AddButton"), selectedImage: #imageLiteral(resourceName: "AddButton"))
                
                self.profileNavController = UINavigationController(rootViewController: self.profileViewController)
                self.profileNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ProfileIcon"), selectedImage: #imageLiteral(resourceName: "ProfileIcon"))
                
                self.viewControllers = [self.discoverTestNav, self.searchNavController, self.livePhotoSlctNav, self.profileNavController]
                
            } else {
                
                self.signedIn = false
                
                self.discoverTestNav = UINavigationController(rootViewController: self.discoverTest)
                self.discoverTestNav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "feedIcon"), selectedImage: #imageLiteral(resourceName: "feedIcon"))
                
                self.searchNavController = UINavigationController(rootViewController: self.searchController)
                self.searchNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search-selected"), selectedImage: #imageLiteral(resourceName: "search-selected"))
                
                self.livePhotoSelectorCtrl = LivePhotoSelectorController(collectionViewLayout: self.layout)
                self.livePhotoSlctNav = UINavigationController(rootViewController: self.livePhotoSelectorCtrl)
                self.livePhotoSlctNav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "AddButton"), selectedImage: #imageLiteral(resourceName: "AddButton"))
                
                self.profileNavController = UINavigationController(rootViewController: self.profileViewController)
                self.profileNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ProfileIcon"), selectedImage: #imageLiteral(resourceName: "ProfileIcon"))
                
                self.viewControllers = [self.discoverTestNav, self.searchNavController]
            }
        }
        
        
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController == tabBarController.viewControllers?[2] && signedIn == false {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopover") as! SignUpPopoverController
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            return false
        } else {
            return true
        }
        
    }
    
}

    
    

