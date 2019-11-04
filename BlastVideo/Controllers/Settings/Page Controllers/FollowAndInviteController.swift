//
//  FollowAndInviteController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class FollowAndInviteController: ASViewController<ASDisplayNode> {
    
    init() {
        super.init(node: FollowAndInviteNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
