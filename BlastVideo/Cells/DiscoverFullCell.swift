//
//  DiscoverFullCell.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
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
import PhotosUI

class DiscoverFullCell: ASCellNode {
    
    // MARK: - Variables
    
    public let contentNode: DiscoverFullCellContent
    
    // MARK: - Object life cycle
    
    init(post: Post, user: UserObject? = nil) {
        self.contentNode = DiscoverFullCellContent(post: post, user: user!)
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

class DiscoverFullCellContent: ASDisplayNode {
    
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
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    @objc func usernamePressed() {
        delegate?.pushUser(user: user)
    }
    
    var caption: ActiveTextNode
    
    let captionNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    //Set Up Timestamp node
    let timeStampNode: ASTextNode = {
        let node = ASTextNode()
        node.contentMode = .scaleAspectFill
        node.truncationMode = .byTruncatingTail
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    //Set up Like Button
    let likeButtonNode: ASButtonNode = {
        let node = ASButtonNode()
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        node.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    //Set up Mute Button
    let muteButtonNode: ASButtonNode = {
        let node = ASButtonNode()
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        node.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    var isMuted : Bool = false
    @objc func mutePressed() {
        isSelected.toggle()
        muteButtonNode.isSelected = isSelected
        if isSelected == true {
            muteButtonNode.setImage(UIImage(named: "MuteIcon"), for: .selected)
        } else {
            muteButtonNode.setImage(UIImage(named: "VolumeIcon"), for: .normal)
        }
    }
    
    //Set up Share Button
    let shareButtonNode: ASButtonNode = {
        let node = ASButtonNode()
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        node.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        node.contentMode = .scaleAspectFill
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
        
        usernameNode.setAttributedTitle(NSAttributedString(string: user.username?.lowercased() ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0)]), for: .normal)
//        let padding = (44.0 - usernameNode.bounds.size.height)/2.0
//        usernameNode.hitTestSlop = UIEdgeInsets(top: -padding, left: -10, bottom: -padding, right: -10)
        
        caption.labelNode?.attributedText = NSAttributedString(string: post.caption ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
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
        muteButtonNode.addTarget(self, action: #selector(mutePressed), forControlEvents: .touchUpInside)
        
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
        
        loadFavButton()
        setUpBadgeView()
        
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
        
        // horizontal stack
        let iconStack = ASStackLayoutSpec.horizontal()
        //iconStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        iconStack.alignItems = .center // center items vertically in horiz stack
        iconStack.justifyContent = .spaceBetween
        iconStack.spacing = 15.0
        iconStack.children = [shareButtonNode, likeButtonNode]
        //iconStack.style.flexGrow = 1.0
        
        // horizontal stack
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        //horizontalStack.style.preferredSize.width = UIScreen.screenWidth()
        horizontalStack.alignItems = .center // center items vertically in horiz stack
        horizontalStack.justifyContent = .spaceBetween
        horizontalStack.children = [usernameNode, iconStack]
        //horizontalStack.spacing = 400.0
        horizontalStack.style.flexGrow = 1.0
        
        let vertStack = ASStackLayoutSpec.vertical()
        vertStack.style.preferredSize.height = 70.0
        vertStack.style.preferredSize.width = UIScreen.screenWidth()
        vertStack.alignItems = .start // center items vertically in horiz stack
        vertStack.justifyContent = .spaceBetween
        vertStack.spacing = 8.0
        //vertStack.style.flexShrink = 1.0
        //vertStack.style.flexGrow = 1.0
        
        
        if post.caption == "" {
            vertStack.children = [horizontalStack, timeStampNode]
        } else {
            vertStack.children = [horizontalStack, caption, timeStampNode]
        }
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0), child: vertStack)
        
        //let overlaySpec = ASOverlayLayoutSpec(child: focusImageNode, overlay: livePhotoNode)
        
        let finalSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [livePhotoNode, insetSpec])
        
        return finalSpec
        
    }
}
