//
//  DetailCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 3/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import AsyncDisplayKit

class ProfileHeaderNode: ASCellNode {
    
    // MARK: - Variables
    
    let contentNode: ProfileContentNode
    // MARK: - Object life cycle
    
    init(user: UserObject) {
        self.contentNode = ProfileContentNode()
        super.init()
        self.selectionStyle = .none
        self.addSubnode(self.contentNode)

    }
    
    override func didLoad() {
        super.didLoad()
        

    }
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0), child: self.contentNode)
    }
    
}

class ProfileContentNode: ASDisplayNode {
    
    var delegate: UserProfileHeaderDelegate?
    
    let userImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.contentMode = .scaleAspectFill
        node.shouldRenderProgressImages = false
        node.style.preferredSize = CGSize(width: 80.0, height: 80.0)
        node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
//        node.borderWidth = 2.0
//        node.borderColor = UIColor.white.cgColor
//        node.shadowColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
//        node.shadowOpacity = 0.5
//        node.shadowRadius = 4.0
//        node.shadowOffset = CGSize(width: 0, height: 0)
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
    
    let userDescriptionNode: ASTextNode = {
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
    
    let segmentControl = ASDisplayNode { () -> UISegmentedControl in
        let view = UISegmentedControl(items: ["Posts","Favorites"])
        view.tintColor = .clear
        view.backgroundColor = .clear
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(selectedIndex(_:)), for: .valueChanged)
        view.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        view.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
        return view
    }
    
    let segmentBar : ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .black
        node.style.height = ASDimensionMake("1pt")
        node.style.width = ASDimensionMake("50%")
        return node
    }()
    
    //MARK:- TargetAction
    @objc func selectedIndex(_ sender: UISegmentedControl){
        
        let index = sender.selectedSegmentIndex
        
        switch index {
            
        case 0: // this means the first segment was chosen
            delegate?.trackSelectedIndex(0)
            UIView.animate(withDuration: 0.3) {
                self.segmentBar.frame.origin.x = ((self.segmentControl.frame.width / CGFloat(2)) * CGFloat(index)) + 16
            }
            break
            
        case 1: // this means the middle segment was chosen
            delegate?.trackSelectedIndex(1)
            UIView.animate(withDuration: 0.3) {
                self.segmentBar.frame.origin.x = ((self.segmentControl.frame.width / CGFloat(2)) * CGFloat(index)) + 16
            }
            break
            
        default:
            break
        }
    }
    
    var user: UserObject = UserObject()
    override init() {
        //self.user = user
        
        super.init()
        automaticallyManagesSubnodes = true
        usernameNode.attributedText = NSAttributedString(string: user.username ?? "Username" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        userDescriptionNode.attributedText = NSAttributedString(string: "VT" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
        
        userImageNode.url = URL(string: user.profileImageUrl ?? "")
        
        segmentControl.style.width = ASDimensionMake("100%")
        segmentControl.style.height = ASDimensionMake("35pt")
        
    }
    
    override func didLoad() {
        super.didLoad()
//        self.backgroundColor = .white
//        self.clipsToBounds = true
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 5.0
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //Horizontal Stack
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalStack.alignItems = .center // center items vertically in horiz stack
        horizontalStack.justifyContent = .start
        horizontalStack.spacing = 12.0
        horizontalStack.children = [userImageNode, usernameNode]
        
        //Vertical Stack
        let segmentStack = ASStackLayoutSpec.vertical()
        segmentStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        segmentStack.alignItems = .start
        segmentStack.justifyContent = .start
        segmentStack.children = [segmentControl, segmentBar]
        
        let horizontalButtonStack = ASStackLayoutSpec.horizontal()
        horizontalButtonStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalButtonStack.alignItems = .center // center items vertically in horiz stack
        horizontalButtonStack.justifyContent = .spaceBetween
        horizontalButtonStack.children = [segmentStack]

        //Vertical Stack
        let outerVerticalStack = ASStackLayoutSpec.vertical()
        outerVerticalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        outerVerticalStack.alignItems = .start
        outerVerticalStack.justifyContent = .start
        outerVerticalStack.spacing = 8.0
        outerVerticalStack.children = [horizontalStack, userDescriptionNode]
        
        let insetSpec = ASInsetLayoutSpec()
        insetSpec.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        insetSpec.child = outerVerticalStack
        
        return insetSpec
        
    }
}

