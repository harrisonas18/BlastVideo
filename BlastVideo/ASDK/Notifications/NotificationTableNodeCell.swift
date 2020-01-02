//
//  NotificationNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/28/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class NotificationTableNodeCell: ASCellNode {
        
    // MARK: - Variables
    let contentNode: NotificationTableNodeCellContent
    
    // MARK: - Object life cycle
    init(notification: PushNotification, user: UserObject? = nil) {
        self.contentNode = NotificationTableNodeCellContent(notification: notification, user: user)
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

class NotificationTableNodeCellContent: ASDisplayNode {
    
    // MARK: - Variables
    
    var notification : PushNotification {
        didSet {
            updateView()
        }
    }
    var user : UserObject? {
        didSet {
            setUpUserInfo()
        }
    }
    
    var delegate : PushUsernameDelegate?
    
    let userImgNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.shouldRenderProgressImages = false
        node.contentMode = .scaleAspectFill
        node.placeholderEnabled = true
        node.placeholderFadeDuration = 0.3
        node.cornerRadius = 25.0
        return node
    }()
    
    let usernameNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.isUserInteractionEnabled = true
        return node
    }()
    
    let notificationLabel: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        return node
    }()
    
    let timeStamp: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        return node
    }()
    
    let divider: ASDisplayNode = {
        let node = ASDisplayNode()
        node.style.preferredSize.height = 1.0
        node.style.preferredLayoutSize.width = ASDimensionMake("85%")
        node.backgroundColor = .lightGray
        return node
    }()
    
    
    
    @objc func segueToUserProfile(){
        //set up delegate to call viewcontroller navigation controller push
        guard (user != nil) else {
            print("user is nil")
            return
        }
        delegate?.pushUser(user: user!)
    }
    
    
    // MARK: - Object life cycle
    init(notification: PushNotification, user: UserObject?) {
        self.notification = notification
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        
        if user?.profileImageUrl != "" {
            userImgNode.url = URL(string: (user?.profileImageUrl!)!)
        } else {
            print("Placeholder")
            userImgNode.image = UIImage(named: "ProfilePlaceholder")
        }
        
        userImgNode.style.preferredSize = CGSize(width: 50, height: 50)
        
        usernameNode.attributedText = NSAttributedString(string: user?.username?.lowercased() ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        usernameNode.addTarget(self, action: #selector(segueToUserProfile), forControlEvents: .touchUpInside)
        let padding = (44.0 - usernameNode.bounds.size.height)/2.0
        usernameNode.hitTestSlop = UIEdgeInsets(top: -padding, left: -10, bottom: -padding, right: -10)
        
        notificationLabel.attributedText = NSAttributedString(string: "Started Following You", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .light)])
        
    }
    
    override func didLoad() {
        super.didLoad()
        userImgNode.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        setUpUserInfo()
        updateView()
    }
    
    func setUpUserInfo(){
        usernameNode.attributedText = NSAttributedString(string: user?.username ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        if let url = user?.profileImageUrl {
            print(url)
            userImgNode.url = URL(string: url)
        } else {
            print("Placeholder")
            userImgNode.image = UIImage(named: "ProfilePlaceholder")
        }
    }
    
    func updateView(){
        switch notification.type! {
            case "follow":
                notificationLabel.attributedText = NSAttributedString(string: "Started Following You", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .light)])
            default:
                print("t")
            }
            
        if let timestamp = notification.timestamp {
                print(timestamp)
                let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
                let now = Date()
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
                let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
                
                var timeText = ""
                if diff.second! <= 0 {
                    timeText = "Now"
                }
                if diff.second! > 0 && diff.minute! == 0 {
                    timeText = "\(diff.second!)s"
                }
                if diff.minute! > 0 && diff.hour! == 0 {
                    timeText = "\(diff.minute!)m"
                }
                if diff.hour! > 0 && diff.day! == 0 {
                    timeText = "\(diff.hour!)h"
                }
                if diff.day! > 0 && diff.weekOfMonth! == 0 {
                    timeText = "\(diff.day!)d"
                }
                if diff.weekOfMonth! > 0 {
                    timeText = "\(diff.weekOfMonth!)w"
                }
                
                timeStamp.attributedText = NSAttributedString(string: timeText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)])
            }
        isUserInteractionEnabled = true
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let vertStackSpec = ASStackLayoutSpec.vertical()
        vertStackSpec.spacing = 2.0
        vertStackSpec.justifyContent = .start
        vertStackSpec.alignItems = .start
        vertStackSpec.children = [usernameNode, notificationLabel]
        
        let finalStack = ASStackLayoutSpec.horizontal()
        finalStack.justifyContent = .start
        finalStack.alignItems = .center
        finalStack.spacing = 5.0
        finalStack.style.preferredLayoutSize.width = ASDimensionMake("92%")
        finalStack.children = [userImgNode, vertStackSpec]
        
        // horizontal stack
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horizontalStack.alignItems = .center // center items vertically in horiz stack
        horizontalStack.justifyContent = .spaceBetween
        horizontalStack.children = [finalStack, timeStamp]
        
        let vertStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 4.0, justifyContent: .start, alignItems: .end, children: [horizontalStack, divider])
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: horizontalStack)
        return inset
        
    }
    
}
