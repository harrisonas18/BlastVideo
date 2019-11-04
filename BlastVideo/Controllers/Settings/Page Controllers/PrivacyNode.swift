//
//  PrivacyNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class PrivacyNode: ASDisplayNode {
    
    let settingIcon: ASImageNode = {
        let node = ASImageNode()
        node.image = UIImage(named: "construction-worker")
        node.tintColor = .black
        node.style.preferredSize = CGSize(width: 50, height: 50)
        node.contentMode = .scaleAspectFit
        return node
    }()
    
    let settingTitle: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Under Construction", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
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
                                           children: [settingIcon, settingTitle])
        
        return ASInsetLayoutSpec.init(insets: .zero, child: stack)
    }
    
    
    
}
