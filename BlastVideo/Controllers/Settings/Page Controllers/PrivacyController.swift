//
//  PrivacyController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class PrivacyController: ASViewController<ASDisplayNode> {
    
    init() {
        super.init(node: PrivacyNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
