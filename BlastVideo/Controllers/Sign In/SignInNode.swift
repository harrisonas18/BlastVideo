//
//  SignInNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/6/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol SignInInfoDelegate {
    func getSignInInfo(username: String, password: String)
}

class SignInNode: ASDisplayNode {
    
    var delegate: EditPhotoDelegate?
    var signInDelegate: SignInInfoDelegate?
    
    let titleNode: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = false
        node.attributedText = NSAttributedString(string: "Login to MyLive", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26.0, weight: .medium)])
        node.style.preferredLayoutSize.width = ASDimensionMake("95%")
        node.style.preferredLayoutSize.height = ASDimensionMake("30pt")
        return node
    }()
    
    let usernameNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.style.flexGrow = 1.0
        node.attributedPlaceholderText = NSAttributedString(string: "Username or email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
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
    
    let forgotPasswordNode: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = true
        //node.attributedText = NSAttributedString(string: "Forgot Password? We can help", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let loginButton: ASButtonNode = {
        let node = ASButtonNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: 50)
        node.backgroundColor = .systemPink
        node.setAttributedTitle(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]), for: .normal)
        node.cornerRadius = 5.0
        node.isUserInteractionEnabled = true
        return node
    }()
    
    @objc func loginButtonTapped(){
        view.endEditing(true)
        print("Login tapped")
        signInDelegate?.getSignInInfo(username: usernameNode.textView.text!, password: passwordNode.textView.text!)
        
    }
    
    let phoneIcon: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = CGSize(width: 20, height: 20)
        node.cornerRadius = 12.0
        node.borderColor = UIColor.black.cgColor
        node.borderWidth = 2.0
        node.image = #imageLiteral(resourceName: "call-answer")
        
        return node
    }()
    
    let viaPhoneNumberText: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.isUserInteractionEnabled = false
        node.attributedText = NSAttributedString(string: "Login Via Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)])
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
        loginButton.addTarget(self, action: #selector(loginButtonTapped), forControlEvents: .touchUpInside)
        let string1 = NSAttributedString(string: "Forgot Password? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        let string2 = NSAttributedString(string: "We can Help.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        let final = NSMutableAttributedString()
        final.append(string1)
        final.append(string2)
        forgotPasswordNode.attributedText = final
    }
    
    override func didLoad() {
        super.didLoad()
        usernameNode.delegate = self
        passwordNode.delegate = self
        //passwordNode.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        
    }
    
    
    @objc func textFieldDidChange() {
        guard let username = usernameNode.textView.text, !usernameNode.textView.text.isEmpty,
            let password = passwordNode.textView.text, !passwordNode.textView.text.isEmpty else {
                loginButton.isEnabled = false
                print("Button Not enabled")
                return
        }
        print("Button Enabled")
        loginButton.isEnabled = true
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let vertStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [titleNode])
        
        
        let usernameStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [usernameNode,usernameSeparator])
        
        let passwordStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [passwordNode,passwordSeparator])
        
        let entryStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 40, justifyContent: .start, alignItems: .center, children: [usernameStack, passwordStack])
        
        let upperStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 40, justifyContent: .start, alignItems: .start, children: [vertStack, entryStack])
        
        let upperFinal = ASStackLayoutSpec.init(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .center, children: [upperStack, forgotPasswordNode])
        
        let phoneStack = ASStackLayoutSpec.init(direction: .horizontal, spacing: 5, justifyContent: .spaceBetween, alignItems: .center, children: [phoneIcon, viaPhoneNumberText, arrowImage])
        
        let lowerStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .center, children: [loginButton, phoneStack])
        
        let finalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [upperFinal, lowerStack])
        
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 30, left: 8, bottom: 30, right: 8), child: finalStack)
        
        
    }
    
}

extension SignInNode: ASEditableTextNodeDelegate {
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
        
        switch editableTextNode{
        case usernameNode:
            passwordNode.becomeFirstResponder()
        case passwordNode:
            passwordNode.resignFirstResponder()
        default:
            break
        }
    }
}
