//
//  ViewProfileHeader.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 4/23/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import AsyncDisplayKit

class ViewProfileHeader: ASCellNode {
    
    // MARK: - Variables
    private let contentNode: ViewProfileContentHeader
    
    // MARK: - Object life cycle
    override init() {
        self.contentNode = ViewProfileContentHeader()
        super.init()
        self.selectionStyle = .none
        self.addSubnode(self.contentNode)
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: self.contentNode)
    }
    
}

class ViewProfileContentHeader: ASDisplayNode {
    
    let userImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return node
    }()
    
    let usernameNode: ASTextNode = {
        let node = ASTextNode()
        node.contentMode = .scaleAspectFill
        node.borderColor = UIColor.black.cgColor
        node.borderWidth = 1
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        return node
    }()
    
    let userDescriptionNode: ASTextNode = {
        let node = ASTextNode()
        node.contentMode = .scaleAspectFill
        node.borderColor = UIColor.black.cgColor
        node.borderWidth = 1
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
    
    let segmentControl = ASDisplayNode { () -> UISegmentedControl in
        let view = UISegmentedControl(items: ["Posts","Favorites"])
        view.selectedSegmentIndex = 0
        return view
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        usernameNode.attributedText = NSAttributedString(string: "Harrison Senesac" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        
        userDescriptionNode.attributedText = NSAttributedString(string: "VT" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //Horizontal Stack
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalStack.alignItems = .center // center items vertically in horiz stack
        horizontalStack.justifyContent = .start
        horizontalStack.spacing = 12.0
        horizontalStack.children = [userImageNode, usernameNode]
        
        let horizontalButtonStack = ASStackLayoutSpec.horizontal()
        horizontalButtonStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalButtonStack.alignItems = .center // center items vertically in horiz stack
        horizontalButtonStack.justifyContent = .spaceBetween
        horizontalButtonStack.children = [segmentControl]
        
        //Vertical Stack
        let outerVerticalStack = ASStackLayoutSpec.vertical()
        outerVerticalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        outerVerticalStack.alignItems = .start
        outerVerticalStack.justifyContent = .start
        outerVerticalStack.spacing = 8.0
        outerVerticalStack.children = [horizontalStack, userDescriptionNode, horizontalButtonStack ]
        
        let insetSpec = ASInsetLayoutSpec()
        insetSpec.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        insetSpec.child = outerVerticalStack
        
        return insetSpec
        
    }
}


