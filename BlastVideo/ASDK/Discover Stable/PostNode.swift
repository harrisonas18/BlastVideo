//
//  PostNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/2/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

class PostNode: ASCellNode {
    
    // MARK: - Variables
    let contentNode: DiscoverPostPhotoNode
    
    // MARK: - Object life cycle
    init(post: Post) {
        self.contentNode = DiscoverPostPhotoNode(post: post)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
        contentNode.style.width = ASDimensionMake("100%")
    }
    
    override func didLoad() {
        super.didLoad()
//        self.layer.borderColor = UIColor.containerBorderColor().cgColor
//        self.layer.borderWidth = 1.0
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: contentNode)
        return insets
    }
}

class DiscoverPostPhotoNode: ASDisplayNode {
    
    var post: Post
    
    let postImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFill
        node.placeholderEnabled = true
        node.style.maxWidth = ASDimensionMake(CGFloat(UIScreen.screenWidth() * 0.90))
        node.style.minWidth = ASDimensionMake(CGFloat(UIScreen.screenWidth() * 0.65))
        node.style.maxHeight = ASDimensionMake("375pt")
        node.defaultImage = (UIImage(named: "PlaceHolderImage"))
        return node
    }()
    
    init(post: Post) {
        self.post = post
        super.init()
        automaticallyManagesSubnodes = true
        postImageNode.url = URL(string: post.photoUrl ?? "" )
        postImageNode.defaultImage = (UIImage(named: "PlaceHolderImage"))
        postImageNode.style.preferredSize = CGSize(width: UIScreen.screenWidth() * 0.725, height: (UIScreen.screenWidth()/post.ratio!) * 0.725)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let vertStackSpec = ASStackLayoutSpec.vertical()
        vertStackSpec.spacing = 8.0
        vertStackSpec.justifyContent = .start
        vertStackSpec.alignItems = .start
        vertStackSpec.children = [postImageNode]
        
        let finalStack = ASStackLayoutSpec.vertical()
        finalStack.justifyContent = .start
        finalStack.child = vertStackSpec
        
        let num = Int.random(in: 1...2)
        
        if num == 1 {
            finalStack.alignItems = .start
        } else {
            finalStack.alignItems = .end
        }
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 7.5, right: 0), child: finalStack)
        return inset
    }
    
}

