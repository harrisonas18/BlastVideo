//
//  NewFeedDesignNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/14/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit

class NewFeedDesignNode: ASDisplayNode, ASPagerDataSource, ASPagerDelegate {
    
    var pushUsernameDelegate: PushUsernameDelegate?
    var pushViewcontrollerDelegate: PushViewControllerDelegate?
    var isUserSignedIn = false
    
    let customNavBar: CustomNavigationBar = {
        let node = CustomNavigationBar()
        node.isUserInteractionEnabled = true
        node.style.width = ASDimensionMake("100%")
        node.style.height = ASDimensionMake("55pt")
        return node
    }()
    
    private var pagerNode: ASPagerNode
        
    override init() {
        let pagerLayout = ASPagerFlowLayout()
        pagerLayout.scrollDirection = .horizontal
        pagerLayout.minimumLineSpacing = 0
        pagerLayout.minimumInteritemSpacing = 0
        pagerNode = ASPagerNode(collectionViewLayout: pagerLayout)
        super.init()
        automaticallyManagesSubnodes = true
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
    }
    
    override func didLoad() {
        super.didLoad()
        pagerNode.zPosition = 0
        pagerNode.style.width = ASDimensionMake("100%")
        pagerNode.style.height = ASDimensionMake("100%")
        
        customNavBar.zPosition = 3
        customNavBar.style.width = ASDimensionMake("100%")
        customNavBar.style.height = ASDimensionMake("55pt")
//        customNavBar.borderColor = UIColor.black.cgColor
//        customNavBar.borderWidth = 1.0
        if Api.User.CURRENT_USER != nil {
            isUserSignedIn = true
        } else {
            isUserSignedIn = false
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let inset = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.screenHeight()*0.90, right: 0), child: customNavBar)
        
        let stack = ASStackLayoutSpec.init(direction: .horizontal, spacing: 0, justifyContent: .center, alignItems: .center, children: [])
        
        let overlay = ASOverlayLayoutSpec.init(child: pagerNode, overlay: inset)
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: overlay)
    }
    
    override func transitionLayout(withAnimation animated: Bool, shouldMeasureAsync: Bool, measurementCompletion completion: (() -> Void)? = nil) {
        
        
        
    }
    
    var previousNum = 0.0
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("Content offset",pagerNode.contentOffset.x)
        
        if pagerNode.contentOffset.x == 0 && self.previousNum != 0.0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabAnimation"), object: nil)
            self.previousNum = 0.0
            print("Previous num: ", previousNum)
        }
        
        if pagerNode.contentOffset.x == 375 && self.previousNum != 375.0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabAnimation"), object: nil)
            self.previousNum = 375.0
            print("Previous num: ", previousNum)
        }
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        //return 2
        if isUserSignedIn == true {
            return 2
        } else {
            return 1
        }
    }
    
    
    //Somewhere check to see if user is signed in and display correct controller in the
    //following tab. For not signed in display a link to the Call to Action Controller
    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {

        if index == 0 {
            
            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
              return DiscoverStableController()
            }, didLoad: nil)

            node.style.preferredSize = pagerNode.bounds.size
            return node
            
        } else {
            
            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
                let controller = FollowingStableController()
                controller.pushUsernameDelegate = self
                controller.pushViewControllerDelegate = self
                return controller
            }, didLoad: nil)

            node.style.preferredSize = pagerNode.bounds.size
            return node
            
        }
    }
    
}
extension NewFeedDesignNode: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        pushUsernameDelegate?.pushUser(user: user)
    }
    
}

extension NewFeedDesignNode: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        pushViewcontrollerDelegate?.pushViewController(post: post, user: user)
    }
    
    
}
