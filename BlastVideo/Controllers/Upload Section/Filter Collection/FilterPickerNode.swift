//
//  FilterTestController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/7/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI
import AsyncDisplayKit

class FilterPickerNode: ASDisplayNode {
    
    var livePhoto: PHLivePhoto

    let livePhotoNode: LivePhotoNode = {
        let node = LivePhotoNode(height: 180.0, width: 140.0)
        node.borderWidth = 2.0
        node.borderColor = UIColor.white.cgColor
        node.shadowColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
        node.shadowOpacity = 0.5
        node.shadowRadius = 4.0
        node.shadowOffset = CGSize(width: 0, height: 0)
        return node
    }()
    
    let filterCollectionNode: ASCollectionNode = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4.0
        layout.sectionInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        let node = ASCollectionNode(collectionViewLayout: layout)
        node.style.width = ASDimensionMake("100%")
        node.style.height = ASDimensionMake("30%")
//        node.layer.borderColor = UIColor.black.cgColor
//        node.layer.borderWidth = 2.0
        return node
    }()
    
    //var filterNode: FilterNode
    
    init(livePhoto: PHLivePhoto) {
        self.livePhoto = livePhoto
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        livePhotoNode.style.width = ASDimensionMake("100%")
        livePhotoNode.style.height = ASDimensionMake("100%")
    }
    
    override func didLoad() {
        super.didLoad()
        livePhotoNode.livePhoto = livePhoto
//        self.layer.borderColor = UIColor.containerBorderColor().cgColor
//        self.layer.borderWidth = 1.0
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let photoStack = ASStackLayoutSpec.vertical()
        photoStack.spacing = -1.0
        photoStack.alignItems = .start
        photoStack.justifyContent = .start
        photoStack.children = [livePhotoNode]
        photoStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        photoStack.style.preferredLayoutSize.height = ASDimensionMake("100%")
        photoStack.style.flexShrink = 1.0
        
        let vertStack = ASStackLayoutSpec.vertical()
        vertStack.alignItems = .start
        vertStack.justifyContent = .start
        vertStack.spacing = 8.0
        vertStack.children = [photoStack, filterCollectionNode]
        vertStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        vertStack.style.preferredLayoutSize.height = ASDimensionMake("100%")
        vertStack.style.flexShrink = 1.0
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0), child: vertStack)
        
    }
}
