//
//  NavigationBarNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class NavigationBarNode: ASDisplayNode {
    
    let backgroundNode: ASDisplayNode = {
        let node = ASDisplayNode()
        return node
    }()
    
    let textNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "LIVEME")
        return node
    }()
    
    
    override init() {
        super.init()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth(), height: 44)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASOverlayLayoutSpec(child: backgroundNode, overlay: textNode)
    }
    
    
}
