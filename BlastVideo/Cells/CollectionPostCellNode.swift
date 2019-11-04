//
//  CollectionPostCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import Kingfisher

class CollectionPostCellNode: ASCellNode {
    
    // MARK: - Variables
    
    public let contentNode: PostContentNode
    
    // MARK: - Object life cycle
    
    init(post: Post, user: UserObject? = nil) {
        self.contentNode = PostContentNode(post: post, user: user)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
//        self.layer.borderColor = UIColor.containerBorderColor().cgColor
//        self.layer.borderWidth = 1.0
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), child: contentNode)
        return insets
    }
    
}

class PostContentNode: ASDisplayNode {
    
    // MARK: - Variables
    
    let post : Post
    let user : UserObject?
    
    let postImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFit
        node.placeholderEnabled = true
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
//    let postImageNode: KFImageNode = {
//        let node = KFImageNode(size: CGSize(width: 300, height: 300))
//        node.contentMode = .scaleAspectFit
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
//        return node
//    }()
    
    let userImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.style.preferredSize = CGSize(width: 25.0, height: 25.0)
        node.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return node
    }()
    
    let usernameNode: ASTextNode = {
        let node = ASTextNode()
        node.style.width = ASDimensionMake("70%")
        node.style.flexShrink = 1
        node.isUserInteractionEnabled = true
        return node
    }()
    
    @objc func segueToUserProfile(){
        print("username tapped")
        //set up delegate to call viewcontroller navigation controller push
    }
    
    
    // MARK: - Object life cycle
    init(post: Post, user: UserObject? = nil) {
        
        self.post = post
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        
        postImageNode.url = URL(string: post.photoUrl ?? "" )
        postImageNode.defaultImage = (UIImage(named: "PlaceHolderImage"))
        
//        let resource = URL(string: post.photoUrl!)
//        let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))
//
//        postImageNode.imageView?.kf.indicatorType = .activity
//        postImageNode.imageView?.kf.setImage(with: resource!,
//                                             placeholder: nil,
//                                             options: [
//                                                .processor(processor),
//                                                .scaleFactor(UIScreen.main.scale),
//                                                .cacheOriginalImage
//                                                ],
//                                             progressBlock: nil,
//                                             completionHandler: { (result) in
//                                                switch result {
//                                                case .success(let value):
//                                                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                                                case .failure(let error):
//                                                    print("Job failed: \(error.localizedDescription)")
//                                                }
//        })
        
        userImageNode.url = URL(string: user?.profileImageUrl ?? "" )
        
        usernameNode.attributedText = NSAttributedString(string: user?.username?.lowercased() ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        
        usernameNode.addTarget(self, action: #selector(segueToUserProfile), forControlEvents: .touchUpInside)
        let padding = (44.0 - usernameNode.bounds.size.height)/2.0
        usernameNode.hitTestSlop = UIEdgeInsets(top: -padding, left: -10, bottom: -padding, right: -10)
        
    }
    
    override func didLoad() {
        super.didLoad()
//        self.layer.borderColor = UIColor.containerBorderColor().cgColor
//        self.layer.borderWidth = 1.0
        
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let ratio = 1.0 / post.ratio!
        let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: self.postImageNode)
        
        ratioSpec.style.preferredLayoutSize.height = ASDimensionMake("75%")
        ratioSpec.style.preferredLayoutSize.width = ASDimensionMake("100%")
        ratioSpec.style.maxHeight = ASDimensionMake("300pt")
        
        let horizontalSpec = ASStackLayoutSpec.horizontal()
        horizontalSpec.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalSpec.alignItems = .end // center items vertically in horiz stack
        horizontalSpec.justifyContent = .start
        horizontalSpec.spacing = 8.0
        horizontalSpec.children = [userImageNode, usernameNode]
        
        //let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: horizontalSpec)
        
        let vertStackSpec = ASStackLayoutSpec.vertical()
        vertStackSpec.spacing = 8.0
        vertStackSpec.justifyContent = .end
        vertStackSpec.alignItems = .center
        
        if user == nil {
            vertStackSpec.children = [ratioSpec]
        } else {
            vertStackSpec.children = [ratioSpec]
        }

        return vertStackSpec
        
    }
    
}
