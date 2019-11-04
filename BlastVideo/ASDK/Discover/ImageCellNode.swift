//
//  ImageCellNode.swift
//  Texture
//
//  Copyright (c) Facebook, Inc. and its affiliates.  All rights reserved.
//  Changes after 4/13/2017 are: Copyright (c) Pinterest, Inc.  All rights reserved.
//  Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0
//

import UIKit
import AsyncDisplayKit

class ImageCellNode: ASCellNode {
    
    let imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    init(post: Post) {
        super.init()
        automaticallyManagesSubnodes = true
        imageNode.url = URL(string: post.photoUrl!)
        imageNode.shouldRenderProgressImages = false
    }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let ratioSpec = ASRatioLayoutSpec(ratio: 1.0, child: self.imageNode)
    return ratioSpec
  }
  
}
