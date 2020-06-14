//
//  SignUpPopoverMVPNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/10/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SignUpPopoverMVPNode: ASDisplayNode {
    
    let logoNode: ASImageNode = {
        let node = ASImageNode()
        node.isUserInteractionEnabled = false
        node.image = #imageLiteral(resourceName: "LogoAPM")
        node.style.preferredLayoutSize.width = ASDimensionMake("100pt")
        node.style.preferredLayoutSize.height = ASDimensionMake("100pt")
        return node
    }()
    
    let emailAddress: TextFieldNode = {
        let node = TextFieldNode(height: 55, width: 155)
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.textFieldNode?.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!])
        node.textFieldNode?.borderStyle = .roundedRect
        node.textFieldNode?.font = UIFont(name: "HelveticaNeue-Thin", size: 24)!
        node.textFieldNode?.textColor = .black
        return node
    }()
    
    let username: TextFieldNode = {
        let node = TextFieldNode(height: 55, width: 155)
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.textFieldNode?.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!])
        node.textFieldNode?.borderStyle = .roundedRect
        node.textFieldNode?.font = UIFont(name: "HelveticaNeue-Thin", size: 24)!
        node.textFieldNode?.textColor = .black
        return node
    }()
    
    let password: TextFieldNode = {
        let node = TextFieldNode(height: 55, width: 155)
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.textFieldNode?.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!])
        node.textFieldNode?.borderStyle = .roundedRect
        node.textFieldNode?.isSecureTextEntry = true
        node.textFieldNode?.font = UIFont(name: "HelveticaNeue-Thin", size: 24)!
        node.textFieldNode?.textColor = .black
        return node
    }()
    
    let repeatPassword: TextFieldNode = {
        let node = TextFieldNode(height: 55, width: 155)
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.textFieldNode?.attributedPlaceholder = NSAttributedString(string: "Repeat Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!])
        node.textFieldNode?.borderStyle = .roundedRect
        node.textFieldNode?.isSecureTextEntry = true
        node.textFieldNode?.font = UIFont(name: "HelveticaNeue-Thin", size: 24)!
        node.textFieldNode?.textColor = .black
        return node
    }()
    
    let dateOfBirth: TextFieldNode = {
        let node = TextFieldNode(height: 55, width: 155)
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.textFieldNode?.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!])
        node.textFieldNode?.borderStyle = .roundedRect
        return node
    }()
    
    let tosPrivacyLabel: LabelNode = {
        let node = LabelNode(height: 60, width: UIScreen.screenWidth()*0.75)
        node.isUserInteractionEnabled = false
        node.labelNode?.attributedText = NSAttributedString(string: "By becoming a member you agree to our Terms of Use, and our Privacy Policy.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .medium)])
        node.style.preferredLayoutSize.width = ASDimensionMake("75%")
        node.style.preferredLayoutSize.height = ASDimensionMake("30pt")
        node.labelNode?.textAlignment = .center
        node.labelNode?.numberOfLines = 0
        return node
    }()
    
    let signUpButton: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.setTitle("Sign Up", with: UIFont.systemFont(ofSize: 24), with: .white, for: .normal)
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.backgroundColor = .black
        node.cornerRadius = 4.0
        return node
    }()
    
    let SignInLabel: LabelNode = {
        let node = LabelNode(height: 30, width: UIScreen.screenWidth()*0.90)
        node.isUserInteractionEnabled = true
        node.labelNode?.attributedText = NSAttributedString(string: "Already a member? Sign In", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .light)])
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("30pt")
        node.labelNode?.textAlignment = .center
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        
        
        
        
    }
    
    override func didLoad() {
        super.didLoad()
        repeatPassword.textFieldNode?.delegate = self
        dateOfBirth.textFieldNode?.delegate = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let logoStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center, children: [logoNode])
        
        let formStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center, children: [emailAddress, username, password, repeatPassword, dateOfBirth])
        
        let buttonStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 12, justifyContent: .start, alignItems: .center, children: [tosPrivacyLabel, signUpButton, SignInLabel])
        buttonStack.style.width = ASDimensionMake("100%")
        
        let finalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 30, justifyContent: .start, alignItems: .center, children: [logoStack, formStack, buttonStack])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: finalStack)
        
    }
    
}

extension SignUpPopoverMVPNode: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Text field did begin editing")
        switch textField {
        case repeatPassword.textFieldNode:
            print("Repeat password node notification called")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offsetRepeatPasswordNode"), object: nil)
            break
        case dateOfBirth.textFieldNode:
            print("Phone node notification called")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offsetDateOfBirthNode"), object: nil)
            break
        default:
            break
        }
    }
    
}
