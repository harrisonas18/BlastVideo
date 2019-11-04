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
        node.attributedText = NSAttributedString(string: "About", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26.0, weight: .medium)])
        return node
    }()
    
    let helpParaOne: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Report a Problem", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let helpParaTwo: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "We would like to thank the following libraries and technologies for help making this app possible.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
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
                                           children: [])
        
        return ASInsetLayoutSpec.init(insets: .zero, child: stack)
    }
    
    
    
}
