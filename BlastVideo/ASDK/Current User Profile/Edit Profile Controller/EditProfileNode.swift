//
//  EditProfileNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 11/14/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import Kingfisher


protocol EditProfileDelegate {
    func updateProfileInfo(image: UIImage, name: String, bio: String)
}

class EditProfileNode: ASDisplayNode {
    
    var editProfileDelegate: EditProfileDelegate?
    
    let profImage: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = CGSize(width: 24, height: 24)
        node.image = #imageLiteral(resourceName: "addImage")
        node.contentMode = .scaleAspectFit
        node.clipsToBounds = true
        node.backgroundColor = .clear
        return node
    }()
    
    let profImageBack: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: 96, height: 96)
        node.cornerRadius = 48.0
        node.clipsToBounds = true
        node.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        node.isUserInteractionEnabled = true
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    let profChangeNode: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = false
        let font = UIFont.init(name: "Helvetica Neue", size: 16.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 16.0),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let attributedQuote = NSAttributedString(string: "Change Profile Image", attributes: attributes)
        node.attributedText = attributedQuote
        node.style.preferredSize.width = UIScreen.screenWidth()/2
        node.style.preferredSize.height = 22
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    let nameTitleNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.isUserInteractionEnabled = false
        return node
    }()
    
    let nameNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Add Your Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.returnKeyType = .next
        node.keyboardType = .emailAddress
        return node
    }()
    
    let nameSeparator: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
        return node
    }()
    
    let bioTitleNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Your Bio", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.isUserInteractionEnabled = false
        return node
    }()
    
    let bioNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Add a Bio", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.returnKeyType = .done
        return node
    }()
    
    let bioSeparator: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
        return node
    }()
    
//    let emailTitleNode: ASEditableTextNode = {
//        let node = ASEditableTextNode()
//        node.style.flexGrow = 1.0
//        node.attributedPlaceholderText = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
//        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
//        node.style.preferredSize.width = UIScreen.screenWidth()
//        node.style.preferredSize.height = 22
//        node.returnKeyType = .next
//        node.keyboardType = .emailAddress
//        return node
//    }()
//
//    let emailNode: ASEditableTextNode = {
//        let node = ASEditableTextNode()
//        node.style.flexGrow = 1.0
//        node.attributedPlaceholderText = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
//        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
//        node.style.preferredSize.width = UIScreen.screenWidth()
//        node.style.preferredSize.height = 22
//        node.returnKeyType = .next
//        node.keyboardType = .emailAddress
//        return node
//    }()
//
//    let emailSeparator: ASDisplayNode = {
//        let node = ASDisplayNode()
//        node.backgroundColor = .lightGray
//        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
//        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
//        return node
//    }()
    
    var user: UserObject?
    init(user: UserObject) {
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        profImageBack.addTarget(self, action: #selector(addPhotoTapped), forControlEvents: .touchUpInside)
        if user.profileImageUrl != nil {
            profImage.isHidden = true
        }
        profImageBack.url = URL(string: user.profileImageUrl ?? "")
        profImageBack.defaultImage = UIImage(named: "ProfilePlaceholder")
        nameNode.attributedText = NSAttributedString(string: user.realName ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        bioNode.attributedText = NSAttributedString(string: user.bio ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
    }
    
    @objc func addPhotoTapped() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushImagePicker"), object: nil)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insetImg = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32), child: profImage)
        let imgOverlay = ASOverlayLayoutSpec.init(child: profImageBack, overlay: insetImg)
        
        let centerSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: profChangeNode)
        
        let imgStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [imgOverlay, centerSpec])
        
        let usernameStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [nameTitleNode, nameNode, nameSeparator])
        
        //let emailStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [emailTitleNode, emailNode, emailSeparator])
        
        let bioStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [bioTitleNode, bioNode, bioSeparator])
        
        let entryStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 30, justifyContent: .start, alignItems: .center, children: [imgStack, usernameStack, bioStack])
        
        let upperStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 40, justifyContent: .start, alignItems: .start, children: [entryStack])
        
        let upperFinal = ASStackLayoutSpec.init(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .center, children: [upperStack])
        
        let finalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [upperFinal])
        
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 8, bottom: 30, right: 8), child: finalStack)
        
    }
    
}
extension EditProfileNode: ASEditableTextNodeDelegate {
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            editableTextNode.resignFirstResponder()
        }
        
        if range.length + range.location > editableTextNode.textView.text.count {
            return false
        }
        
        let newLength = editableTextNode.textView.text.count + text.count - range.length
        return newLength <= 140
    }
    
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        
        switch editableTextNode {
        case nameNode:
            let textCount = editableTextNode.textView.text.count
            _ = 140 - textCount
        case bioNode:
            let textCount = editableTextNode.textView.text.count
            _ = 140 - textCount
        default:
            break
        }
        
        let textCount = editableTextNode.textView.text.count
        _ = 140 - textCount
        
        //delegate?.getCaptionText(text: editableTextNode.textView.text)
    }
    
    func editableTextNodeDidFinishEditing(_ editableTextNode: ASEditableTextNode) {
        
//        switch editableTextNode {
//        case usernameNode:
//            passwordNode.becomeFirstResponder()
//        case passwordNode:
//            passwordNode.resignFirstResponder()
//        default:
//            break
//        }
        
        
    }
    
    
}
