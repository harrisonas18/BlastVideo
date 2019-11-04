//
//  FilterNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import PhotosUI

class FilterNode: ASDisplayNode {
    
    let imageNode: ASImageNode = {
        let node = ASImageNode()
        let width = ASDimensionMake("100%")
        let height = ASDimensionMake("100%")
        node.style.preferredLayoutSize = ASLayoutSizeMake(width, height)
        node.style.flexShrink = 1.0
        return node
    }()
    
    let textNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    let colorNode: ASDisplayNode = {
        let node = ASDisplayNode()
        return node
    }()
    
    let selectedImage: UIImage
    
    init(filterType: FilterType, image: UIImage) {
        self.selectedImage = image
        super.init()
        let filter = filterBackground(filterType: filterType)
        automaticallyManagesSubnodes = true
        colorNode.backgroundColor = filter.0
        textNode.attributedText = NSAttributedString(string: filter.1 , attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
        colorNode.style.width = ASDimensionMake("100%")
        colorNode.style.height = ASDimensionMake("20%")
        self.imageNode.image = filter.2
        
    }
    override func didLoad() {
        super.didLoad()
        imageNode.contentMode = .scaleAspectFill
        
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: textNode)
        
        let overlay = ASOverlayLayoutSpec(child: colorNode, overlay: center)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.alignItems = .center
        stack.justifyContent = .center
        stack.spacing = 4.0
        stack.children = [imageNode, overlay]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), child: stack)
    }
    
    private func filterBackground(filterType: FilterType) -> (UIColor, String, UIImage) {
        switch filterType {
        case .CIPhotoEffectFade:
            return (UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0),
                    "Fade",
                    selectedImage.addFilter(filter: .CIPhotoEffectFade))
        case .CIPhotoEffectChrome:
            return (UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0),
                    "Chrome",
                    selectedImage.addFilter(filter: .CIPhotoEffectChrome))
        case .CIPhotoEffectTransfer:
            return (UIColor(red: 155.0/255.0, green: 89.0/255.0, blue: 182.0/255.0, alpha: 1.0),
                    "Transfer",
                    selectedImage.addFilter(filter: .CIPhotoEffectTransfer))
        case .CIPhotoEffectInstant:
            return (UIColor(red: 241.0/255.0, green: 196.0/255.0, blue: 15.0/255.0, alpha: 1.0),
                    "Instant",
                    selectedImage.addFilter(filter: .CIPhotoEffectInstant))
        case .CIPhotoEffectMono:
            return (UIColor(red: 230.0/255.0, green: 126.0/255.0, blue: 34.0/255.0, alpha: 1.0),
                    "Mono",
                    selectedImage.addFilter(filter: .CIPhotoEffectMono))
        case .CIPhotoEffectNoir:
            return (UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0),
                    "Noir",
                    selectedImage.addFilter(filter: .CIPhotoEffectNoir))
        case .CIPhotoEffectProcess:
            return (UIColor(red: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1.0),
                    "Process",
                    selectedImage.addFilter(filter: .CIPhotoEffectProcess))
        case .CIPhotoEffectTonal:
            return (UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0),
                    "Tonal",
                    selectedImage.addFilter(filter: .CIPhotoEffectTonal))
        default:
            return (UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0),
                    "None",
                    self.selectedImage)
        }
    }
    
}

enum FilterType: String {
    case None = "None",
    CIPhotoEffectFade = "CIPhotoEffectFade",
    CIPhotoEffectChrome = "CIPhotoEffectChrome",
    CIPhotoEffectTransfer = "CIPhotoEffectTransfer",
    CIPhotoEffectInstant = "CIPhotoEffectInstant",
    CIPhotoEffectMono = "CIPhotoEffectMono",
    CIPhotoEffectNoir = "CIPhotoEffectNoir",
    CIPhotoEffectProcess = "CIPhotoEffectProcess",
    CIPhotoEffectTonal = "CIPhotoEffectTonal"
    
    static let allValues = [
        None,
        CIPhotoEffectFade,
        CIPhotoEffectChrome,
        CIPhotoEffectTransfer,
        CIPhotoEffectInstant,
        CIPhotoEffectMono,
        CIPhotoEffectNoir,
        CIPhotoEffectProcess,
        CIPhotoEffectTonal
    ]
}
