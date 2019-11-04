//
//  InviteController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/2/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class InviteController: ASViewController<ASDisplayNode> {
    
    
    
    init() {
        super.init(node: InviteNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
