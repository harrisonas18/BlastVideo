//
//  SettingsDisplayNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/25/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsDisplayNode: ASCellNode {
            
        // MARK: - Variables
    let contentNode: SettingsDisplayContentNode
        
        // MARK: - Object life cycle
    override init() {
        self.contentNode = SettingsDisplayContentNode()
        super.init()
        self.selectionStyle = .default
        automaticallyManagesSubnodes = true
        contentNode.style.width = ASDimensionMake("100%")
    }
        
        override func didLoad() {
            super.didLoad()
            self.backgroundColor = .white
//            self.borderColor = UIColor.red.cgColor
//            self.borderWidth = 1.0
        }
        
        // MARK: - Layout
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            
            let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: contentNode)
            return insets
        }
}

class SettingsDisplayContentNode: ASDisplayNode {
    
    // MARK: - Variables
    
    let settingIcon: ASImageNode = {
        let node = ASImageNode()
        node.image = UIImage(named: "settings")
        node.tintColor = .black
        node.style.preferredSize = CGSize(width: 24, height: 24)
        node.contentMode = .scaleAspectFit
        return node
    }()
    
    let settingTitle: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Setting", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        return node
    }()
    
    let arrowIcon: ASImageNode = {
        let node = ASImageNode()
        node.image = UIImage(named: "next-page")
        node.style.preferredSize = CGSize(width: 24, height: 24)
        node.contentMode = .scaleAspectFit
        node.tintColor = .black
        return node
    }()
    
    
    // MARK: - Object life cycle
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
    }
    
    override func didLoad() {
        super.didLoad()
//        self.borderColor = UIColor.gray.cgColor
//        self.borderWidth = 1.0
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let horzStack = ASStackLayoutSpec.init(direction: .horizontal,
                                               spacing: 8.0,
                                               justifyContent: .start,
                                               alignItems: .center,
                                               children: [settingIcon, settingTitle])
        let cellHorzStack = ASStackLayoutSpec.init(direction: .horizontal,
                                               spacing: 8.0,
                                               justifyContent: .spaceBetween,
                                               alignItems: .center,
                                               children: [horzStack, arrowIcon])
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8), child: cellHorzStack)
        
        return inset
        
    }
    
}
    

