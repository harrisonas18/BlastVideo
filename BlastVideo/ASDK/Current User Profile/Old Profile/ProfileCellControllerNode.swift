//
//  ProfileCellControllerNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ProfileCellControllerNode: ASCellNode {
    
    let displayNode = ASDisplayNode()
    
    // MARK: - Object life cycle
    init(controller: UIViewController) {
        super.init()
        
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: displayNode)
    }
    
}
