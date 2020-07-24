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
    
    let aboutParaOne: LabelNode = {
        let node = LabelNode(height: 50, width: UIScreen.screenWidth())
        node.labelNode?.attributedText = NSAttributedString(string: "MyLive was built by Harry, Designed by Josh and Harry, and Made for Everyone.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        node.labelNode?.textAlignment = .center
        node.labelNode?.numberOfLines = 0
        return node
    }()
    
    let aboutParaTwo: LabelNode = {
        let node = LabelNode(height: 50, width: UIScreen.screenWidth())
        node.labelNode?.attributedText = NSAttributedString(string: "We would like to thank the following libraries and technologies for help making this app possible.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        node.labelNode?.textAlignment = .center
        node.labelNode?.numberOfLines = 0
        return node
    }()
    
    let aboutParaThree: LabelNode = {
        let node = LabelNode(height: 300, width: UIScreen.screenWidth())
        node.labelNode?.attributedText = NSAttributedString(string: "ActiveLabel,\nDisk,\nNotificationBannerSwift,\nGradientLoadingBar,\nTexture,\nDeepDiff,\nSJSegmentedScrollView,\nKingFisher,\nNextLevelSessionExporter,\nTwitterProfile,\nXLPagerTabStrip,\nInstantSearch,\nCache\n",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.labelNode?.numberOfLines = 0
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
                                           children: [aboutParaOne, aboutParaTwo, aboutParaThree])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8), child: stack)
    }
    
    
    
}


