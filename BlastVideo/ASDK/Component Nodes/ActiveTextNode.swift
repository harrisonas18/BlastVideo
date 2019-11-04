//
//  ActiveTextNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/17/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import ActiveLabel

class ActiveTextNode: ASDisplayNode {
    
    var labelNode: ActiveLabel? {
        return self.view as? ActiveLabel
    }
    
    init(text: String, font: UIFont, width: CGFloat) {
        super.init()
        self.setViewBlock({
            let labelView: ActiveLabel = .init(frame: .zero)
            labelView.numberOfLines = 0
            labelView.hashtagColor = .black
            return labelView
        })
        self.style.height = ASDimensionMake(heightForView(text: text, font: font, width: width))
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
