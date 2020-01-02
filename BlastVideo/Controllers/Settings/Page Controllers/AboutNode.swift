//
//  AboutNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class AboutNode: ASDisplayNode {
    
    let aboutTitle: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "About", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26.0, weight: .medium)])
        return node
    }()
    
    let aboutParaOne: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "MyLive was built by Harry, Designed by Josh and Harry, and Made for Everyone.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let aboutParaTwo: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "We would like to thank the following libraries and technologies for help making this app possible.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let aboutParaThree: ASTextNode = {
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
                                           spacing: 8.0,
                                           justifyContent: .start,
                                           alignItems: .start,
                                           children: [aboutTitle,aboutParaOne,aboutParaTwo,aboutParaThree])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8), child: stack)
    }
    
    
    
}


