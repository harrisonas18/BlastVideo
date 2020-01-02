

import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import DeepDiff
import TwitterProfile

class ProfileViewController : UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {
    
    var headerVC: HeaderViewController?
    var scrollView = UIScrollView()
    var gradientBar : GradientActivityIndicatorView?
    
    init() {
        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeaderViewController") as? HeaderViewController
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeaderViewController") as? HeaderViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        gradientBar = GradientActivityIndicatorView(frame: CGRect(x: 0, y: navigationController?.navigationBar.bounds.maxY ?? 0, width: UIScreen.screenWidth(), height: 3))
        navigationController?.navigationBar.addSubview(gradientBar!)
        gradientBar?.fadeIn()
        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: Notification.Name("ToTopProfilePost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endRefresh), name: Notification.Name("endRefreshProfile"), object: nil)
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
//        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeaderViewController") as? HeaderViewController
        return headerVC!
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XLPagerTabStripExampleViewController") as! XLPagerTabStripExampleViewController
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
    
    let refresh = UIRefreshControl()
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)
        
        self.scrollView = scrollView
    }
    
    @objc func handleRefreshControl() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
    }
}


extension ProfileViewController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: currentUserGlobal.username?.lowercased() ?? "Profile", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(pushSettings))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func pushSettings(){
        let vc = SettingsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


