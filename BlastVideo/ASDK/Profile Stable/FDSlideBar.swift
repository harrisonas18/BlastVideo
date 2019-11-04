//
//  FDSlideBar.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/20/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
typealias FDSlideBarItemSelectedCallback = (Int) -> Void

let DEVICE_WIDTH = UIScreen.main.bounds.width
let DEFAULT_SLIDER_COLOR = UIColor.orange
let SLIDER_VIEW_HEIGHT = 1.5
let LAYOUTINSET = 10.0
let slidebarMenuButtonImage = "gonggao_customized.png"
let kDefaultHeightOFSlideBar = 40.0
let kDefaultUnifyWidth = 50.0
let MenuButtonWidth = 50.0

class FDSlideBar: UIView {
    // All the titles of FDSilderBar
    var itemsTitle: [Any] = []
    // All the item's text color of the normal state
    var menuButton: UIButton
    var itemColor: UIColor?
    var menuButtonTitle = ""
    var menuButtonSelectedTitle = ""
    var menuButtonTitleColor: UIColor?
    var menuButtonSelectedTitleColor: UIColor?
    var menuButtonImage: UIImage?
    var menuButtonSelectedImage: UIImage?
    var showMenuButton = false
    var isUnifyWidth = false
    /*Whether to uniform width */
    var showSelectSlide = false
    var currentSelected = 0
    var unifyWidth = 0
    /*Uniform width value */
    var menuButtonWidth = 0
    // The selected item's text color
    var itemSelectedColor: UIColor?
    // The slider color
    var sliderColor: UIColor?
    
    // Add the callback deal when a slide bar item be selected
    func slideBarItemSelectedCallback(_ callback: FDSlideBarItemSelectedCallback) {
    }
    
    func slideBarItemResetCallBack(_ resetCallBack: @escaping () -> Void) {
    }
    
    func slideShowMenuCallBack(_ menuCallBack: @escaping (_ show: Bool) -> Void) {
    }
    
    // Set the slide bar item at index to be selected
    func selectItem(at index: Int) {
    }
    
    func scroll(toNextIndex nextIndex: Int, progress: CGFloat) {
    }
    
    // MARK: - Lifecircle
    convenience init() {
        let frame = CGRect(x: 0.0, y: 0.0, width: DEVICE_WIDTH, height: kDefaultHeightOFSlideBar)
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        //if super.init(frame: frame)
        items = [AnyHashable]()
        showSelectSlide = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        if let scrollView = scrollView() {
            addSubview(scrollView)
        }
        scrollView()?.frame = bounds
        if let menuButton = menuButton() {
            addSubview(menuButton)
        }
    }
    
    func setShowSelectSlide(_ showSelectSlide: Bool) {
        self.showSelectSlide = showSelectSlide
        sliderView()?.alpha = showSelectSlide ? 1 : 0
    }
    
    func menuButton() -> UIButton? {
        if menuButton == nil {
            menuButton = UIButton(type: .custom)
            menuButton.backgroundColor = UIColor.white
            menuButton.frame = CGRect(x: CGFloat(bounds.size.width - menuButtonWidth()), y: 0, width: CGFloat(menuButtonWidth()), height: bounds.size.height)
            menuButton.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            menuButton.addTarget(self, action: #selector(FDSlideBar.menuButtonClick(_:)), for: .touchUpInside)
            menuButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            menuButton.setImage(UIImage(named: slidebarMenuButtonImage), for: .normal)
        }
        
        return menuButton
    }
    
    func layoutSubviews() {
        super.layoutSubviews()
        scrollView()?.frame = bounds
    }
    
    //#pragma - mark Action
    @objc func menuButtonClick(_ sender: UIButton?) {
        //if menuCallBack
        sender?.isEnabled = false
        menuCallBack(sender?.isSelected)
        sender?.isEnabled = true
    }
    
    
    
}

extension UIScrollView {
    func scrollRectToVisibleCentered(on visibleRect: CGRect, animated: Bool) {
        let inset = contentInset
        let frameForLayout = frame
        let centerPoint = CGPoint(x: visibleRect.origin.x + visibleRect.size.width / 2, y: visibleRect.origin.y + visibleRect.size.height / 2)
        var offset = CGPoint(x: centerPoint.x - frameForLayout.size.width / 2, y: centerPoint.y - frameForLayout.size.height / 2)
        offset.x = max(offset.x, -inset.left)
        offset.x = min(offset.x, contentSize.width - frameForLayout.size.width + inset.right)
        offset.y = max(offset.y, -inset.top)
        offset.y = min(offset.y, contentSize.height - frameForLayout.size.height + inset.bottom)
        contentOffset = offset
    }
}
