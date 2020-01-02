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
import Cache

class TabBarController: UITabBarController {
    
    let badge = UIView()
    
    var signedIn = false
    
    var discoverTestNav = UINavigationController()
    var discoverTest = DiscoverPageController()
    
    var profileNavController = UINavigationController()
    
    
    let layout = UICollectionViewFlowLayout()
    var livePhotoSelectorCtrl = LivePhotoSelectorController()
    var livePhotoSlctNav = UINavigationController()
    
    var searchController = SearchController()
    var searchNavController = UINavigationController()
    
    var notificationController = TabBarNodeController()//NotificationTableController()//
    var notificationNavController = UINavigationController()
    
    let pop1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopover") as! SignUpPopoverController
    let pop2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopover") as! SignUpPopoverController
    
    var pop1Nav = UINavigationController()
    var pop2Nav = UINavigationController()
    
    var tabBarList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        badge.layer.cornerRadius = 2.5
        badge.layer.backgroundColor = UIColor.red.cgColor
        self.tabBar.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.heightAnchor.constraint(equalToConstant: 5),
            badge.widthAnchor.constraint(equalToConstant: 5),
            badge.bottomAnchor.constraint(equalTo: self.tabBar.bottomAnchor, constant: 8),
            badge.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor, constant: 44),
        ])
        
        tabBarController?.selectedIndex = 0
        self.delegate = self
        tabBar.tintColor = .black

        NotificationCenter.default.addObserver(self, selector: #selector(tabToZero), name: Notification.Name("tabToZero"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addBadge), name: Notification.Name("AddNotificationBadgeOnTabBarIcon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBadge), name: Notification.Name("RemoveNotificationBadgeOnTabBarIcon"), object: nil)
        
        self.discoverTestNav = UINavigationController(rootViewController: self.discoverTest)
        self.discoverTestNav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "feedIcon"), selectedImage: #imageLiteral(resourceName: "feedIcon"))
        
        self.searchNavController = UINavigationController(rootViewController: self.searchController)
        self.searchNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search-selected"), selectedImage: #imageLiteral(resourceName: "search-selected"))
        
        self.livePhotoSelectorCtrl = LivePhotoSelectorController(collectionViewLayout: self.layout)
        self.livePhotoSlctNav = UINavigationController(rootViewController: self.livePhotoSelectorCtrl)
        self.livePhotoSlctNav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "PlusButtonOutline120"), selectedImage: #imageLiteral(resourceName: "PlusButtonOutline120"))
        
        self.profileNavController = UINavigationController(rootViewController: ProfileViewController())
        self.profileNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ProfileIcon"), selectedImage: #imageLiteral(resourceName: "ProfileIconFilled"))
        
        self.notificationNavController = UINavigationController(rootViewController: self.notificationController)
        self.notificationNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "Notification"), selectedImage: #imageLiteral(resourceName: "Notification"))
        
        self.viewControllers = [self.discoverTestNav, self.searchNavController, self.livePhotoSlctNav, self.notificationNavController, self.profileNavController]
        
        
        
        //Some how chnage user header user object - delegate, singleton, or ???
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
                currentUserGlobal.id = user?.uid
                
                if let user = StorageCacheController.shared.retrieveUser(user: currentUserGlobal){
                    currentUserGlobal = user
                } else {
                    Api.User.observeCurrentUser { (user) in
                        currentUserGlobal = user
                        StorageCacheController.shared.saveUser(user: user)
                    }
                }
                self.signedIn = true
                
            } else {
                
                currentUserGlobal = UserObject()
                self.signedIn = false
                
                
            }
        }
        
        
    }
    
    @objc func tabToZero(){
        print("tab to zero called")
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @objc func addBadge(){
        print("add badge called")
        DispatchQueue.main.async {
            
        }
    }
    
    @objc func removeBadge(){
        print("remove badge called")
        DispatchQueue.main.async {
            
        }
    }
    
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPopover") as! SignUpPopoverController
        vc.modalPresentationStyle = .overCurrentContext
        
        if viewController == tabBarController.viewControllers?[2] && signedIn == false {
            self.present(vc, animated: true, completion: nil)
            return false
        } else if viewController == tabBarController.viewControllers?[4] && signedIn == false {
            self.present(vc, animated: true, completion: nil)
            return false
        }  else {
            return true
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //if view controller is selected index scroll
        //Put listener in viewdidappear if you want action to only take place if view is showing
        if tabBarController.selectedIndex == 0 {
            //Send Notification to Discover
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollToTopDiscover"), object: nil)
        } else if tabBarController.selectedIndex == 2 {
            //Send Notification to Notification
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDiscover"), object: nil)
        } else if tabBarController.selectedIndex == 3 {
            //Send Notification to Profile
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToTopProfilePost"), object: nil)
        }  else {
            
        }
    }
    
}

        //tabBar.unselectedItemTintColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1.0)
//        if #available(iOS 13.0, *) {
//            let effect = UIBlurEffect(style: .systemUltraThinMaterial)
//            let view = UIVisualEffectView(effect: effect)
//        } else {
//            // Fallback on earlier versions
//        }
