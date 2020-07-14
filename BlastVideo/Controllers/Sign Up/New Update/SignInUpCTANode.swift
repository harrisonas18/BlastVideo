//
//  SignInUpCTANode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/10/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import Foundation
import AsyncDisplayKit

class SignInUpCTANode: ASDisplayNode {
    
    let logoNode: ASImageNode = {
        let node = ASImageNode()
        node.isUserInteractionEnabled = false
        node.image = #imageLiteral(resourceName: "LogoAPM")
        node.style.preferredLayoutSize.width = ASDimensionMake("100pt")
        node.style.preferredLayoutSize.height = ASDimensionMake("100pt")
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    let ctaHeader: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = false
        node.style.preferredLayoutSize.width = ASDimensionMake("100%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.attributedText = NSAttributedString(string: "Why Sign Up?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 44)!])
        node.maximumNumberOfLines = 0
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    let joinNowLabel: ASTextNode = {
        let node = ASTextNode()
        node.isUserInteractionEnabled = false
        node.style.preferredLayoutSize.width = ASDimensionMake("100%")
        //node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.attributedText = NSAttributedString(string: "Join Now", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 24)!])
        //node.textFieldNode?.borderStyle = .roundedRect
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    let detailTextLabel: LabelNode = {
        let node = LabelNode(height: 85, width: UIScreen.screenWidth())
        node.isUserInteractionEnabled = false
        //node.style.preferredLayoutSize.width = ASDimensionMake("65%")
        //node.style.preferredLayoutSize.height = ASDimensionMake("90%")
        node.labelNode?.attributedText = NSAttributedString(string: "Get access to exclusive content and enjoy APM’s Live Photo experience! Connect with friends and see their Live Photo’s.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18)!])
        node.labelNode?.numberOfLines = 0
        node.labelNode?.textAlignment = .center
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    let joinButton: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.setTitle("Join Now", with: UIFont.systemFont(ofSize: 18), with: .black, for: .normal)
        node.style.preferredLayoutSize.width = ASDimensionMake("150pt")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.backgroundColor = .white
        node.borderColor = UIColor.lightGray.cgColor
        node.borderWidth = 1.0
        node.cornerRadius = 27.5
        return node
    }()
    
    let signInButton: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.setTitle("Sign In", with: UIFont.systemFont(ofSize: 18), with: .white, for: .normal)
        node.style.preferredLayoutSize.width = ASDimensionMake("150pt")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.backgroundColor = .black
        node.cornerRadius = 27.5
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    let exitButton: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.style.preferredLayoutSize.width = ASDimensionMake("50%")
        node.style.preferredLayoutSize.height = ASDimensionMake("55pt")
        node.setImage(#imageLiteral(resourceName: "BlackX"), for: .normal)
//        node.borderColor = UIColor.black.cgColor
//        node.borderWidth = 1.0
        return node
    }()
    
    
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        joinButton.addTarget(self, action: #selector(joinButtonPressed), forControlEvents: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), forControlEvents: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitButtonPressed), forControlEvents: .touchUpInside)
    }
    
    override func didLoad() {
        super.didLoad()
        
    
    }
    
    @objc func exitButtonPressed(){
        //print("Exit button pressed")
        //Observer located in NewFeedDesignController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissCTANode"), object: nil)
    }
    
    @objc func joinButtonPressed(){
        //print("Join button pressed")
        //Observer located in SignInUpCTAController 
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushSignUpVCfromCTA"), object: nil)
    }
    
    @objc func signInButtonPressed(){
        //print("Sign In button pressed")
        //Observer located in SignInUpCTAController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushSignInVCfromCTA"), object: nil)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let exitButtonStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 2, justifyContent: .center, alignItems: .end, children: [exitButton])
        //exitButtonStack.style.width = ASDimensionMake("50%")
        
        let centeredCTA = ASStackLayoutSpec.init(direction: .horizontal, spacing: 2, justifyContent: .spaceAround, alignItems: .center, children: [ctaHeader])
        
        let joinNowStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 6, justifyContent: .center, alignItems: .center, children: [joinNowLabel, detailTextLabel])
        //joinNowStack.style.width = ASDimensionMake("65%")
        
        let joinNowStackInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: joinNowStack)
        
        let upperStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center, children: [centeredCTA, logoNode, joinNowStackInset])
        
        let buttonStack = ASStackLayoutSpec.init(direction: .horizontal, spacing: 20, justifyContent: .center, alignItems: .center, children: [joinButton, signInButton])
        buttonStack.style.width = ASDimensionMake("90%")
        
        let buttonInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: buttonStack)
        
        let finalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 30, justifyContent: .start, alignItems: .center, children: [upperStack, buttonInset])
        
        let lastStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .end, children: [exitButtonStack, finalStack])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), child: lastStack)
        
    }
    
}
