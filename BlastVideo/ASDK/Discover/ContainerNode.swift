//
//  ConatinerNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ContainerNode: ASDisplayNode {
    
    // MARK: - Variables
    
    private let contentNode: ASDisplayNode
    
    // MARK: - Object life cycle
    
    init(node: ASDisplayNode) {
        contentNode = node
        super.init()
        self.backgroundColor = UIColor.containerBackgroundColor()
        self.addSubnode(self.contentNode)
    }
    
    // MARK: - Node life cycle
    
    override func didLoad() {
        super.didLoad()
        self.layer.borderColor = UIColor.containerBorderColor().cgColor
        self.layer.borderWidth = 1.0
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), child: self.contentNode)
    }
    
}

