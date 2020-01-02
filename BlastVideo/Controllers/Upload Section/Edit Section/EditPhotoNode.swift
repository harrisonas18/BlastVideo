//
//  EditPhotoNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/7/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PhotosUI

protocol EditPhotoDelegate {
    func getCaptionText(text: String)
}

class EditPhotoNode: ASDisplayNode {
    
    var livePhoto: PHLivePhoto
    var delegate: EditPhotoDelegate?
    //var node: ASVideoNode
    
    let captionNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.textView.typingAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.black]
        node.returnKeyType = UIReturnKeyType.done
        node.attributedPlaceholderText = NSAttributedString(string: "Write a Caption...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        node.textContainerInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        node.keyboardType = UIKeyboardType.twitter
        node.style.preferredLayoutSize.width = ASDimensionMake("100%")
        node.style.preferredLayoutSize.height = ASDimensionMake("100%")
        return node
    }()
    
    let captionCount: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "140", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        node.style.height = ASDimensionMake("25pt")
        return node
    }()
    
    let divider: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.lightGray
        node.style.height = ASDimensionMake("1pt")
        node.style.width = ASDimensionMake("100%")
        return node
    }()
    
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
    
    //var filterNode: FilterNode
    
    init(livePhoto: PHLivePhoto) {
        self.livePhoto = livePhoto
        //self.filterNode = FilterNode(filterType: filterType)
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = UIColor.white
        captionNode.delegate = self

    }
    
    override func didLoad() {
        super.didLoad()
        livePhotoNode.livePhoto = livePhoto
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let captionStack = ASStackLayoutSpec.horizontal()
        captionStack.alignItems = .center
        captionStack.justifyContent = .start
        captionStack.children = [captionNode]
        captionStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        captionStack.style.preferredLayoutSize.height = ASDimensionMake("155pt")

        let countStack = ASStackLayoutSpec.horizontal()
        countStack.alignItems = .center
        countStack.justifyContent = .end
        countStack.children = [captionCount]
        countStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        
        let captStack = ASStackLayoutSpec.vertical()
        captStack.alignItems = .start
        captStack.justifyContent = .start
        captStack.children = [captionStack, countStack]
        captStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        captStack.style.preferredLayoutSize.height = ASDimensionMake("100%")
        captStack.style.flexShrink = 1.0
        
        let photoStack = ASStackLayoutSpec.vertical()
        photoStack.spacing = -1.0
        photoStack.alignItems = .start
        photoStack.justifyContent = .start
        photoStack.children = [livePhotoNode]
        photoStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        photoStack.style.preferredLayoutSize.height = ASDimensionMake("100%")
        photoStack.style.flexShrink = 1.0
        
        let horzStack = ASStackLayoutSpec.horizontal()
        horzStack.spacing = 8.0
        horzStack.alignItems = .start
        horzStack.justifyContent = .start
        horzStack.children = [livePhotoNode, captStack]
        horzStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        horzStack.style.flexShrink = 1.0
        
        let vertStack = ASStackLayoutSpec.vertical()
        vertStack.alignItems = .start
        vertStack.justifyContent = .start
        vertStack.spacing = 8.0
        vertStack.children = [horzStack, divider]
        vertStack.style.preferredLayoutSize.width = ASDimensionMake("100%")
        vertStack.style.preferredLayoutSize.height = ASDimensionMake("100%")

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0), child: vertStack)
        
    }
    
}


extension EditPhotoNode: ASEditableTextNodeDelegate {
    
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            editableTextNode.resignFirstResponder()
        }
        if range.length + range.location > editableTextNode.textView.text.count {
            return false
        }
        let newLength = editableTextNode.textView.text.count + text.count - range.length
        return newLength <= 140
        
    }
    
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        
        let textCount = editableTextNode.textView.text.count
        let countLeft = 140 - textCount
        
        delegate?.getCaptionText(text: editableTextNode.textView.text)
        
        captionCount.attributedText = NSAttributedString(string: "\(countLeft)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        
    }
    
    
}
