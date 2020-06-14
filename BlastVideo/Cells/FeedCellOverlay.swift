//
//  FeedCellOverlay.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/13/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import Kingfisher
import PhotosUI

class FeedCellOverlay: ASDisplayNode {
    
    let options = PHLivePhotoBadgeOptions(arrayLiteral: .overContent)
    var badgeImage : UIImage?
    var badgeImageView : UIImageView?
    var badgeBaseView = UIView()
    let label = UILabel()
    var stackView : UIStackView?
    
    let userImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFill
        node.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return node
    }()
    
    let usernameNode: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.contentMode = .scaleAspectFill
//        node.borderColor = UIColor.gray.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    
    
    override init() {
        super.init()
        
    }
    
    override func didLoad() {
        super.didLoad()
        
        
    }
    
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
        
        let stack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start
            , children: [usernameNode])
        
        return stack
    }
    
}
