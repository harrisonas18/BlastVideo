//
//  SignInUpCTA.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/10/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import Foundation
import AsyncDisplayKit
import GradientLoadingBar

class SignInUpCTAController: ASViewController<ASScrollNode> {
    
    let scrollNode : ASScrollNode
    var gradientBar : GradientActivityIndicatorView?
    
    init() {
      
        scrollNode = ASScrollNode()
        scrollNode.backgroundColor = .white
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.view.showsVerticalScrollIndicator = false
       
        super.init(node: scrollNode)
        
        scrollNode.layoutSpecBlock = { node, constrainedSize in
            let stack = ASStackLayoutSpec.vertical()
            stack.alignContent = .start
            
            stack.spacing = 8
            stack.children = [SignInUpCTANode()]
            
            return stack
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(offsetEmail), name: Notification.Name("offsetEmailNode"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(offsetPhone), name: Notification.Name("offsetPhoneNode"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetEmailNode"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetPhoneNode"), object: nil)
    }
    
    @objc func offsetEmail(){
        //Animate so it looks smoother
        scrollNode.view.contentOffset = CGPoint(x: 0, y: 200)
    }
    
    @objc func offsetPhone(){
        //Animate so it looks smoother of a transition
        scrollNode.view.contentOffset = CGPoint(x: 0, y: 240)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollNode.view.alwaysBounceVertical = true
        self.hideKeyboardWhenTappedAround()
        
//        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
//        rightButton.tintColor = .black
//        self.navigationItem.rightBarButtonItem = rightButton
        
          NotificationCenter.default.addObserver(self, selector: #selector(pushSignUp), name: Notification.Name("PushSignUpVCfromCTA"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(pushSignIn), name: Notification.Name("PushSignInVCfromCTA"), object: nil)
        
    }
    
    @objc func pushSignUp(){
        let vc = SignUpPopoverMVP()
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func pushSignIn(){
        let vc = SignInMVPController()
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    
    @objc func saveSettings(){
        //Save currentUser
        //Save to database
        //Begin Loading animation
        gradientBar?.fadeIn()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


