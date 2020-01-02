//
//  EditProfileScrollController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/15/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class EditProfileScrollController: ASViewController<ASScrollNode> {
    
    let scrollNode:ASScrollNode
    
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
            stack.children = [EditProfileScrollNode(user: UserObject())]
            
            return stack
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetEmail), name: Notification.Name("offsetEmailNode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetPhone), name: Notification.Name("offsetPhoneNode"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetEmailNode"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetPhoneNode"), object: nil)
    }
    
    @objc func offsetEmail(){
        scrollNode.view.contentOffset = CGPoint(x: 0, y: 200)
    }
    
    @objc func offsetPhone(){
        scrollNode.view.contentOffset = CGPoint(x: 0, y: 240)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollNode.view.alwaysBounceVertical = true
        title = "Edit Profile"
        self.hideKeyboardWhenTappedAround()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
