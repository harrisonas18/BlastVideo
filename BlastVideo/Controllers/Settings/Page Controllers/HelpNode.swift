//
//  HelpNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HelpNode: ASDisplayNode {
    
    let helpTitle: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Help", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26.0, weight: .medium)])
        return node
    }()
    
    let helpParaOne: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let helpParaTwo: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Email: senesac4@yahoo.com\n Report any problem you may have or feature suggestions to the email above. Please provide the nature of the request in the subject line i.e. feature suggestion or bug report", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let helpParaThree: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "ActiveLabel,\n Disk,\n NotificationBannerSwift,\n GradientLoadingBar,\n Texture,\n DeepDiff,\n SJSegmentedScrollView,\n KingFisher,\n NextLevelSessionExporter,\n TwitterProfile,\n XLPagerTabStrip,\n InstantSearch,\n Cache\n",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.init(direction: .vertical,
                                           spacing: 4.0,
                                           justifyContent: .center,
                                           alignItems: .center,
                                           children: [helpParaTwo])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: stack)
    }
    
    
    
}
