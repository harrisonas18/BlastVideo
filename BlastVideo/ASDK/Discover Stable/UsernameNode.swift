//
//  UsernameNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/2/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

class UsernameNode: ASCellNode {
    
    // MARK: - Variables
    let contentNode: UsernameContentNode
    
    // MARK: - Object life cycle
    init(user: UserObject) {
        self.contentNode = UsernameContentNode(user: user)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
        contentNode.style.width = ASDimensionMake("100%")
    }
    
    override func didLoad() {
        super.didLoad()
        self.layer.borderColor = UIColor.containerBorderColor().cgColor
        self.layer.borderWidth = 1.0
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: contentNode)
        return insets
    }
}

class UsernameContentNode: ASDisplayNode {
    
    var user: UserObject
    var delegate: PushUsernameDelegate?
    
    let usernameNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.isUserInteractionEnabled = true
        return node
    }()
    
    @objc func segueToUserProfile(){
        //set up delegate to call viewcontroller navigation controller push
        delegate?.pushUser(user: user)
    }
    
    init(user: UserObject) {
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        usernameNode.attributedText = NSAttributedString(string: user.username?.lowercased() ?? "" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        
        usernameNode.addTarget(self, action: #selector(segueToUserProfile), forControlEvents: .touchUpInside)
        
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let vertStackSpec = ASStackLayoutSpec.vertical()
        vertStackSpec.spacing = 8.0
        vertStackSpec.justifyContent = .start
        vertStackSpec.alignItems = .start
        vertStackSpec.children = [usernameNode]
        
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

