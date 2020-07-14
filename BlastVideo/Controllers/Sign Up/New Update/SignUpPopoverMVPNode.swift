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
    
    var signUpDelegate: SignUpInfoDelegate?
    
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
    
    let passwordValidImg: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFit
        node.alpha = 0
        node.image = #imageLiteral(resourceName: "GreenCheck")
        node.style.preferredSize = CGSize(width: 25, height: 25)
        return node
        
    }()
    
    let dateOfBirth: TextFieldNode = {
        let node = TextFieldNode(height: 55, width: 155)
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.textFieldNode?.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!])
        node.textFieldNode?.borderStyle = .roundedRect
        node.textFieldNode?.keyboardType = .numberPad
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
    
    let errorMessage: LabelNode = {
        let node = LabelNode(height: 60, width: UIScreen.screenWidth()*0.75)
        node.isUserInteractionEnabled = false
        node.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, passwords don't match.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
        node.style.preferredLayoutSize.width = ASDimensionMake("75%")
        node.style.preferredLayoutSize.height = ASDimensionMake("30pt")
        node.labelNode?.textAlignment = .left
        node.labelNode?.numberOfLines = 0
        return node
    }()
    
    @objc func signupButtonTapped(){
        view.endEditing(true)
        
        
        guard let emailText = emailAddress.textFieldNode?.text, !emailText.isEmpty else {
            errorMessage.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, email error", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
            errorMessage.isHidden = false
            return
        }
        guard let usernameText = username.textFieldNode?.text, !usernameText.isEmpty else {
            errorMessage.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, username error", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
            errorMessage.isHidden = false
            return
        }
        guard let passwordText = password.textFieldNode?.text, !passwordText.isEmpty else {
            errorMessage.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, password error", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
            errorMessage.isHidden = false
            return
        }
        guard let repeatPasswordText = repeatPassword.textFieldNode?.text, !repeatPasswordText.isEmpty else {
            errorMessage.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, repeat password error", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
            errorMessage.isHidden = false
            return
        }
        
        usernameValid(username: usernameText) { (isValid) in
            if isValid {
                if (passwordText == repeatPasswordText){
                    self.errorMessage.isHidden = true
                    self.signUpDelegate?.getSignUpInfo(username: usernameText, email: emailText, password: passwordText)
                } else {
                    self.errorMessage.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, passwords don't match.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
                    self.repeatPassword.textFieldNode?.layer.borderColor = UIColor.red.cgColor
                    self.errorMessage.isHidden = false
                }
            } else {
                print("Return")
                return
            }
        }
        
        
        
    }
    
    func usernameValid(username: String, completion: @escaping (Bool) -> Void) {
        Api.Auth.verifyUsername(username: username, onSuccess: {
            self.errorMessage.isHidden = true
            completion(true)
        }) { (error) in
            self.errorMessage.labelNode?.attributedText = NSAttributedString(string: "Error Signing in, username taken.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)])
            self.errorMessage.isHidden = false
            completion(false)
        }
    }
    
    
    let SignInLabel: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = true
        node.attributedText = NSAttributedString(string: "Already a member? Sign In", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .light)])
        node.style.preferredLayoutSize.width = ASDimensionMake("90%")
        node.style.preferredLayoutSize.height = ASDimensionMake("30pt")
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        errorMessage.isHidden = true
        signUpButton.addTarget(self, action: #selector(signupButtonTapped), forControlEvents: .touchUpInside)
        SignInLabel.addTarget(self, action: #selector(signInLabelTapped), forControlEvents: .touchUpInside)
        
    }
    
    override func didLoad() {
        super.didLoad()
        
        repeatPassword.textFieldNode?.delegate = self
        dateOfBirth.textFieldNode?.delegate = self
    }
    
    
    
    @objc func signInLabelTapped(){
        //Push Sign In View Controller
        //Dismiss View Controller to previous Call to action screen
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let logoStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center, children: [logoNode])
        
        let formStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center, children: [errorMessage, emailAddress, username, password, repeatPassword])
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n"{
            textField.resignFirstResponder()
        }
        
        if range.length + range.location > password.textFieldNode?.text?.count ?? 0 {
            return false
        }
        
        let newLength = password.textFieldNode?.text?.count ?? 0 + string.count - range.length
        return newLength <= 30
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.text ?? "")
    }
    
}

extension SignUpPopoverMVPNode: ASEditableTextNodeDelegate {
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
        _ = 140 - textCount
        
        //delegate?.getCaptionText(text: editableTextNode.textView.text)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        
        guard testStr != nil else { print("returned false"); return false }
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=\\P{Ll}*\\p{Ll})(?=\\P{Lu}*\\p{Lu})(?=\\P{N}*\\p{N})(?=[\\p{L}\\p{N}]*[^\\p{L}\\p{N}])[\\s\\S]{8,}$")
        
        return passwordTest.evaluate(with: testStr)
        
    }
    
    func editableTextNodeDidFinishEditing(_ editableTextNode: ASEditableTextNode) {
        
        switch editableTextNode {
        case username:
            password.becomeFirstResponder()
        case password:
            password.resignFirstResponder()
        default:
            break
        }
        
        
    }
    
    
}
