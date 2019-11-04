//
//  HashtagCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit


class HashtagCellNode: ASCellNode {
    
    let detailNode: HashtagDetailNode
    
    init(post: Post, user: UserObject) {
        self.detailNode = HashtagDetailNode(post: post, user: user)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: detailNode)
    }
    
}

class HashtagDetailNode: ASDisplayNode {
    
    //Variables
    var post: Post
    var user: UserObject
    
    let focusImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFill
        node.placeholderEnabled = true
        return node
    }()
    
    let nameLabelNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    init(post: Post, user: UserObject) {
        self.post = post
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        
        nameLabelNode.style.preferredSize = CGSize(width: UIScreen.screenWidth()/2, height: 25.0)
        
        focusImageNode.style.preferredSize = CGSize(width: UIScreen.screenWidth()/3, height: (UIScreen.screenWidth() / post.ratio!)/3)
        focusImageNode.url = URL(string: post.photoUrl!)
        
        
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let vertStack = ASStackLayoutSpec.vertical()
        vertStack.alignItems = .start // center items vertically in horiz stack
        vertStack.justifyContent = .spaceBetween
        vertStack.spacing = 8.0
        
        vertStack.children = [focusImageNode, nameLabelNode]
        vertStack.style.flexGrow = 1.0
        vertStack.style.flexShrink = 1.0
        
        return ASInsetLayoutSpec(insets: .zero, child: vertStack)
    }
    
}
