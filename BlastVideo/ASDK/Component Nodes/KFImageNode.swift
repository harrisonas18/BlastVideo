//
//  KFImageNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 7/15/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class KFImageNode: ASImageNode {
    
    var imageView: UIImageView? {
        return self.view as? UIImageView
    }
    
    init(size: CGSize) {
        super.init()
        self.setViewBlock({
            let imageView: UIImageView = .init(frame: .zero)
            return imageView
        })
        self.style.height = .init(unit: .points, value: size.height)
        self.style.width = .init(unit: .points, value: size.width)
    }
}
