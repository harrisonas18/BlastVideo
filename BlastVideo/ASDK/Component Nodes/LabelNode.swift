//
//  LabelNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/11/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class LabelNode: ASDisplayNode {
    
    var labelNode: UILabel? {
        return self.view as? UILabel
    }
    
    init(height: CGFloat, width: CGFloat) {
        super.init()
        isUserInteractionEnabled = true
        self.setViewBlock({
            let textField: UILabel = .init(frame: CGRect(x: 0, y: 0, width: width, height: height))
            return textField
        })
        self.style.height = .init(unit: .points, value: height)
        self.style.width = .init(unit: .points, value: width)

    }
    
}
