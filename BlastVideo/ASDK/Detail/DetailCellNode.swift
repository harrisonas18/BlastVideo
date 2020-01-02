//
//  DetailCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 3/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import AsyncDisplayKit
import ActiveLabel
import PhotosUI

class ProductCellNode: ASCellNode {
    
    // MARK: - Variables
    let detailNode: ASDetailNode
    
    // MARK: - Object life cycle
    init(post: Post, user: UserObject) {
        self.detailNode = ASDetailNode(post: post, user: user)
        super.init()
        self.selectionStyle = .none
        self.addSubnode(self.detailNode)
        self.neverShowPlaceholders = false
        self.placeholderEnabled = true
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: self.detailNode)
    }
    
}

class ASDetailNode: ASDisplayNode {
    
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
    
    let focusImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFill
        node.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return node
    }()
    
    //Set up Username Node
    let usernameNode: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    @objc func usernamePressed() {
        delegate?.pushUser(user: user)
    }
    
    var caption: ActiveTextNode
    
    let captionNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
        node.borderColor = UIColor.gray.cgColor
        node.borderWidth = 1.0
        return node
    }()
    
    //Set Up Timestamp node
    let timeStampNode: ASTextNode = {
        let node = ASTextNode()
        node.contentMode = .scaleAspectFill
        node.truncationMode = .byTruncatingTail
        return node
    }()
    
    //Set up Like Button
    let likeButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        
        node.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        return node
    }()
    
    //Set up Mute Button
    let muteButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        return node
    }()
    
    //Set up Share Button
    let shareButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        return node
    }()
    
    var isSelected : Bool = false
    @objc func likePressed() {
        isSelected.toggle()
        likeButtonNode.isSelected = isSelected
        if isSelected == true {
            likeButtonNode.setImage(UIImage(named: "starFilled"), for: .selected)
            Api.Favorites.addToFavorites(user: currentUserGlobal, post: post)
        } else {
            likeButtonNode.setImage(UIImage(named: "starOutline"), for: .normal)
            Api.Favorites.removeFromFavorites(user: currentUserGlobal, post: post)
        }
    }
    
    init(post: Post, user: UserObject) {
        self.post = post
        self.user = user
        self.caption = ActiveTextNode(text: post.caption ?? "", font: UIFont.systemFont(ofSize: 14), width: UIScreen.screenWidth())
        super.init()
        backgroundColor = .white
        //automaticallyManagesSubnodes = true
        addSubnode(livePhotoNode)
        addSubnode(usernameNode)
        addSubnode(muteButtonNode)
        addSubnode(shareButtonNode)
        addSubnode(likeButtonNode)
        addSubnode(caption)
        addSubnode(timeStampNode)
        self.placeholderEnabled = true
        let height = (UIScreen.screenWidth() / post.ratio!)
        livePhotoNode.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: height)
        
            
        
//        focusImageNode.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenWidth() / post.ratio!)
//        focusImageNode.url = URL(string: post.photoUrl!)
        usernameNode.setAttributedTitle(NSAttributedString(string: user.username?.lowercased() ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]), for: .normal)
//        let padding = (44.0 - usernameNode.bounds.size.height)/2.0
//        usernameNode.hitTestSlop = UIEdgeInsets(top: -padding, left: -10, bottom: -padding, right: -10)
        
        caption.labelNode?.attributedText = NSAttributedString(string: post.caption!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        caption.labelNode?.numberOfLines = 0
        caption.style.flexShrink = 1.0
        caption.style.flexGrow = 1.0
        
        
        if let timestamp = post.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let date = Date(timeIntervalSince1970: Double(timestamp))
            // US English Locale (en_US)
            dateFormatter.locale = Locale(identifier: "en_US")
            let timeText = dateFormatter.string(from: date)
            
            timeStampNode.attributedText = NSAttributedString(string: timeText.lowercased(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)])
        } else {
            print("No timestamp")
        }
        
        likeButtonNode.setImage(UIImage(named: "starOutline"), for: .normal)
        likeButtonNode.setImage(UIImage(named: "starFilled"), for: .selected)
        likeButtonNode.imageNode.contentMode = .scaleAspectFit
        likeButtonNode.addTarget(self, action: #selector(likePressed), forControlEvents: .touchUpInside)
        
        muteButtonNode.setImage(UIImage(named: "VolumeIcon"), for: .normal)
        muteButtonNode.setImage(UIImage(named: "MuteIcon"), for: .selected)
        muteButtonNode.imageNode.contentMode = .scaleAspectFit
        
        shareButtonNode.setImage(UIImage(named: "ShareIcon"), for: .normal)
        shareButtonNode.setImage(UIImage(named: "ShareIcon"), for: .selected)
        shareButtonNode.imageNode.contentMode = .scaleAspectFit
        
        usernameNode.addTarget(self, action: #selector(usernamePressed), forControlEvents: .touchUpInside)
        
        caption.labelNode?.handleHashtagTap({ (hashtag) in
            self.hashtagDelegate?.pushHashtag(hashtag: hashtag)
        })

    }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func didLoad() {
        super.didLoad()
        livePhotoNode.photoNode?.fetchLivePhoto(post: post, completion: {
            DispatchQueue.main.async {
               self.activityIndicator.stopAnimating()
               self.activityIndicator.removeFromSuperview()
            }
        })
        let date_start = Date()
        // Code to be executed
        print("Time: \(date_start)")
        // Create the Activity Indicator
        
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
            // Start the loading animation
        activityIndicator.startAnimating()
        
        loadFavButton()
        
    }
    
    func loadFavButton() {
        Api.Favorites.loadFavButton(post: post) { (buttonBool) in
            if buttonBool == true {
                self.likeButtonNode.isSelected = true
                self.isSelected = true
            } else {
                self.likeButtonNode.isSelected = false
                self.isSelected = false
            }
        }
        
    }
    
//    let options = PHLivePhotoBadgeOptions(arrayLiteral: .overContent)
//    var badgeImage : UIImage?
//    var badgeImageView : UIImageView?
//    var badgeBaseView = UIView(frame: CGRect(x: 8, y: 8, width: 75 , height: 50))
//    let label = UILabel()
//    var stackView : UIStackView?
//
//    func setUpBadgeView() {
//        badgeBaseView = UIView(frame: CGRect(x: 8, y: 8, width: 75 , height: 40))
//        badgeImageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 50, height: 50))
//
//        label.attributedText = NSAttributedString(string: "LIVE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//
//        let white = UIColor.white
//        let opaque = white.withAlphaComponent(0.75)
//        badgeBaseView.backgroundColor = opaque
//        badgeBaseView.layer.cornerRadius = 5.0
//
//        badgeImage = PHLivePhotoView.livePhotoBadgeImage(options: options)
//        badgeImageView?.contentMode = .scaleAspectFill
//        badgeImageView?.image = badgeImage
//
//        stackView = UIStackView(arrangedSubviews: [badgeImageView!, label])
//        stackView?.frame = CGRect(x: 0, y: 0, width: 75, height: 40)
//        stackView?.axis = .horizontal
//        stackView?.alignment = .center
//        stackView?.distribution = .fillProportionally
//
//        badgeBaseView.addSubview(stackView!)
//    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        // horizontal stack
        let iconStack = ASStackLayoutSpec.horizontal()
        iconStack.style.preferredLayoutSize.width = ASDimensionMake("30%")
        iconStack.alignItems = .center // center items vertically in horiz stack
        iconStack.justifyContent = .spaceBetween
        iconStack.children = [muteButtonNode, shareButtonNode, likeButtonNode]
        
        // horizontal stack
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalStack.alignItems = .center // center items vertically in horiz stack
        horizontalStack.justifyContent = .spaceBetween
        horizontalStack.children = [usernameNode, iconStack]
        
        let vertStack = ASStackLayoutSpec.vertical()
        vertStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        vertStack.alignItems = .start // center items vertically in horiz stack
        vertStack.justifyContent = .spaceBetween
        vertStack.spacing = 8.0
//        vertStack.style.flexShrink = 1.0
//        vertStack.style.flexGrow = 1.0
        
        if post.caption == "" {
            vertStack.children = [horizontalStack, timeStampNode]
        } else {
            vertStack.children = [horizontalStack, caption, timeStampNode]
        }
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0), child: vertStack)
        
        //let overlaySpec = ASOverlayLayoutSpec(child: focusImageNode, overlay: livePhotoNode)
        
        let finalSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0.0, justifyContent: .start, alignItems: .center, children: [livePhotoNode, insetSpec])
        
        return finalSpec
        
    }
}

