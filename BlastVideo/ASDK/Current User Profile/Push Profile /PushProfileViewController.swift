//
//  PushProfileViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import DeepDiff
import TwitterProfile
import FirebaseAuth

class PushProfileViewController : UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {
    
    var tpScrollView: UIScrollView?
    var headerVC: PushProfileHeader?
    var user: UserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PushProfileHeader") as? PushProfileHeader
        headerVC?.user = user
        return headerVC!
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PushProfileTabController") as! PushProfileTabController
        vc.user = user
        return vc
    }
    
    //headerHeight in the closed range [minValue, maxValue], i.e. minValue...maxValue
    func headerHeight() -> ClosedRange<CGFloat> {
        return (0)...100
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        //headerVC?.adjustBannerView(with: progress, headerHeight: headerHeight())
    }
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        
    }
}


extension PushProfileViewController {
    
    func setupNavBar() {

        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: user?.username?.lowercased() ?? "Profile", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "menuButton"), style: .plain, target: self, action: #selector(setMenu))
        rightBarItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    @objc func setMenu(){
        
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
