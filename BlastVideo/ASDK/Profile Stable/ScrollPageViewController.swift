//
//  ScrollPageViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/20/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollPageViewControllerDelegate: NSObject {
    
    func pageViewController(_ pageViewController: ScrollPageViewControllerDelegate?, didShow controller: UIViewController?, at index: Int)
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    
    func arrayForEditTitles() -> [Any]?
    func arrayForEditAllTitles() -> [Any]?
    func viewcontroller(with index: Int) -> UIViewController?
    func arrayForControllerTitles() -> [Any]?
    
}

class ScrollPageViewController: UIViewController, ScrollPageViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    func pageViewController(_ pageViewController: ScrollPageViewControllerDelegate?, didShow controller: UIViewController?, at index: Int) {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        <#code#>
    }
    
    func arrayForEditTitles() -> [Any]? {
        <#code#>
    }
    
    func arrayForEditAllTitles() -> [Any]? {
        <#code#>
    }
    
    func viewcontroller(with index: Int) -> UIViewController? {
        <#code#>
    }
    
    func arrayForControllerTitles() -> [Any]? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    
    private(set) var pageViewController: UIPageViewController?
    var currentIndex = 0
    var slideBar: FDSlideBar?
    ///Show more buttons, default NO
    var showMore = false
    /// Controller view to sidebar distance
    var controllerGap = 0
    ///Distance between two pages
    var controllerPageGap = 0
    /// data source
    var dataSource: Any?
    /// Displayed on the navigation bar, default NO
    var showOnNavigationBar = false
    /// Custom slideBar, default NO
    var slideBarCustom = false
    /// Refresh data after setdata
    func reloadData() {
        
    }
    
}
