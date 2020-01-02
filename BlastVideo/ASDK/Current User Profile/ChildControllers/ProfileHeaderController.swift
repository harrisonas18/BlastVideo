//
//  ProfileCellControllerNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ProfileHeaderController: ASViewController<ProfileHeaderNode> {
    
    
    
    // MARK: - Object life cycle
    init() {
        super.init(node: ProfileHeaderNode())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
