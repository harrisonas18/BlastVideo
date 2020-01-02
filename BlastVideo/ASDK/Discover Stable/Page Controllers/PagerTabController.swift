//
//  PagerTabController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import TwitterProfile
import XLPagerTabStrip
import GradientLoadingBar

class PagerTabController: ButtonBarPagerTabStripViewController, PagerAwareProtocol {
    
    //MARK: PagerAwareProtocol
    var pageDelegate: BottomPageDelegate?
    var gradientBar : GradientActivityIndicatorView?
    
    var currentViewController: UIViewController?{
        return viewControllers[currentIndex]
    }
    
    var pagerTabHeight: CGFloat?{
        return 25
    }
    
    //MARK: Properties
    var isReload = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settings.style.buttonBarBackgroundColor = .white
        
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemBackgroundColor = .white
        
        settings.style.selectedBarBackgroundColor = .black
        settings.style.selectedBarHeight = 3
        
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //gradientBar = GradientActivityIndicatorView(frame: CGRect(x: 0, y: 44, width: UIScreen.screenWidth(), height: 3))
        //view.addSubview(gradientBar!)
        //gradientBar?.fadeIn()
        delegate = self
        
        self.changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .gray
            let view = UIView(frame: CGRect(x: 0, y: 42, width: UIScreen.screenWidth(), height: 3))
            view.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
            oldCell?.addSubview(view)
            newCell?.label.textColor = .black
            newCell?.addSubview(view)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let vc1 = DiscoverStableController()
        vc1.pageTitle = "Discover"
        let child_1 = vc1
        
        let vc2 = FollowingStableController()
        vc2.pageTitle = "Following"
        let child_3 = vc2
        
        return [child_1, child_3]
    }
    
    override func reloadPagerTabStripView() {
        pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        super.reloadPagerTabStripView()
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }
        
        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.tp_pageViewController(self.currentViewController, didSelectPageAt: toIndex)
        
    }
}
