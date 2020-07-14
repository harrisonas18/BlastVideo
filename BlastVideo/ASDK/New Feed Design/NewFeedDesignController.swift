//
//  NewFeedDesignController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/13/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift

class NewFeedDesignController: ASViewController<NewFeedDesignNode> {
  
    let notification = StatusBarNotificationBanner(title: "Success")
    let feedNode = NewFeedDesignNode()
    

    init() {
        super.init(node: feedNode)
        feedNode.pushUsernameDelegate = self
        feedNode.pushViewcontrollerDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushCTAController), name: Notification.Name("pushCTAController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushDetailController), name: Notification.Name("PushDetailController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideBarOnSwipe), name: Notification.Name("HideBarOnSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideBarOnSwipe), name: Notification.Name("ShowBarOnSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissCTANode), name: Notification.Name("DismissCTANode"), object: nil)
    }
    
    
    @objc func dismissCTANode(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideBarOnSwipe(){
        //Presents the Call to Action form when not logged in
        //Triggered from tabbarviewcontroller
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            //self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: true)
            print("Hide")
        }, completion: nil)
    }
    @objc func ShowBarOnSwipe(){
        //Presents the Call to Action form when not logged in
        //Triggered from tabbarviewcontroller
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            //self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(false, animated: true)
            print("Unhide")
        }, completion: nil)
    }
    
    @objc func pushCTAController(){
        //Presents the Call to Action form when not logged in
        //Triggered from tabbarviewcontroller
        let vc = SignInUpCTAController()
        self.navigationController?.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    var user = UserObject()
    var post = Post()
    
    
    @objc func pushDetailController(){
        //Presents the Call to Action form when not logged in
        //Triggered from tabbarviewcontroller
        let vc = ASDetailViewController(post: self.post, user: self.user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// MARK:
extension NewFeedDesignController {
    
    func setupNavBar() {
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pushSearch))
        self.navigationItem.rightBarButtonItem = searchButton
        
        //let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customNavBar)
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
    }
    
    @objc func pushSearch(){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension NewFeedDesignController: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        print("push detail controller")
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension NewFeedDesignController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        print("Push user called")
        let vc = PushProfileViewController()
        //vc.hidesBottomBarWhenPushed = true
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
