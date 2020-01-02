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
    
    let activity = UIActivityIndicatorView(style: .white)

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
        node.style.height = ASDimensionMake("25%")
        node.showsHorizontalScrollIndicator = false
//        node.layer.borderColor = UIColor.black.cgColor
//        node.layer.borderWidth = 2.0
        return node
    }()
    
    //var filterNode: FilterNode
    
    init(livePhoto: PHLivePhoto) {
        self.livePhoto = livePhoto
        super.init()
        addSubnode(livePhotoNode)
        addSubnode(filterCollectionNode)
        self.backgroundColor = UIColor.white
        livePhotoNode.style.width = ASDimensionMake("100%")
        livePhotoNode.style.height = ASDimensionMake("100%")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("livePhotoFilterActivity"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("livePhotoFilterActivityOff"), object: nil)
    }
    
    override func didLoad() {
        super.didLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(activityOn), name: Notification.Name("livePhotoFilterActivity"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(activityOff), name: Notification.Name("livePhotoFilterActivityOff"), object: nil)
        livePhotoNode.livePhoto = livePhoto
//        self.layer.borderColor = UIColor.containerBorderColor().cgColor
//        self.layer.borderWidth = 1.0
        
        livePhotoNode.photoNode?.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: livePhotoNode.photoNode!.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: livePhotoNode.photoNode!.centerXAnchor),
            activity.widthAnchor.constraint(equalToConstant: 50),
            activity.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    @objc func activityOn(){
        activity.startAnimating()
    }
    
    @objc func activityOff(){
        activity.stopAnimating()
    }
    
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let filterInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 35, right: 0), child: filterCollectionNode)
        
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
        vertStack.children = [photoStack, filterInset]
        vertStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        vertStack.style.preferredLayoutSize.height = ASDimensionMake("100%")
        vertStack.style.flexShrink = 1.0
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0), child: vertStack)
        
    }
}
