//
//  EditProfileViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EditProfileViewController: ASViewController<ASDisplayNode> {
    
    var user: UserObject?
    
    init(user: UserObject) {
        self.user = user
        super.init(node: ASDisplayNode())
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
