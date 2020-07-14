//
//  DiscoverCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/14/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DiscoverCellNode: ASCellNode {
        
    // MARK: - Variables
    let contentNode: DiscoverContentNode
    
    // MARK: - Object life cycle
    init(post: Post, user: UserObject? = nil) {
        self.contentNode = DiscoverContentNode(post: post, user: user)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
        contentNode.style.width = ASDimensionMake("100%")
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: contentNode)
        return insets
    }
}

class DiscoverContentNode: ASDisplayNode {
    
    // MARK: - Variables
    
    let post : Post
    let user : UserObject?
    var delegate : PushUsernameDelegate?
    
    let postImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFill
        node.placeholderEnabled = true
        node.style.maxWidth = ASDimensionMake(CGFloat(UIScreen.screenWidth() * 0.90))
        node.style.minWidth = ASDimensionMake(CGFloat(UIScreen.screenWidth() * 0.65))
        node.style.maxHeight = ASDimensionMake("375pt")
        node.placeholderFadeDuration = 0.5
        return node
    }()
    
    let usernameNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.isUserInteractionEnabled = true
        return node
    }()
    
    @objc func segueToUserProfile(){
        print("Username tapped")
        //set up delegate to call viewcontroller navigation controller push
        guard (user != nil) else {
            print("user is nil")
            return
        }
        print(user?.username)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushProfileController"), object: nil, userInfo: ["user": user!])
        delegate?.pushUser(user: user!)
    }
    
    
    // MARK: - Object life cycle
    init(post: Post, user: UserObject?) {
        
        self.post = post
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        
        postImageNode.url = URL(string: post.photoUrl ?? "" )
        postImageNode.style.preferredSize = CGSize(width: UIScreen.screenWidth() * 0.725, height: (UIScreen.screenWidth()/post.ratio!) * 0.725)
        
        usernameNode.attributedText = NSAttributedString(string: user?.username?.lowercased() ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        usernameNode.addTarget(self, action: #selector(segueToUserProfile), forControlEvents: .touchUpInside)
        let padding = (44.0 - usernameNode.bounds.size.height)/2.0
        usernameNode.hitTestSlop = UIEdgeInsets(top: -padding, left: -10, bottom: -padding, right: -10)
        
    }
    
    override func didLoad() {
        super.didLoad()
        postImageNode.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let vertStackSpec = ASStackLayoutSpec.vertical()
        vertStackSpec.spacing = 8.0
        vertStackSpec.justifyContent = .start
        vertStackSpec.alignItems = .start
        vertStackSpec.children = [postImageNode, usernameNode]
        
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
