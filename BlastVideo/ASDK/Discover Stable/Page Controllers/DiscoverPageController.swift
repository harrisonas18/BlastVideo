//
//  DiscoverPageController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import TwitterProfile
import XLPagerTabStrip

class DiscoverPageController : UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {
    
    
    var headerVC: EmptyHeader?
    var scrollView = UIScrollView()
    var gradientBar : GradientActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavBar()
        scrollView.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        gradientBar = GradientActivityIndicatorView(frame: CGRect(x: 0, y: navigationController?.navigationBar.bounds.maxY ?? 0, width: UIScreen.screenWidth(), height: 3))
        navigationController?.navigationBar.addSubview(gradientBar!)
        gradientBar?.fadeIn()
        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: Notification.Name("scrollToTopDiscover"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endRefresh), name: Notification.Name("endRefreshDiscover"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushSignInVC), name: Notification.Name("PushSignInVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushSignUpVC), name: Notification.Name("PushSignUpVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushCTAController), name: Notification.Name("pushCTAController"), object: nil)
        //add push username tapped
        //add Push hashtag
    }
    
    @objc func pushCTAController(){
        let vc = SignInUpCTAController()
        self.navigationController?.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func pushSignUpVC(){
//        let vc = SignUpPopoverMVP()
//        let navVC = UINavigationController(rootViewController: vc)
//        self.navigationController?.modalPresentationStyle = .overCurrentContext
//        self.navigationController?.present(navVC, animated: true)
    }
    
    @objc func pushSignInVC(){
//        let vc = SignInDisplayController()
//        //self.navigationController?.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func scrollToTop(notification: Notification){
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func endRefresh(notification: Notification){
        refresh.endRefreshing()
        gradientBar?.fadeOut()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmptyHeader") as? EmptyHeader
        return headerVC!
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagerTabController") as! PagerTabController
        vc.navigationController?.navigationBar.isHidden = false
        return vc
    }
    
    //headerHeight in the closed range [minValue, maxValue], i.e. minValue...maxValue
    func headerHeight() -> ClosedRange<CGFloat> {
        return (0)...0
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        //headerVC?.adjustBannerView(with: progress, headerHeight: headerHeight())
    }
    
    let refresh = UIRefreshControl()
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)
        
        self.scrollView = scrollView
    }
    
    @objc func handleRefreshControl() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDiscover"), object: nil)
    }
    
}

extension DiscoverPageController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Feed", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
//        navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "refreshIcon"), style: .plain, target: self, action: #selector(pushSettings))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func pushSettings(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDiscover"), object: nil)
    }
    
}
