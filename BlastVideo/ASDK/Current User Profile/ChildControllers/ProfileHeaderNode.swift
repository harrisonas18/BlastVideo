//
//  DetailCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 3/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import AsyncDisplayKit

class ProfileHeaderNode: ASDisplayNode {
    
    // MARK: - Variables
    
    let contentNode: ProfileContentNode
    // MARK: - Object life cycle
    
    override init() {
        self.contentNode = ProfileContentNode()
        super.init()
        self.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: 200)
        self.addSubnode(self.contentNode)
        
    }
    
    override func didLoad() {
        super.didLoad()
        self.backgroundColor = .blue

    }
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0), child: self.contentNode)
    }
    
}

class ProfileContentNode: ASDisplayNode {
    
    var delegate: UserProfileHeaderDelegate?
    
    let userImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.contentMode = .scaleAspectFill
        node.shouldRenderProgressImages = false
        node.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return node
    }()
    
    let usernameNode: ASTextNode = {
        let node = ASTextNode()
        node.contentMode = .scaleAspectFill
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        return node
    }()
    
    let userBioNode: ASTextNode = {
        let node = ASTextNode()
        node.contentMode = .scaleAspectFill
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        return node
    }()
    
    let followButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 100.0, height: 50.0)
        node.borderColor = UIColor.blue.cgColor
        node.borderWidth = 1
        node.setTitle("Follow", with: UIFont.boldSystemFont(ofSize: 16), with: .blue, for: .normal) 
        return node
    }()
    
    var user: UserObject = UserObject()
    override init() {
        //self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        usernameNode.attributedText = NSAttributedString(string: user.username ?? "Username" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        userBioNode.attributedText = NSAttributedString(string: "VT" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
        userImageNode.url = URL(string: user.profileImageUrl ?? "")
        
    }
    
    override func didLoad() {
        super.didLoad()
        self.backgroundColor = .blue
        self.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: 200)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        //Vertical Stack
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        verticalStack.alignItems = .start
        verticalStack.justifyContent = .start
        verticalStack.spacing = 6.0
        verticalStack.children = [usernameNode, userBioNode, followButtonNode]
        
        //Horizontal Stack
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalStack.alignItems = .center // center items vertically in horiz stack
        horizontalStack.justifyContent = .start
        horizontalStack.spacing = 6.0
        horizontalStack.children = [userImageNode, verticalStack]
        
        let insetSpec = ASInsetLayoutSpec()
        insetSpec.insets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        insetSpec.child = horizontalStack
        
        return insetSpec
        
    }
}

