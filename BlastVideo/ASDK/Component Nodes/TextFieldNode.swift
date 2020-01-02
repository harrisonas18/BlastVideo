//
//  File.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import Foundation
import UIKit
import AsyncDisplayKit

class TextFieldNode: ASDisplayNode {
    
    var textFieldNode: UITextField? {
        return self.view as? UITextField
    }
    
    init(height: CGFloat, width: CGFloat) {
        super.init()
        self.setViewBlock({
            let textField: UITextField = .init(frame: CGRect(x: 0, y: 0, width: width, height: height))
            return textField
        })
        self.style.height = .init(unit: .points, value: height)
        self.style.width = .init(unit: .points, value: width)

    }
    
}
