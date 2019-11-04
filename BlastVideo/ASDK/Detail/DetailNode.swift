//
//  File.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/17/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//


import AsyncDisplayKit
import PhotosUI

class ASDetailNode: ASDisplayNode {
    
    var post: Post
    
    let livePhotoNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    init(post: Post) {
        self.post = post
        
        super.init()
        backgroundColor = .white
        addSubnode(livePhotoNode)
        livePhotoNode.url = URL(string: post.photoUrl!)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let screen = UIScreen.main.bounds
        let width = screen.width
        let height = (width / post.ratio!) 
        livePhotoNode.style.preferredSize = CGSize(width: width, height: height)
        
        return ASWrapperLayoutSpec(layoutElement: livePhotoNode)
    }
}
