//
//  FilterCellNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/7/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit

class FilterCellNode: ASCellNode {
    
    // MARK: - Variables
    let contentNode: FilterContentNode
    
    // MARK: - Object life cycle
    init(filterType: FilterType, image: UIImage) {
        self.contentNode = FilterContentNode(filterType: filterType, image: image)
        super.init()
        self.selectionStyle = .none
        automaticallyManagesSubnodes = true
        
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), child: contentNode)
        return insets
    }
}

class FilterContentNode: ASDisplayNode {
    
    // MARK: - Variables
    let filterNode: FilterNode
    
    // MARK: - Object life cycle
    init(filterType: FilterType, image: UIImage) {
        self.filterNode = FilterNode(filterType: filterType, image: image)
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.backgroundColor = .white
        self.borderWidth = 2.0
        self.borderColor = UIColor.white.cgColor
        self.shadowColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
        self.shadowOpacity = 0.5
        self.shadowRadius = 4.0
        self.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2), child: filterNode)
        return inset
        
    }
    
}
