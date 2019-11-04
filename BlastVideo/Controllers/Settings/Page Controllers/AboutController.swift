//
//  AboutController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class AboutController: ASViewController<AboutNode> {
    
    init() {
        super.init(node: AboutNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
