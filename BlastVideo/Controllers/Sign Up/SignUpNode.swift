//
//  SignUpNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/6/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol SignUpInfoDelegate {
    func getSignUpInfo(username: String, email: String, password: String)
}

class SignUpNode: ASDisplayNode {
    
    var delegate: EditPhotoDelegate?
    var signUpDelegate: SignUpInfoDelegate?
    
    let titleNode: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = false
        node.attributedText = NSAttributedString(string: "Sign Up to MyLive", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26.0, weight: .medium)])
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("30pt")
        return node
    }()
    
    let profImage: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = CGSize(width: 24, height: 24)
        node.image = #imageLiteral(resourceName: "addImage")
        node.contentMode = .scaleAspectFit
        node.clipsToBounds = true
        node.backgroundColor = .clear
        return node
    }()
    
    let profImageBack: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = CGSize(width: 96, height: 96)
        node.cornerRadius = 48.0
        node.clipsToBounds = true
        node.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        node.isUserInteractionEnabled = true
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    let usernameNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.returnKeyType = .next
        node.keyboardType = .emailAddress
        return node
    }()
    
    let usernameSeparator: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
        return node
    }()
    
    let emailNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.returnKeyType = .next
        node.keyboardType = .emailAddress
        return node
    }()
    
    let emailSeparator: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
        return node
    }()
    
    let passwordNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.attributedPlaceholderText = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.isUserInteractionEnabled = true
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.returnKeyType = .done
        node.textView.isSecureTextEntry = true
        return node
    }()
    
    let passwordSeparator: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
        return node
    }()
    
    let repeatPasswordNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.attributedPlaceholderText = NSAttributedString(string: "Repeat Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.isUserInteractionEnabled = true
        node.style.preferredSize.width = UIScreen.screenWidth()
        node.style.preferredSize.height = 22
        node.returnKeyType = .done
        node.textView.isSecureTextEntry = true
        return node
    }()
    
    let repeatPasswordSeparator: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("2pt")
        return node
    }()
    
    let signupButton: ASButtonNode = {
        let node = ASButtonNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: 50)
        node.backgroundColor = .systemPink
        node.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]), for: .normal)
        node.cornerRadius = 5.0
        node.isUserInteractionEnabled = true
        return node
    }()
    
    
    
    let toLoginNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.isUserInteractionEnabled = false
        node.attributedText = NSAttributedString(string: "Already have an account? Log in.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)])
        return node
    }()
    
    let arrowImage: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = CGSize(width: 12, height: 12)
        node.image = #imageLiteral(resourceName: "right-arrow")
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        signupButton.addTarget(self, action: #selector(signupButtonTapped), forControlEvents: .touchUpInside)
        profImageBack.addTarget(self, action: #selector(addPhotoTapped), forControlEvents: .touchUpInside)
        
    }
    
    override func didLoad() {
        super.didLoad()
        usernameNode.delegate = self
        passwordNode.delegate = self
        //passwordNode.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        
    }
    
    @objc func signupButtonTapped(){
        view.endEditing(true)
        print("Signup tapped")
        signUpDelegate?.getSignUpInfo(username: usernameNode.textView.text!, email: emailNode.textView.text!, password: passwordNode.textView.text!)
        
    }
    
    @objc func addPhotoTapped() {
        print("Add photo tapped")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushImagePicker"), object: nil)
        
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameNode.textView.text, !usernameNode.textView.text.isEmpty,
            let password = passwordNode.textView.text, !passwordNode.textView.text.isEmpty else {
                signupButton.isEnabled = false
                print("Button Not enabled")
                return
        }
        print("Button Enabled")
        signupButton.isEnabled = true
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //let profImageStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [profImage])
        let insetImg = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32), child: profImage)
        let imgOverlay = ASOverlayLayoutSpec.init(child: profImageBack, overlay: insetImg)
        
        let vertStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [titleNode])
        
        let usernameStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [usernameNode,usernameSeparator])
        
        let emailStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [emailNode,emailSeparator])
        
        let passwordStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [passwordNode,passwordSeparator])
        
        let repeatPasswordStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [repeatPasswordNode, repeatPasswordSeparator])
        
        let entryStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 30, justifyContent: .start, alignItems: .center, children: [imgOverlay, usernameStack, emailStack,  passwordStack, repeatPasswordStack])
        
        let upperStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 40, justifyContent: .start, alignItems: .start, children: [vertStack, entryStack])
        
        let upperFinal = ASStackLayoutSpec.init(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .center, children: [upperStack])
        
        let phoneStack = ASStackLayoutSpec.init(direction: .horizontal, spacing: 5, justifyContent: .spaceBetween, alignItems: .center, children: [toLoginNode, arrowImage])
        
        let lowerStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .center, children: [signupButton, phoneStack])
        
        let finalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [upperFinal, lowerStack])
        
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 8, bottom: 30, right: 8), child: finalStack)
        
        
    }
    
}

extension SignUpNode: ASEditableTextNodeDelegate {
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
        
        
        
        let textCount = editableTextNode.textView.text.count
        let countLeft = 140 - textCount
        
        delegate?.getCaptionText(text: editableTextNode.textView.text)
    }
    
    func editableTextNodeDidFinishEditing(_ editableTextNode: ASEditableTextNode) {
        
        switch editableTextNode {
        case usernameNode:
            passwordNode.becomeFirstResponder()
        case passwordNode:
            passwordNode.resignFirstResponder()
        default:
            break
        }
        
        
    }
    
    
}
