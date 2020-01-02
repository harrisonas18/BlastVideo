//
//  HashtagSearchCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 11/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HashtagSearchCellNode: ASCellNode {
    
    
    let imageFront: ASNetworkImageNode = {
        let image = ASNetworkImageNode()
        return image
    }()
    
    let imageBack: ASNetworkImageNode = {
        let image = ASNetworkImageNode()
        return image
    }()
    
    let hashtagLabel: ASTextNode = {
        let label = ASTextNode()
        return label
    }()
    
    override init() {
        super.init()
        
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let overlay = ASOverlayLayoutSpec(child: imageFront, overlay: imageBack)
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 4.0, justifyContent: .center, alignItems: .center, children: [overlay, hashtagLabel])
        return stack
    }
    
}
