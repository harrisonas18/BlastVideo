//
//  NewDiscoverFullCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/17/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import Kingfisher
import PhotosUI

class NewDiscoverFullCell: ASCellNode {
    
    // MARK: - Variables
    
    public let contentNode: NewDiscoverFullCellContent
    
    // MARK: - Object life cycle
    
    init(post: Post, user: UserObject? = nil) {
        self.contentNode = NewDiscoverFullCellContent(post: post, user: user!)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1.0
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: contentNode)
        return insets
    }
    
}

class NewDiscoverFullCellContent: ASDisplayNode {
    
    var delegate: PushUsernameDelegate?
    var hashtagDelegate: PushHashtagDelegate?
    
    //Variables
    var post: Post
    var user: UserObject
    //var livePhoto: PHLivePhoto?
    
    let livePhotoNode: LivePhotoNode = {
        let node = LivePhotoNode(height: UIScreen.screenWidth(), width: UIScreen.screenWidth())
        node.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        node.placeholderEnabled = true
        return node
    }()
    
    var feedOverlay: NewFeedCellOverlay?

    
    init(post: Post, user: UserObject) {
        self.post = post
        self.user = user
        feedOverlay = NewFeedCellOverlay(post: post, user: user)
        super.init()
        backgroundColor = .white
        //automaticallyManagesSubnodes = true
        addSubnode(livePhotoNode)
        addSubnode(feedOverlay!)
        self.placeholderEnabled = true
        livePhotoNode.style.height = ASDimensionMake("\(post.ratio!*UIScreen.screenHeight())pt")
        livePhotoNode.style.flexGrow = 1.0

    }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func didLoad() {
        super.didLoad()
        
        print("Did load called")
        livePhotoNode.photoNode?.fetchLivePhoto(post: post, completion: {
            DispatchQueue.main.async {
                self.badgeBaseView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
        })
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
        }
        let x = (UIScreen.screenWidth()/2)-20
        let y = ((UIScreen.screenWidth() / post.ratio!)/2)-20
        print(x,y)
        activityIndicator.frame = CGRect(x: x, y: y, width: 40, height: 40)
        // Add it to the view where you want it to appear
        self.livePhotoNode.photoNode?.addSubview(activityIndicator)
        self.livePhotoNode.photoNode?.addSubview(badgeBaseView)
            // Start the loading animation
        activityIndicator.startAnimating()
    
        setUpBadgeView()
        
    }
    
    
    let options = PHLivePhotoBadgeOptions(arrayLiteral: .overContent)
    var badgeImage : UIImage?
    var badgeImageView : UIImageView?
    var badgeBaseView = UIView()
    let label = UILabel()
    var stackView : UIStackView?

    func setUpBadgeView() {
        let white = UIColor.white
        let opaque = white.withAlphaComponent(0.75)
        
        
        badgeBaseView.backgroundColor = opaque
        badgeBaseView.layer.cornerRadius = 5.0

        label.attributedText = NSAttributedString(string: "LIVE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        label.textAlignment = .center
        badgeImage = PHLivePhotoView.livePhotoBadgeImage(options: options)
        
        let image = badgeImage?.imageWithColor(color1: .darkGray)
        badgeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        badgeImageView?.contentMode = .scaleAspectFill
        badgeImageView?.image = image

        stackView = UIStackView(arrangedSubviews: [badgeImageView!, label])
        stackView?.axis = .horizontal
        stackView?.alignment = .center
        stackView?.distribution = .fillProportionally
        
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        badgeBaseView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        badgeBaseView.addSubview(stackView!)
        
        NSLayoutConstraint.activate([
            badgeBaseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            badgeBaseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            badgeBaseView.widthAnchor.constraint(equalToConstant: 65),
            badgeBaseView.heightAnchor.constraint(equalToConstant: 25),
            
            (stackView?.centerXAnchor.constraint(equalTo: badgeBaseView.centerXAnchor, constant: 0))!,
            (stackView?.centerYAnchor.constraint(equalTo: badgeBaseView.centerYAnchor, constant: 0))!,
            (stackView?.widthAnchor.constraint(equalToConstant: 55))!,
            (stackView?.heightAnchor.constraint(equalToConstant: 25))!,
            
            label.widthAnchor.constraint(equalToConstant: 35),
            label.heightAnchor.constraint(equalToConstant: 25),
            
            
            
        ])
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let feedOverInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: UIScreen.screenHeight()*0.60, left: 0, bottom: 0, right: 0), child: feedOverlay!)
        
        let overlay = ASOverlayLayoutSpec.init(child: livePhotoNode, overlay: feedOverInsetSpec)
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: overlay)
                
        let finalSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [insetSpec])
        
        return finalSpec
        
    }
}
