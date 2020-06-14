//
//  SignInMVPController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/13/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.

import Foundation
import AsyncDisplayKit
import GradientLoadingBar

class SignInMVPController: ASViewController<ASScrollNode> {
    
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
            stack.children = [SignInMVPNode()]
            
            return stack
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetRepeatPassword), name: Notification.Name("offsetRepeatPasswordNode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetDateOfBirth), name: Notification.Name("offsetDateOfBirthNode"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetRepeatPasswordNode"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetDateOfBirthNode"), object: nil)
    }
    
    @objc func offsetRepeatPassword(){
        //Animate so it looks smoother
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.scrollNode.view.contentOffset = CGPoint(x: 0, y: 100)
        })
        
    }
    
    @objc func offsetDateOfBirth(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.scrollNode.view.contentOffset = CGPoint(x: 0, y: 100)
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollNode.view.alwaysBounceVertical = true
        self.hideKeyboardWhenTappedAround()
        
//        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
//        rightButton.tintColor = .black
//        self.navigationItem.rightBarButtonItem = rightButton
        
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

